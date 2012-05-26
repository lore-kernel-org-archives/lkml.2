Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab2EZJX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 05:23:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43237 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab2EZJX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 05:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <1338016564.14636.4.camel@twins>
References: <1338000869-15129-1-git-send-email-ming.lei@canonical.com>
	<1338016564.14636.4.camel@twins>
Date: Sat, 26 May 2012 17:23:53 +0800
Message-ID: <CACVXFVNBiXxVvRWxnXiKPRm5dkj6qziFtXA_OH5kYFg4GZ+-pQ@mail.gmail.com>
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in tty_lock_pair(v3)
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

On Sat, May 26, 2012 at 3:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:

>
>
> I've still to hear what's wrong with a simple:
>
>
>  if (!tty2 || tty == tty2) {
>        tty_lock(tty);
>        return;
>  }
>
>  if (tty > tty2)
>        swap(tty, tty2);
>
>  tty_lock(tty);
>  tty_lock_nested(tty2, SINGLE_DEPTH_NESTING);

I remember that the patch may cause kernel hang in
my test. I will test it again to see if it is good.

>
>
> That's a lot more readable than the proposed code.
>
>> @@ -55,8 +64,13 @@ EXPORT_SYMBOL(tty_lock_pair);
>>  void __lockfunc tty_unlock_pair(struct tty_struct *tty,
>>                                               struct tty_struct *tty2)
>>  {
>> -     tty_unlock(tty);
>> -     if (tty2 && tty2 != tty)
>> +     if (tty < tty2) {
>>               tty_unlock(tty2);
>> +             tty_unlock(tty);
>> +     } else {
>> +             tty_unlock(tty);
>> +             if (tty2 && tty2 != tty)
>> +                     tty_unlock(tty2);
>> +     }
>>  }
>>  EXPORT_SYMBOL(tty_unlock_pair);
>
> This is complete crap, unlock order doesn't matter.

You mean that the below is good usage of lock?

        LOCK A
        LOCK B

        UNLOCK A
        UNLOCK B


Thanks,
--
Ming Lei
