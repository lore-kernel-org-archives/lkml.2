Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974Ab2CaNzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 09:55:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54922 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab2CaNzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 09:55:36 -0400
Date: Sat, 31 Mar 2012 17:55:20 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu,
        Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] proc: reset mount options after the last procfs umount
Message-ID: <20120331135520.GB2845@albatros>
References: <201203220903.15360.a.miskiewicz@gmail.com>
 <20120323171058.GA3279@albatros>
 <20120323161504.dced28b9.akpm@linux-foundation.org>
 <201203250924.06908.a.miskiewicz@gmail.com>
 <20120325153612.GC4391@albatros>
 <97428.1332714196@turing-police.cc.vt.edu>
 <20120326153738.aa728115.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326153738.aa728115.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 15:37 -0700, Andrew Morton wrote:
> On Sun, 25 Mar 2012 18:23:16 -0400
> Valdis.Kletnieks@vt.edu wrote:
> 
> > Yes, it may be what the code actually *does*, but it certainly violates
> > the Principle of Least Surprise...
> 
> It surprises me ;)  I never noticed that before.
> 
> It does seem pretty insane.  I wonder how much downstream damage would
> result from fixing it.

Resetting options on each mount is implemented in the following patch.
However, I'm stuck with searching a race-free way to learn current
mounts count of this procfs sb.  sget() + atomic_read() is racy:

	(A)				(B)
	mount -t proc			mount -t proc

	sget()				|
	|				sget()
	atomic_read(&sb->s_active)	|
	|				atomic_read(&sb->s_active)

So, it has a theoretical race of reading sb->s_active with 2+ parallel
mounts and both reads will get 3 instead of 2.  Consequently, neither of
mounts will reset mount options.

I wonder whether anybody will try to do such parallel type of things
in reality (IOW, is it OK to leave this race?)

--------------
From: Vasiliy Kulikov <segoon@openwall.com>
Subject: [PATCH] proc: reset mount options after the last procfs umount

The following command sequence leads to wrong mount options setting:

  mount -t proc -o hidepid=1 none /proc
  umount /proc
  mount -t proc none /proc

The second "mount" mounts procfs with old options from the first "mount",
but should use no options.

Fix that by resetting mount options in pid_namespace each time procfs
is mounted in a pid namespace without other procfs mount points.

Note that if one creates second procfs mount point, it should use old
mount options (IOW, reuse first mount point's options).

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

--
 fs/proc/root.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

---
diff --git a/fs/proc/root.c b/fs/proc/root.c
index eed44bf..7067a5c 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -47,6 +47,12 @@ static const match_table_t tokens = {
 	{Opt_err, NULL},
 };
 
+static void proc_reset_options(struct pid_namespace *pid)
+{
+	pid->pid_gid = 0;
+	pid->hide_pid = 0;
+}
+
 static int proc_parse_options(char *options, struct pid_namespace *pid)
 {
 	char *p;
@@ -115,6 +121,9 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
 
+	if (atomic_read(&sb->s_active) <= 2)
+		proc_reset_options(ns);
+
 	if (!proc_parse_options(options, ns)) {
 		deactivate_locked_super(sb);
 		return ERR_PTR(-EINVAL);
--

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
