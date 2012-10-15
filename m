Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2JOXLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:11:13 -0400
Received: from c60.cesmail.net ([216.154.195.49]:37560 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2JOXLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:11:09 -0400
Date: Mon, 15 Oct 2012 19:11:05 -0400
From: Pavel Roskin <proski@gnu.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bisected regression in Linux 3.7.0-rc1, hang on login caused by
 replace_fd()
Message-ID: <20121015191105.2dac4cac@mj>
In-Reply-To: <20121015215127.GK2616@ZenIV.linux.org.uk>
References: <20121015171437.32e9a4ac@mj>
 <20121015215127.GK2616@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/8I.a51k1pQ24_9v/x.BKJJW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/8I.a51k1pQ24_9v/x.BKJJW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 15 Oct 2012 22:51:27 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Oct 15, 2012 at 05:14:37PM -0400, Pavel Roskin wrote:
> > Hello!
> > 
> > I tried the current mainline Linux on Fedora 16 x64_64 and found
> > that I cannot login in gdm.  I'm using gdm with LXDE.  After a few
> > minutes, kernel messages appear indicating a hung process
> > gnome-settings-daemon.
> 
> What is it hanging on?

Sorry, I have no idea.  I select my name, enter password and nothing
happens.  I can still move the mouse and select some widgets in gdm.  I
can use Ctrl-Alt-F2 to switch to the test console and login.

I attached gdb to the process and that's what I got:

(gdb) where
#0  0x0000003c19ae8803 in __GI___poll (fds=<optimized out>, nfds=<optimized out>, timeout=<optimized out>) at ../sysdeps/unix/sysv/linux/poll.c:87
#1  0x0000003c1ba45448 in g_main_context_poll (n_fds=10, fds=0x2096dc0, priority=<optimized out>, timeout=41758, context=0x1e3e4a0) at gmain.c:3402
#2  g_main_context_iterate (context=0x1e3e4a0, block=<optimized out>, dispatch=1, self=<optimized out>) at gmain.c:3084
#3  0x0000003c1ba45c85 in g_main_loop_run (loop=0x1f35b70) at gmain.c:3297
#4  0x00000033cf75198d in gtk_main () at gtkmain.c:1362
#5  0x0000000000403d28 in main (argc=1, argv=0x7fffe57b3a78) at main.c:459
(gdb)

I'm not sure it's what you asked.

> Aha.  We have the first thing to test - is RLIMIT_NOFILE set to 0 for
> that process, by any chance?

No.  I made a copy of replace_fd() called by umh_pipe_setup() only, and
here's the output (debugging patch attached):

[   15.792895] replace_fd_debug: rlimit(RLIMIT_NOFILE) = 1024
[   15.792901] replace_fd_debug: file = ffff88011dd5db80
[   15.792903] replace_fd_debug: expand_files returned 0
[   15.792905] umh_pipe_setup: replace_fd_debug returned 0

>  We definitedly need to check
> replace_fd() return value, BTW.  OK, suppose it wasn't 0.

It's 0.

I made simplified functions replacing replace_fd() for umh_pipe_setup()
by substituting parameters and expanding do_dup2().  Here's the
combined function:

void replace_fd2(struct file *file)
{
	struct fdtable *fdt;
	struct files_struct *files = current->files;

	/* old code */
	sys_close(0);
	fd_install(0, file);

	spin_lock(&files->file_lock);
	fdt = files_fdtable(files);

	/* new code */
	get_file(file);
	rcu_assign_pointer(fdt->fd[0], file);

	__set_open_fd(0, fdt);
	__clear_close_on_exec(0, fdt);
	spin_unlock(&files->file_lock);
}

If the "new code" (two lines below the comment) is commented out and the
"old code" is not, everything works.  If the new code is used and the
old code is commented out, I have a hang.  Enabling all code leads
to a hang too.

> 	All right, so the next step in debugging is to print the damn
> return value of replace_fd().  That should narrow the things down.
> Another interesting question, of course, is what makes that gnome turd
> coredump on each boot?

I guess some GNOME programs are "uncomfortable" when launched by LXDE.
Considering that I'm running Fedora 16 with GNOME 3.2, I don't think
anyone would care about my bug reports.  But inability to login due to
kernel changes is bad and should not happen.

-- 
Regards,
Pavel Roskin

--MP_/8I.a51k1pQ24_9v/x.BKJJW
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=replacefd-debug.patch

Debug replace_fd()

From: Pavel Roskin <proski@gnu.org>


---

 fs/coredump.c |    4 +++-
 fs/file.c     |   27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletions(-)


diff --git a/fs/coredump.c b/fs/coredump.c
index fd37fac..2a5ce3c 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -440,6 +440,7 @@ static void wait_for_dump_helpers(struct file *file)
  * is a special value that we use to trap recursive
  * core dumps
  */
+int replace_fd_debug(unsigned fd, struct file *file, unsigned flags);
 static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 {
 	struct file *files[2];
@@ -450,7 +451,8 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 
 	cp->file = files[1];
 
-	replace_fd(0, files[0], 0);
+	err = replace_fd_debug(0, files[0], 0);
+	printk("%s: replace_fd_debug returned %d\n", __func__, err);
 	/* and disallow core files too */
 	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
 
diff --git a/fs/file.c b/fs/file.c
index d3b5fa8..e209b3c 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -913,6 +913,33 @@ out_unlock:
 	return err;
 }
 
+int replace_fd_debug(unsigned fd, struct file *file, unsigned flags);
+int replace_fd_debug(unsigned fd, struct file *file, unsigned flags)
+{
+	int err;
+	struct files_struct *files = current->files;
+
+	printk("%s: rlimit(RLIMIT_NOFILE) = %ld\n", __func__, rlimit(RLIMIT_NOFILE));
+	printk("%s: file = %p\n", __func__, file);
+
+	if (!file)
+		return __close_fd(files, fd);
+
+	if (fd >= rlimit(RLIMIT_NOFILE))
+		return -EMFILE;
+
+	spin_lock(&files->file_lock);
+	err = expand_files(files, fd);
+	printk("%s: expand_files returned %d\n", __func__, err);
+	if (unlikely(err < 0))
+		goto out_unlock;
+	return do_dup2(files, file, fd, flags);
+
+out_unlock:
+	spin_unlock(&files->file_lock);
+	return err;
+}
+
 SYSCALL_DEFINE3(dup3, unsigned int, oldfd, unsigned int, newfd, int, flags)
 {
 	int err = -EBADF;

--MP_/8I.a51k1pQ24_9v/x.BKJJW--
