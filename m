Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2EULbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 07:31:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48547 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2EULbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 07:31:07 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVO_8o_3UuwAHjJbVEk1ZmL+28KVngB7JikNxszct1yjkw@mail.gmail.com>
References: <1337234296-23313-1-git-send-email-ming.lei@canonical.com>
	<20120517182830.GA5254@kroah.com>
	<1337280518.4281.67.camel@twins>
	<CACVXFVO_8o_3UuwAHjJbVEk1ZmL+28KVngB7JikNxszct1yjkw@mail.gmail.com>
Date: Mon, 21 May 2012 19:31:03 +0800
Message-ID: <CACVXFVOaB1LO0JXNQuTE88hkUPVq8iobcWF1RSno73+6tTAx9Q@mail.gmail.com>
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in tty_lock_pair
From: Ming Lei <ming.lei@canonical.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 9:57 AM, Ming Lei <ming.lei@canonical.com> wrote:
> On Fri, May 18, 2012 at 2:48 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Thu, 2012-05-17 at 11:28 -0700, Greg Kroah-Hartman wrote:
>>> > +static void __lockfunc tty_lock_nest_lock(struct tty_struct *tty,
>>> > +             struct tty_struct *tty2)
>>>
>>> Duplicating tty_lock() just for this one issue seems wrong and prone to
>>> error, don't you think?
>>>
>>> > +{
>>> > +     if (tty->magic != TTY_MAGIC) {
>>> > +             printk(KERN_ERR "L Bad %p\n", tty);
>>> > +             WARN_ON(1);
>>> > +             return;
>>> > +     }
>>> > +     tty_kref_get(tty);
>>> > +     mutex_lock_nest_lock(&tty->legacy_mutex, &tty2->legacy_mutex);
>>
>> Yeah, its completely broken, even the lockdep annotation is the wrong
>> one.
>>
>> Something like the (completely untested) below patch is the 'right' way.
>
> Yes, it should be, but the warning is still triggered with the patch, also
> it is worse, kernel hanged during boot.
>
>> ---
>>  drivers/tty/tty_mutex.c |   35 ++++++++++++++++++++---------------
>>  1 file changed, 20 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
>> index 69adc80..587330b 100644
>> --- a/drivers/tty/tty_mutex.c
>> +++ b/drivers/tty/tty_mutex.c
>> @@ -10,7 +10,7 @@
>>  * Getting the big tty mutex.
>>  */
>>
>> -void __lockfunc tty_lock(struct tty_struct *tty)
>> +static void __lockfunc tty_lock_nested(struct tty_struct *tty, int subclass)
>>  {
>>        if (tty->magic != TTY_MAGIC) {
>>                printk(KERN_ERR "L Bad %p\n", tty);
>> @@ -18,7 +18,12 @@ void __lockfunc tty_lock(struct tty_struct *tty)
>>                return;
>>        }
>>        tty_kref_get(tty);
>> -       mutex_lock(&tty->legacy_mutex);
>> +       mutex_lock_nested(&tty->legacy_mutex, subclass);
>> +}
>> +
>> +void __lockfunc tty_lock(struct tty_struct *tty)
>> +{
>> +       tty_lock_nested(tty, 0);
>>  }
>>  EXPORT_SYMBOL(tty_lock);
>>
>> @@ -38,25 +43,25 @@ EXPORT_SYMBOL(tty_unlock);
>>  * Getting the big tty mutex for a pair of ttys with lock ordering
>>  * On a non pty/tty pair tty2 can be NULL which is just fine.
>>  */
>> -void __lockfunc tty_lock_pair(struct tty_struct *tty,
>> -                                       struct tty_struct *tty2)
>> +void __lockfunc tty_lock_pair(struct tty_struct *tty1, struct tty_struct *tty2)
>>  {
>> -       if (tty < tty2) {
>> -               tty_lock(tty);
>> -               tty_lock(tty2);
>> -       } else {
>> -               if (tty2 && tty2 != tty)
>> -                       tty_lock(tty2);
>> -               tty_lock(tty);
>> +       if (!tty2 || tty1 == tty2) {
>> +               tty_lock(tty1);
>> +               return;
>>        }
>> +
>> +       if (tty2 < tty1)
>> +               swap(tty1, tty2);
>
> That is too crazy.
>
>> +
>> +       tty_lock(tty1);
>> +       tty_lock_nested(tty2, SINGLE_DEPTH_NESTING);
>>  }
>>  EXPORT_SYMBOL(tty_lock_pair);
>>
>> -void __lockfunc tty_unlock_pair(struct tty_struct *tty,
>> -                                               struct tty_struct *tty2)
>> +void __lockfunc tty_unlock_pair(struct tty_struct *tty1, struct tty_struct *tty2)
>>  {
>> -       tty_unlock(tty);
>> -       if (tty2 && tty2 != tty)
>> +       tty_unlock(tty1);
>> +       if (tty2 && tty2 != tty1)
>>                tty_unlock(tty2);
>>  }
>>  EXPORT_SYMBOL(tty_unlock_pair);
>>
>
> So how about the below one(tested OK)?

Looks no objections, I will prepare a formal one later, :-)

>
> diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
> index 69adc80..fecf592 100644
> --- a/drivers/tty/tty_mutex.c
> +++ b/drivers/tty/tty_mutex.c
> @@ -10,7 +10,8 @@
>  * Getting the big tty mutex.
>  */
>
> -void __lockfunc tty_lock(struct tty_struct *tty)
> +static void __lockfunc tty_lock_nested(struct tty_struct *tty,
> +               int subclass)
>  {
>        if (tty->magic != TTY_MAGIC) {
>                printk(KERN_ERR "L Bad %p\n", tty);
> @@ -18,7 +19,12 @@ void __lockfunc tty_lock(struct tty_struct *tty)
>                return;
>        }
>        tty_kref_get(tty);
> -       mutex_lock(&tty->legacy_mutex);
> +       mutex_lock_nested(&tty->legacy_mutex, subclass);
> +}
> +
> +void __lockfunc tty_lock(struct tty_struct *tty)
> +{
> +       tty_lock_nested(tty, 0);
>  }
>  EXPORT_SYMBOL(tty_lock);
>
> @@ -43,11 +49,14 @@ void __lockfunc tty_lock_pair(struct tty_struct *tty,
>  {
>        if (tty < tty2) {
>                tty_lock(tty);
> -               tty_lock(tty2);
> +               tty_lock_nested(tty2, SINGLE_DEPTH_NESTING);
>        } else {
> -               if (tty2 && tty2 != tty)
> +               int nested = 0;
> +               if (tty2 && tty2 != tty) {
>                        tty_lock(tty2);
> -               tty_lock(tty);
> +                       nested = SINGLE_DEPTH_NESTING;
> +               }
> +               tty_lock_nested(tty, nested);
>        }
>  }
>  EXPORT_SYMBOL(tty_lock_pair);


Thanks,
--
Ming Lei
