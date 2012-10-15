Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2JOVvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:51:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48869 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2JOVvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:51:31 -0400
Date: Mon, 15 Oct 2012 22:51:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bisected regression in Linux 3.7.0-rc1, hang on login caused by
 replace_fd()
Message-ID: <20121015215127.GK2616@ZenIV.linux.org.uk>
References: <20121015171437.32e9a4ac@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015171437.32e9a4ac@mj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 05:14:37PM -0400, Pavel Roskin wrote:
> Hello!
> 
> I tried the current mainline Linux on Fedora 16 x64_64 and found that I
> cannot login in gdm.  I'm using gdm with LXDE.  After a few minutes,
> kernel messages appear indicating a hung process gnome-settings-daemon.

What is it hanging on?

> I'll try to figure out why replace_fd() is not good in
> umh_pipe_setup(), but I'd like to report the problem as soon as
> possible, as it's very visible to the users and I don't want others to
> spend hours bisecting it.
> 
> -- 
> Regards,
> Pavel Roskin

[snip]

> [  241.483499] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  241.484888] gnome-settings- D 0000000000000000  6136  3155      1 0x00000000
> [  241.486265]  ffff8801298afcc8 0000000000000046 ffff88012993b420 0000000000000246
> [  241.487652]  ffff8801298affd8 ffff8801298affd8 ffff8801298affd8 ffff8801298affd8
> [  241.489035]  ffff88012993a2c0 ffff88012993b420 ffff880128cb0b80 ffff88012993b420
> [  241.490421] Call Trace:
> [  241.491765]  [<ffffffff815d8064>] schedule+0x24/0x70
> [  241.493116]  [<ffffffff81043945>] exit_mm+0x85/0x120
> [  241.494467]  [<ffffffff8104628f>] do_exit+0x13f/0x580
> [  241.495784]  [<ffffffff81046957>] do_group_exit+0x47/0xb0
> [  241.497090]  [<ffffffff810597ef>] get_signal_to_deliver+0x21f/0x580
> [  241.498384]  [<ffffffff81002014>] do_signal+0x24/0x120
> [  241.499673]  [<ffffffff815da28c>] ? sysret_signal+0x5/0x47
> [  241.500964]  [<ffffffff81002195>] do_notify_resume+0x65/0xa0
> [  241.502239]  [<ffffffff8129342e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [  241.503525]  [<ffffffff815da51a>] int_signal+0x12/0x17
> [  241.504813] no locks held by gnome-settings-/3155.
> [  241.506095] INFO: task gnome-settings-:3156 blocked for more than 120 seconds.
> [  241.507405] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  241.508721] gnome-settings- D 00000000ffffffff  5104  3156      1 0x00000000
> [  241.510056]  ffff88011c80bcc8 0000000000000046 ffff88011c80bc78 ffffffff8109ad9d
> [  241.511414]  ffff88011c80bfd8 ffff88011c80bfd8 ffff88011c80bfd8 ffff88011c80bfd8
> [  241.512780]  ffff8801279fd6e0 ffff88012993a2c0 ffff880129809d28 ffff88012993a2c0
> [  241.514134] Call Trace:
> [  241.515480]  [<ffffffff8109ad9d>] ? trace_hardirqs_on_caller+0x7d/0x120
> [  241.516857]  [<ffffffff815d8064>] schedule+0x24/0x70
> [  241.518219]  [<ffffffff81043945>] exit_mm+0x85/0x120
> [  241.519592]  [<ffffffff8104628f>] do_exit+0x13f/0x580
> [  241.520952]  [<ffffffff81046957>] do_group_exit+0x47/0xb0
> [  241.522315]  [<ffffffff810597ef>] get_signal_to_deliver+0x21f/0x580
> [  241.523687]  [<ffffffff81002014>] do_signal+0x24/0x120
> [  241.525066]  [<ffffffff8109b8a4>] ? __lock_is_held+0x54/0x70
> [  241.526436]  [<ffffffff815da28c>] ? sysret_signal+0x5/0x47
> [  241.527841]  [<ffffffff81002195>] do_notify_resume+0x65/0xa0
> [  241.529237]  [<ffffffff8129342e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [  241.530625]  [<ffffffff815da51a>] int_signal+0x12/0x17
> [  241.532009] no locks held by gnome-settings-/3156.
> [  241.533386] INFO: task gnome-settings-:3157 blocked for more than 120 seconds.
> [  241.534778] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  241.536196] gnome-settings- D 00000000ffffffff  5432  3157      1 0x00000000
> [  241.537632]  ffff8801279efcc8 0000000000000046 ffff88012993c580 0000000000000246
> [  241.539069]  ffff8801279effd8 ffff8801279effd8 ffff8801279effd8 ffff8801279effd8
> [  241.540515]  ffff88012661e840 ffff88012993c580 ffff880128cb0b80 ffff88012993c580
> [  241.541961] Call Trace:
> [  241.543377]  [<ffffffff815d8064>] schedule+0x24/0x70
> [  241.544802]  [<ffffffff81043945>] exit_mm+0x85/0x120
> [  241.546226]  [<ffffffff8104628f>] do_exit+0x13f/0x580
> [  241.547642]  [<ffffffff81046957>] do_group_exit+0x47/0xb0
> [  241.549053]  [<ffffffff810597ef>] get_signal_to_deliver+0x21f/0x580
> [  241.550468]  [<ffffffff815d940b>] ? _raw_spin_unlock_irq+0x2b/0x50
> [  241.551878]  [<ffffffff81002014>] do_signal+0x24/0x120
> [  241.553297]  [<ffffffff81122e77>] ? might_fault+0x57/0xb0
> [  241.554726]  [<ffffffff815da28c>] ? sysret_signal+0x5/0x47
> [  241.556148]  [<ffffffff81002195>] do_notify_resume+0x65/0xa0
> [  241.557588]  [<ffffffff8129342e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [  241.557590]  [<ffffffff815da51a>] int_signal+0x12/0x17
> [  241.557595] no locks held by gnome-settings-/3157.

> @@ -443,14 +453,23 @@ static void wait_for_dump_helpers(struct file *file)
>  static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
>  {
>  	struct file *files[2];
> +	struct fdtable *fdt;
>  	struct coredump_params *cp = (struct coredump_params *)info->data;
> +	struct files_struct *cf = current->files;
>  	int err = create_pipe_files(files, 0);
>  	if (err)
>  		return err;
>  
>  	cp->file = files[1];
>  
> -	replace_fd(0, files[0], 0);
> +	sys_close(0);
> +	fd_install(0, files[0]);
> +	spin_lock(&cf->file_lock);
> +	fdt = files_fdtable(cf);
> +	__set_open_fd(0, fdt);
> +	__clear_close_on_exec(0, fdt);
> +	spin_unlock(&cf->file_lock);

Very interesting.  Let's see what could be going on there.  First of
all, create_pipe_files() has return 0.  There's only one exit where
it can do so and it dereferences both files[0] and files[1] on the
way there.  Since that hadn't oopsed, they are both non-NULL.

IOW, replace_fd(0, files[0], 0) is equivalent to
{
	int err;
	struct file *f = files[0];
        struct files_struct *files = current->files;
        if (0 >= rlimit(RLIMIT_NOFILE))
                return -EMFILE;

        spin_lock(&files->file_lock);
        err = expand_files(files, 0);
        if (unlikely(err < 0))
                goto out_unlock;
        return do_dup2(files, f, 0, 0);

out_unlock:
        spin_unlock(&files->file_lock);
        return err;
}

Aha.  We have the first thing to test - is RLIMIT_NOFILE set to 0 for that
process, by any chance?  We definitedly need to check replace_fd() return
value, BTW.  OK, suppose it wasn't 0.  So we'd done expand_files(files, 0).
expand_files() begins with
        /* Do we need to expand? */
        if (nr < fdt->max_fds)
                return 0;
and ->max_fds is never going to be less than NR_OPEN_DEFAULT, which is
definitely positive.  So expand_files(files, 0) is going to return 0
without doing anything.  And we get to do_dup2():
        fdt = files_fdtable(files);
        tofree = fdt->fd[0];
        if (!tofree && fd_is_open(0, fdt))
                goto Ebusy;
that really shouldn't be possible to hit in this case - it can happen
only for shared descriptor table.  Another thread would need to have
already reserved fd 0, but hadn't got around to installing a reference
to struct file into it.  But we are called from the freshly created
kernel thread, about to exec some userland binary.  Those are spawned
without CLONE_FILES in flags, so the table can't be shared.  It's fresh
from dup_fd() and this bit
                        /*
                         * The fd may be claimed in the fd bitmap but not yet
                         * instantiated in the files array if a sibling thread
                         * is partway through open().  So make sure that this
                         * fd is available to the new process.
                         */
                        __clear_open_fd(open_files - i, new_fdt);
in there would have prevented anything of that kind.

Now we have tofree equal to whatever we used to have in ->fd[0] (realistically
that's going to be NULL).  Next we have
        get_file(file);
        rcu_assign_pointer(fdt->fd[0], file);
        __set_open_fd(0, fdt);
        if (0 & O_CLOEXEC)
                __set_close_on_exec(fd, fdt);
        else
                __clear_close_on_exec(fd, fdt);
        spin_unlock(&files->file_lock);

        if (tofree)
                filp_close(tofree, files);

Now, note that sys_close(0) would have done something very similar -
        file = fdt->fd[0];
        if (!file)
                goto out_unlock;
        rcu_assign_pointer(fdt->fd[0], NULL);
        __clear_close_on_exec(0, fdt);
        __put_unused_fd(files, 0);
        spin_unlock(&files->file_lock);
        filp_close(file, files);
'file' here is what we had in 'tofree'.  We'd ripped it out of descriptor
table and done filp_close() on it.  When we follow with 
	fd_install(0, files[0]);
...
	__set_open_fd(0, fdt);
	__clear_close_on_exec(0, fdt);
we have get_file() done on files[0], files[0] put into ->fd[0] (fd_install()),
result of __put_unused(files, 0); undone (by __set_open_fd()) and we come
to exactly the same situation as with replace_fd().

	All right, so the next step in debugging is to print the damn
return value of replace_fd().  That should narrow the things down.
Another interesting question, of course, is what makes that gnome turd
coredump on each boot?
