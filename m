Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab1HCNRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:17:37 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54904 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab1HCNRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:17:32 -0400
MIME-Version: 1.0
In-Reply-To: <m18vra7rzs.fsf@fess.ebiederm.org>
References: <20110602134338.0c56160e@lxorguk.ukuu.org.uk> <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
 <m1hb88e3qs.fsf@fess.ebiederm.org> <BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com>
 <20110608151732.2b321b9a.akpm@linux-foundation.org> <BANLkTinXwE0K5nJ649rhNxN06KvwLNDeCA@mail.gmail.com>
 <1307981153.1449.19.camel@mop> <CAMOw1v5veDqE+=gbNBn3juXHOOp764d7F20XtwUJXZoBW45zyg@mail.gmail.com>
 <CAPXgP12sxLmPXzXx_Qgf=JakmiZcuiMGmMKB8RG4sFU_U5f=jg@mail.gmail.com>
 <20110802231641.GA2598@suse.de> <20110803011250.GA27227@vigoh> <m18vra7rzs.fsf@fess.ebiederm.org>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Wed, 3 Aug 2011 10:17:12 -0300
Message-ID: <CAMOw1v6ZJHDSMzck0YEjRbJmnoyPcrLmN4+-R5D7YRF-G=Lgrw@mail.gmail.com>
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

On Wed, Aug 3, 2011 at 6:40 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
>
> >>From dae691ba16a6c6c50ca05e2cd69bdc808f2c4f89 Mon Sep 17 00:00:00 2001
> > From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> > Date: Wed, 1 Jun 2011 09:14:36 -0300
> > Subject: [PATCH] sysctl: add support for poll()
> > Cc: linux-kernel@vger.kernel.org
> >
> > Adding support for poll() in sysctl fs allows userspace to receive
> > notifications when an entry in sysctl changes. This way it's possible to
> > know when hostname/domainname is changed due to the respective syscall
> > has been called or its file under /proc/sys has been written to.
>
> The patch breaks the return code of poll, is ugly, and it increases the
> size of struct ctl_table.
>
> I'm pretty certain I mentioned the return code breakage before.

And Kay already answered this. I'm answering each one now.

> In principle this is reasonable with the POLLERR | POLLPRI idiom but
> I'm not a fan of this code.
>
> Eric
>
>
>
> > Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> > Acked-By: Kay Sievers <kay.sievers@vrfy.org>
> > ---
> >  fs/proc/proc_sysctl.c   |   40 ++++++++++++++++++++++++++++++++++++++++
> >  include/linux/sysctl.h  |    8 ++++++++
> >  include/linux/utsname.h |   16 ++++++++++++++++
> >  kernel/sys.c            |    2 ++
> >  kernel/utsname_sysctl.c |   36 ++++++++++++++++++++++++++++++++++++
> >  5 files changed, 102 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> > index 1a77dbe..cf4bc7c 100644
> > --- a/fs/proc/proc_sysctl.c
> > +++ b/fs/proc/proc_sysctl.c
> > @@ -3,6 +3,7 @@
> >   */
> >  #include <linux/init.h>
> >  #include <linux/sysctl.h>
> > +#include <linux/poll.h>
> >  #include <linux/proc_fs.h>
> >  #include <linux/security.h>
> >  #include <linux/namei.h>
> > @@ -176,6 +177,43 @@ static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
> >       return proc_sys_call_handler(filp, (void __user *)buf, count, ppos, 1);
> >  }
> >
> > +static int proc_sys_open(struct inode *inode, struct file *filp)
> > +{
> > +     struct ctl_table *table = PROC_I(inode)->sysctl_entry;
> > +
> > +     if (table->poll) {
> > +             unsigned long event = atomic_read(&table->poll->event);
> > +
> > +             filp->private_data = (void *)event;
>
> It would be nice if there was something that abstracted
> filp->private_data accesses so they were type safe, and
> clear what you were doing.

private_data is used everywhere to save this private-per-inode data.
Here it's just the current number of events. It doesn't matter the
number, as long as when we wake up in the poll() we can compare these
numbers.

>
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
> > +{
> > +     struct inode *inode = filp->f_path.dentry->d_inode;
> > +     struct ctl_table *table = PROC_I(inode)->sysctl_entry;
> > +     unsigned long event = (unsigned long)filp->private_data;
> > +     unsigned int ret = POLLIN | POLLRDNORM;
>
> The default return value here must be DEFAULT_POLLMASK otherwise you
> change the result of poll for every single proc file and in general

This is not true. This patch has nothing to do with proc files and
will not change their return values. However I did use the same return
values as used for proc files that support poll (see
fs/proc/base.c:mounts_poll()

> return the wrong values because most sysctls are writable.

For sysctl, there wasn't any poll support so how could I break
something that didn't exist?


>
> > +     if (!table->proc_handler)
> > +             goto out;
> > +
> > +     if (!table->poll)
> > +             goto out;
> > +
> > +     poll_wait(filp, &table->poll->wait, wait);
> > +
> > +     if (event != atomic_read(&table->poll->event)) {
> > +             filp->private_data = (void *)(unsigned long)atomic_read(
> > +                                             &table->poll->event);
> > +             ret = POLLIN | POLLRDNORM | POLLERR | POLLPRI;
>
> Why are you updating the event here instead of when the file is read?
> Presumably we want until the file is read and people see the new value.

This is to indicate, when we are polling the file , that the file
should be read again. When the process wake up we compare the filp's
copy of the event number with the one in table. Since they were the
same when the file was opened, if they are different now it indicates
the the file was updated and should be read again.

There's no way to do this in read: we update table->poll->event
whenever the table entry is changed and when wakening up from
poll_wait() we compare if these values are the same.

Again, this is the same as done for other proc files that support
polling (see mm/swapfile.c:swaps_poll())

>
> > +     }
> > +
> > +out:
> > +     return ret;
> > +}
> >
> >  static int proc_sys_fill_cache(struct file *filp, void *dirent,
> >                               filldir_t filldir,
> > @@ -364,6 +402,8 @@ static int proc_sys_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
> >  }
> >
> >  static const struct file_operations proc_sys_file_operations = {
> > +     .open           = proc_sys_open,
> > +     .poll           = proc_sys_poll,
> >       .read           = proc_sys_read,
> >       .write          = proc_sys_write,
> >       .llseek         = default_llseek,
> > diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> > index 11684d9..96c89ba 100644
> > --- a/include/linux/sysctl.h
> > +++ b/include/linux/sysctl.h
> > @@ -25,6 +25,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/types.h>
> >  #include <linux/compiler.h>
> > +#include <linux/wait.h>
> >
> >  struct completion;
> >
> > @@ -1011,6 +1012,12 @@ extern int proc_do_large_bitmap(struct ctl_table *, int,
> >   * cover common cases.
> >   */
> >
> > +/* Support for userspace poll() to watch for changes */
> > +struct ctl_table_poll {
> > +     atomic_t event;
> > +     wait_queue_head_t wait;
> > +};
>
> It is a moderately big stretch to think that everything that wants to
> poll a value under /proc/sys will want to use struct ctl_table_poll.

This is the way we know what processes are polling() this entry (hence
the wait queue). It's a well known idiom and again maps to the
existent pollable files in /proc


>
> >  /* A sysctl table is an array of struct ctl_table: */
> >  struct ctl_table
> >  {
> > @@ -1021,6 +1028,7 @@ struct ctl_table
> >       struct ctl_table *child;
> >       struct ctl_table *parent;       /* Automatically set */
> >       proc_handler *proc_handler;     /* Callback for text formatting */
> > +     struct ctl_table_poll *poll;
> >       void *extra1;
> >       void *extra2;
> >  };
> > diff --git a/include/linux/utsname.h b/include/linux/utsname.h
> > index 4e5b021..c714ed7 100644
> > --- a/include/linux/utsname.h
> > +++ b/include/linux/utsname.h
> > @@ -37,6 +37,14 @@ struct new_utsname {
> >  #include <linux/nsproxy.h>
> >  #include <linux/err.h>
> >
> > +enum uts_proc {
> > +     UTS_PROC_OSTYPE,
> > +     UTS_PROC_OSRELEASE,
> > +     UTS_PROC_VERSION,
> > +     UTS_PROC_HOSTNAME,
> > +     UTS_PROC_DOMAINNAME,
> > +};
> > +
> >  struct user_namespace;
> >  extern struct user_namespace init_user_ns;
> >
> > @@ -80,6 +88,14 @@ static inline struct uts_namespace *copy_utsname(unsigned long flags,
> >  }
> >  #endif
> >
> > +#ifdef CONFIG_PROC_SYSCTL
> > +extern void uts_proc_notify(enum uts_proc proc);
> > +#else
> > +static inline void uts_proc_notify(enum uts_proc proc)
> > +{
> > +}
> > +#endif
> > +
> >  static inline struct new_utsname *utsname(void)
> >  {
> >       return &current->nsproxy->uts_ns->name;
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index a101ba3..2347043 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1241,6 +1241,7 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
> >               memset(u->nodename + len, 0, sizeof(u->nodename) - len);
> >               errno = 0;
> >       }
> > +     uts_proc_notify(UTS_PROC_HOSTNAME);
> >       up_write(&uts_sem);
> >       return errno;
> >  }
> > @@ -1291,6 +1292,7 @@ SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
> >               memset(u->domainname + len, 0, sizeof(u->domainname) - len);
> >               errno = 0;
> >       }
> > +     uts_proc_notify(UTS_PROC_DOMAINNAME);
> >       up_write(&uts_sem);
> >       return errno;
> >  }
> > diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
> > index a2cd77e..e96b766 100644
> > --- a/kernel/utsname_sysctl.c
> > +++ b/kernel/utsname_sysctl.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/uts.h>
> >  #include <linux/utsname.h>
> >  #include <linux/sysctl.h>
> > +#include <linux/wait.h>
> >
> >  static void *get_uts(ctl_table *table, int write)
> >  {
> > @@ -51,12 +52,28 @@ static int proc_do_uts_string(ctl_table *table, int write,
> >       uts_table.data = get_uts(table, write);
> >       r = proc_dostring(&uts_table,write,buffer,lenp, ppos);
> >       put_uts(table, write, uts_table.data);
> > +
> > +     if (write) {
> > +             atomic_inc(&table->poll->event);
> > +             wake_up_interruptible(&table->poll->wait);
>
> Duplicating code again?  Why are you not calling your generic notify?

Duplicating? The uts_proc_notify() was only created so when user calls
hostname/domainname syscalls we wake up who is polling the
correspondent sysctl entries.

Here it's for the generic case in which we write to /proc/sysctl.

We sure need to send a notification for the user when the entry is
changed, either via syscall or the fs entry.

>
> > +     }
> > +
> >       return r;
> >  }
> >  #else
> >  #define proc_do_uts_string NULL
> >  #endif
> >
>
> > +static struct ctl_table_poll hostname_poll = {
> > +     .event          = ATOMIC_INIT(0),
> > +     .wait           = __WAIT_QUEUE_HEAD_INITIALIZER(hostname_poll.wait),
> > +};
> > +
> > +static struct ctl_table_poll domainname_poll = {
> > +     .event          = ATOMIC_INIT(0),
> > +     .wait           = __WAIT_QUEUE_HEAD_INITIALIZER(domainname_poll.wait),
> > +};
>
> No generic initialize for this generic structure?  Instead every user
> must repeat the initialization?

The wait queues are different, and the ".poll" is set to this. I can't
see how we could generalize this. Maybe creating a macro
CTL_TABLE_POLL_DECLARE() or something along the way, but I'm not sure
it's worth doing.


> > @@ -105,6 +124,23 @@ static struct ctl_table uts_root_table[] = {
> >       {}
> >  };
> >
> > +#ifdef CONFIG_PROC_SYSCTL
> > +/*
> > + * Notify userspace about a change in a certain entry of uts_kern_table,
> > + * identified by the parameter proc.
> > + */
> > +void uts_proc_notify(enum uts_proc proc)
> > +{
> > +     struct ctl_table *table = &uts_kern_table[proc];
> > +
> > +     if (!table->poll)
> > +             return;
> > +
> > +     atomic_inc(&table->poll->event);
> > +     wake_up_interruptible(&table->poll->wait);
>
> Since you have a generic structure why don't you have a generic function
> that calls the atomic_inc and wake_up_interruptible.

It can be done. Maybe as a followup?


regards,
Lucas De Marchi
