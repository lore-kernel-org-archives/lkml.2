Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab1HCSpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:45:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34202 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab1HCSpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:45:40 -0400
MIME-Version: 1.0
In-Reply-To: <m1r5521i7y.fsf@fess.ebiederm.org>
References: <20110602134338.0c56160e@lxorguk.ukuu.org.uk> <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
 <m1hb88e3qs.fsf@fess.ebiederm.org> <BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com>
 <20110608151732.2b321b9a.akpm@linux-foundation.org> <BANLkTinXwE0K5nJ649rhNxN06KvwLNDeCA@mail.gmail.com>
 <1307981153.1449.19.camel@mop> <CAMOw1v5veDqE+=gbNBn3juXHOOp764d7F20XtwUJXZoBW45zyg@mail.gmail.com>
 <CAPXgP12sxLmPXzXx_Qgf=JakmiZcuiMGmMKB8RG4sFU_U5f=jg@mail.gmail.com>
 <20110802231641.GA2598@suse.de> <20110803011250.GA27227@vigoh>
 <m18vra7rzs.fsf@fess.ebiederm.org> <CAMOw1v6ZJHDSMzck0YEjRbJmnoyPcrLmN4+-R5D7YRF-G=Lgrw@mail.gmail.com>
 <m1r5521i7y.fsf@fess.ebiederm.org>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Wed, 3 Aug 2011 15:45:20 -0300
Message-ID: <CAMOw1v6uCMhgErrfPLQ5CSa0v_OoHhJ=M3OCL+YH9H1Zg5fEXQ@mail.gmail.com>
Subject: Re: [PATCH] sysctl: add support for poll()
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        James Morris <jmorris@namei.org>, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Wed, Aug 3, 2011 at 3:08 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
>
>> On Wed, Aug 3, 2011 at 6:40 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>
>>> Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
>>>
>>> > @@ -176,6 +177,43 @@ static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
>>> >       return proc_sys_call_handler(filp, (void __user *)buf, count, ppos, 1);
>>> >  }
>>> >
>>> > +static int proc_sys_open(struct inode *inode, struct file *filp)
>>> > +{
>>> > +     struct ctl_table *table = PROC_I(inode)->sysctl_entry;
>>> > +
>>> > +     if (table->poll) {
>>> > +             unsigned long event = atomic_read(&table->poll->event);
>>> > +
>>> > +             filp->private_data = (void *)event;
>>>
>>> It would be nice if there was something that abstracted
>>> filp->private_data accesses so they were type safe, and
>>> clear what you were doing.
>>
>> private_data is used everywhere to save this private-per-inode data.
>> Here it's just the current number of events. It doesn't matter the
>> number, as long as when we wake up in the poll() we can compare these
>> numbers.
>
> It sure matters in code readablity if you have to cast the value
> every time.  A pair of light wrappers around filp->private_data
> that abstracts away the cast would be useful.

Ok, I'll put a wrapper here.

>
>>> > +static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
>>> > +{
>>> > +     struct inode *inode = filp->f_path.dentry->d_inode;
>>> > +     struct ctl_table *table = PROC_I(inode)->sysctl_entry;
>>> > +     unsigned long event = (unsigned long)filp->private_data;
>>> > +     unsigned int ret = POLLIN | POLLRDNORM;
>>>
>>> The default return value here must be DEFAULT_POLLMASK otherwise you
>>> change the result of poll for every single proc file and in general
>>
>> This is not true. This patch has nothing to do with proc files and
>> will not change their return values. However I did use the same return
>> values as used for proc files that support poll (see
>> fs/proc/base.c:mounts_poll()
>
> Apologies I meant /proc/sys/ files and it is absolutely true that
> you are changing the poll behavior of every sysctl with this change.
>
> /proc/mounts doesn't return writable because it doesn't support
> writes.  Most sysctl files support writes and thus should return
> writeable.
>>> return the wrong values because most sysctls are writable.
>>
>> For sysctl, there wasn't any poll support so how could I break
>> something that didn't exist?
>
> Not true.  There is the generic support of poll that happens
> when poll is not implemented.  For a generic file that does
> not implement specifically implement poll files return
> both readable and writable.
>
> Which ultimately is why we have to use POLLERR | POLLPRI
> and not the more obvious values of readable or writable.


Ok.


>>> > +     if (!table->proc_handler)
>>> > +             goto out;
>>> > +
>>> > +     if (!table->poll)
>>> > +             goto out;
>>> > +
>>> > +     poll_wait(filp, &table->poll->wait, wait);
>>> > +
>>> > +     if (event != atomic_read(&table->poll->event)) {
>>> > +             filp->private_data = (void *)(unsigned long)atomic_read(
>>> > +                                             &table->poll->event);
>>> > +             ret = POLLIN | POLLRDNORM | POLLERR | POLLPRI;
>>>
>>> Why are you updating the event here instead of when the file is read?
>>> Presumably we want until the file is read and people see the new value.
>>
>> This is to indicate, when we are polling the file , that the file
>> should be read again. When the process wake up we compare the filp's
>> copy of the event number with the one in table. Since they were the
>> same when the file was opened, if they are different now it indicates
>> the the file was updated and should be read again.
>>
>> There's no way to do this in read: we update table->poll->event
>> whenever the table entry is changed and when wakening up from
>> poll_wait() we compare if these values are the same.
>
> What do you mean there is no way to do this in read?
> That is how it is implemented in sysfs and it currently feels more
> intuitive.  There might be a semantic reason for not doing it in
> read that I am missing but it is certainly technically possible.

I thought you were saying that the *notification* should be done in
read. Now I understood that you are only saying that we should update
the value of `event' when the value is read.

Which one would be better for the following scenario?

1. users polls the file
2. wake up
3. don't read the file
4. poll again.

With my implementation he will be notified about the *new* changes
(the ones that happen after he decided to poll the file again).

In your case, he might get woken up because of the prior change. So
the user would always have to read the file after wakening  up.

[snip]
>>> > diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
>>> > index a2cd77e..e96b766 100644
>>> > --- a/kernel/utsname_sysctl.c
>>> > +++ b/kernel/utsname_sysctl.c
>>> > @@ -13,6 +13,7 @@
>>> >  #include <linux/uts.h>
>>> >  #include <linux/utsname.h>
>>> >  #include <linux/sysctl.h>
>>> > +#include <linux/wait.h>
>>> >
>>> >  static void *get_uts(ctl_table *table, int write)
>>> >  {
>>> > @@ -51,12 +52,28 @@ static int proc_do_uts_string(ctl_table *table, int write,
>>> >       uts_table.data = get_uts(table, write);
>>> >       r = proc_dostring(&uts_table,write,buffer,lenp, ppos);
>>> >       put_uts(table, write, uts_table.data);
>>> > +
>>> > +     if (write) {
>>> > +             atomic_inc(&table->poll->event);
>>> > +             wake_up_interruptible(&table->poll->wait);
>>>
>>> Duplicating code again?  Why are you not calling your generic notify?
>>
>> Duplicating? The uts_proc_notify() was only created so when user calls
>> hostname/domainname syscalls we wake up who is polling the
>> correspondent sysctl entries.
>
>> Here it's for the generic case in which we write to /proc/sysctl.
>
> Except the routine you have changed isn't for the generic case it
> is for a specific set of writes to domainname or hostname.
>
> I agree we need code on the update the value through sysctl path.
> However if you are going to go with a generic structure why not
> implement a generic function to update that structure.  Especially since
> you have two copies of this logic to update the notify logic already.

Ok.


thanks
Lucas De Marchi
