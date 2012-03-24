Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab2CXGVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 02:21:17 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49457 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2CXGVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 02:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <m1iphuu9pd.fsf_-_@fess.ebiederm.org>
References: <20120313005855.GA24639@redhat.com> <CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
 <20120318192755.GB6589@ZenIV.linux.org.uk> <CAMOw1v4qa_AxJgc+qAsY6M=K--2JDvO-+CNj8OwKuE7piRViGw@mail.gmail.com>
 <m1vclw1fx8.fsf@fess.ebiederm.org> <CAMOw1v4gszzV7F3z1m+RWEe9UDgR2Jrp9wX_w9z_1UkXT=FL5Q@mail.gmail.com>
 <m1iphuu9pd.fsf_-_@fess.ebiederm.org>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Sat, 24 Mar 2012 03:20:53 -0300
Message-ID: <CAMOw1v65TePmMOxzGsnW4xv1ge1RDD=Stxgo9-eqtyi8hdjZOQ@mail.gmail.com>
Subject: Re: [REVIEW][PATCH] Making poll generally useful for sysctls
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 9:25 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Lucas can you take a look at the patch below. I don't have a test
> harness to test this but this should make poll generally useful
> for all sysctls as well as fix the module removal case.
>
> In particular if you could test to see if the code still works as
> expected for the hostname and domainname cases that would be great.
>
> I don't anticipate any problems but real world testing is always good.
>
>  fs/proc/proc_sysctl.c   |   34 +++++++++++++++++-----------------
>  include/linux/sysctl.h  |   22 +++-------------------
>  kernel/utsname_sysctl.c |   14 ++++----------
>  3 files changed, 24 insertions(+), 46 deletions(-)
> ---
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 47b474b..98fd5c9 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -16,13 +16,15 @@ static const struct inode_operations proc_sys_inode_operations;
>  static const struct file_operations proc_sys_dir_file_operations;
>  static const struct inode_operations proc_sys_dir_operations;
>
> -void proc_sys_poll_notify(struct ctl_table_poll *poll)
> +static inline void *proc_sys_poll_event(struct ctl_table *table)
>  {
> -       if (!poll)
> -               return;
> +       return (void *)(unsigned long)atomic_read(&table->event);
> +}
>
> -       atomic_inc(&poll->event);
> -       wake_up_interruptible(&poll->wait);
> +void proc_sys_poll_notify(struct ctl_table_header *head, struct ctl_table *table)
> +{
> +       atomic_inc(&table->event);
> +       wake_up_interruptible(&head->wait);
>  }
>
>  static struct ctl_table root_table[] = {
> @@ -169,6 +171,7 @@ static void init_header(struct ctl_table_header *head,
>                for (entry = table; entry->procname; entry++, node++) {
>                        rb_init_node(&node->node);
>                        node->header = head;
> +                       atomic_set(&entry->event, 1);
>                }
>        }
>  }
> @@ -240,6 +243,8 @@ static void start_unregistering(struct ctl_table_header *p)
>                /* anything non-NULL; we'll never dereference it */
>                p->unregistering = ERR_PTR(-EINVAL);
>        }
> +       /* Don't let poll sleep forever on deleted entries */
> +       wake_up_interruptible(&p->wait);
>        /*
>         * do not remove from the list until nobody holds it; walking the
>         * list in do_sysctl() relies on that.
> @@ -505,6 +510,9 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
>        error = table->proc_handler(table, write, buf, &res, ppos);
>        if (!error)
>                error = res;
> +
> +       if (write)
> +               proc_sys_poll_notify(head, table);
>  out:
>        sysctl_head_finish(head);
>
> @@ -532,8 +540,7 @@ static int proc_sys_open(struct inode *inode, struct file *filp)
>        if (IS_ERR(head))
>                return PTR_ERR(head);
>
> -       if (table->poll)
> -               filp->private_data = proc_sys_poll_event(table->poll);
> +       filp->private_data = proc_sys_poll_event(table);
>
>        sysctl_head_finish(head);
>
> @@ -552,21 +559,14 @@ static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
>        if (IS_ERR(head))
>                return POLLERR | POLLHUP;
>
> -       if (!table->proc_handler)
> -               goto out;
> -
> -       if (!table->poll)
> -               goto out;
> -
>        event = (unsigned long)filp->private_data;
> -       poll_wait(filp, &table->poll->wait, wait);
> +       poll_wait(filp, &head->wait, wait);
>
> -       if (event != atomic_read(&table->poll->event)) {
> -               filp->private_data = proc_sys_poll_event(table->poll);
> +       if (event != atomic_read(&table->event)) {
> +               filp->private_data = proc_sys_poll_event(table);
>                ret = POLLIN | POLLRDNORM | POLLERR | POLLPRI;
>        }
>
> -out:
>        sysctl_head_finish(head);
>
>        return ret;
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index c34b4c8..8647ee0 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -992,34 +992,17 @@ extern int proc_do_large_bitmap(struct ctl_table *, int,
>  * cover common cases.
>  */
>
> -/* Support for userspace poll() to watch for changes */
> -struct ctl_table_poll {
> -       atomic_t event;
> -       wait_queue_head_t wait;
> -};
> -
> -static inline void *proc_sys_poll_event(struct ctl_table_poll *poll)
> -{
> -       return (void *)(unsigned long)atomic_read(&poll->event);
> -}
> -
> -#define __CTL_TABLE_POLL_INITIALIZER(name) {                           \
> -       .event = ATOMIC_INIT(0),                                        \
> -       .wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.wait) }
> -
> -#define DEFINE_CTL_TABLE_POLL(name)                                    \
> -       struct ctl_table_poll name = __CTL_TABLE_POLL_INITIALIZER(name)
>
>  /* A sysctl table is an array of struct ctl_table: */
>  struct ctl_table
>  {
>        const char *procname;           /* Text ID for /proc/sys, or zero */
>        void *data;
> +       atomic_t event;
>        int maxlen;
>        umode_t mode;
>        struct ctl_table *child;        /* Deprecated */
>        proc_handler *proc_handler;     /* Callback for text formatting */
> -       struct ctl_table_poll *poll;
>        void *extra1;
>        void *extra2;
>  };
> @@ -1042,6 +1025,7 @@ struct ctl_table_header
>                };
>                struct rcu_head rcu;
>        };
> +       wait_queue_head_t wait;

If you have a waitqueue per table instead of per entry you will get
spurious notifications when other entries change. The easiest way to
test this is to poll /proc/sys/kernel/hostname and change your
domainname.

I couldn't apply this patch to any tree (linus/master + my previous
patch, your master, 3.3 + my previous patch), so I couldn't test. On
top of your tree:

[lucas@vader kernel]$ git am /tmp/a.patch
Applying: Making poll generally useful for sysctls
error: patch failed: fs/proc/proc_sysctl.c:16
error: fs/proc/proc_sysctl.c: patch does not apply
error: patch failed: include/linux/sysctl.h:992
error: include/linux/sysctl.h: patch does not apply
Patch failed at 0001 Making poll generally useful for sysctls


Lucas De Marchi
