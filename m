Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2HNO0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:26:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14854 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab2HNOXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:23:06 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=HMINAUNbf7oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=AjE16Kl52vpyySKzqtwA:9 a=PUjeQqilurYA:10 a=_RhRFcbxBZMA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344954183.6724.8.camel@gandalf.stny.rr.com>
Subject: Re: [rfc patch] fs,reiserfs: unlock superblock before callling
 reiserfs_quota_on_mount()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 14 Aug 2012 10:23:03 -0400
In-Reply-To: <1344949583.14924.36.camel@marge.simpson.net>
References: <1344949583.14924.36.camel@marge.simpson.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 15:06 +0200, Mike Galbraith wrote:
> Greetings,
> 
> Using openSUSE's "partitioner" gizmo to set up a reiserfs partition with
> quotas and whatnot enabled rewarded me with a deadlock.

Is this just a -rt bug? Can't this deadlock also in mainline?

-- Steve

> 
> In reiserfs/lock.c we see:
> ... 
> * Also this lock is often released before a call that could block because
>  * reiserfs performances were partially based on the release while schedule()
>  * property of the Bkl.
>  */
> void reiserfs_write_lock(struct super_block *s)
> 
> And in the problematic reiserfs_fill_super():
>         /*
>          * This function is called with the bkl, which also was the old
>          * locking used here.
>          * do_journal_begin() will soon check if we hold the lock (ie: was the
>          * bkl). This is likely because do_journal_begin() has several another
>          * callers because at this time, it doesn't seem to be necessary to
>          * protect against anything.
>          * Anyway, let's be conservative and lock for now.
>          */
>         reiserfs_write_lock(s);
> 
> Given wishy-washy "be conservative for now", and "this lock is often
> released before a call that could block", it seemed reasonable to trade
> a little conservatism for a chance to return from the blocking
> function. 
> 
> If we hold the super block lock while calling reiserfs_quota_on_mount(), we can
> deadlock - mount blocks kworker/3:2, and sleeps forever more.
> 
> crash> ps|grep UN
>     715      2   3  ffff880220734d30  UN   0.0       0      0  [kworker/3:2]
>    9369   9341   2  ffff88021ffb7560  UN   1.3  493404 123184  Xorg
>    9665   9664   3  ffff880225b92ab0  UN   0.0   47368    812  udisks-daemon
>   10635  10403   3  ffff880222f22c70  UN   0.0   14904    936  mount
> crash> bt ffff880220734d30
> PID: 715    TASK: ffff880220734d30  CPU: 3   COMMAND: "kworker/3:2"
>  #0 [ffff8802244c3c20] schedule at ffffffff8144584b
>  #1 [ffff8802244c3cc8] __rt_mutex_slowlock at ffffffff814472b3
>  #2 [ffff8802244c3d28] rt_mutex_slowlock at ffffffff814473f5
>  #3 [ffff8802244c3dc8] reiserfs_write_lock at ffffffffa05f28fd [reiserfs]
>  #4 [ffff8802244c3de8] flush_async_commits at ffffffffa05ec91d [reiserfs]
>  #5 [ffff8802244c3e08] process_one_work at ffffffff81073726
>  #6 [ffff8802244c3e68] worker_thread at ffffffff81073eba
>  #7 [ffff8802244c3ec8] kthread at ffffffff810782e0
>  #8 [ffff8802244c3f48] kernel_thread_helper at ffffffff81450064
> 
> crash> struct rt_mutex ffff880222e8f628
> struct rt_mutex {
>   wait_lock = {
>     raw_lock = {
>       slock = 65537
>     }
>   }, 
>   wait_list = {
>     node_list = {
>       next = 0xffff8802244c3d48, 
>       prev = 0xffff8802244c3d48
>     }
>   }, 
>   owner = 0xffff880222f22c71, 
>   save_state = 0
> }
> crash> bt 0xffff880222f22c70                                                                                                                                                                                                                
> PID: 10635  TASK: ffff880222f22c70  CPU: 3   COMMAND: "mount"                                                                                                                                                                               
>  #0 [ffff8802216a9868] schedule at ffffffff8144584b                                                                                                                                                                                         
>  #1 [ffff8802216a9910] schedule_timeout at ffffffff81446865                                                                                                                                                                                 
>  #2 [ffff8802216a99a0] wait_for_common at ffffffff81445f74
>  #3 [ffff8802216a9a30] flush_work at ffffffff810712d3
>  #4 [ffff8802216a9ab0] schedule_on_each_cpu at ffffffff81074463
>  #5 [ffff8802216a9ae0] invalidate_bdev at ffffffff81178aba
>  #6 [ffff8802216a9af0] vfs_load_quota_inode at ffffffff811a3632
>  #7 [ffff8802216a9b50] dquot_quota_on_mount at ffffffff811a375c
>  #8 [ffff8802216a9b80] finish_unfinished at ffffffffa05dd8b0 [reiserfs]
>  #9 [ffff8802216a9cc0] reiserfs_fill_super at ffffffffa05de825 [reiserfs]
> #10 [ffff8802216a9d90] mount_bdev at ffffffff8114c93f
> #11 [ffff8802216a9e00] mount_fs at ffffffff8114d035
> #12 [ffff8802216a9e50] vfs_kern_mount at ffffffff81167d36
> #13 [ffff8802216a9e90] do_kern_mount at ffffffff811692c3
> #14 [ffff8802216a9ed0] do_mount at ffffffff8116adb5
> #15 [ffff8802216a9f30] sys_mount at ffffffff8116b25a
> #16 [ffff8802216a9f80] system_call_fastpath at ffffffff8144ef12
>     RIP: 00007f7b9303997a  RSP: 00007ffff443c7a8  RFLAGS: 00010202
>     RAX: 00000000000000a5  RBX: ffffffff8144ef12  RCX: 00007f7b932e9ee0
>     RDX: 00007f7b93d9a400  RSI: 00007f7b93d9a3e0  RDI: 00007f7b93d9a3c0
>     RBP: 00007f7b93d9a2c0   R8: 00007f7b93d9a550   R9: 0000000000000001
>     R10: ffffffffc0ed040e  R11: 0000000000000202  R12: 000000000000040e
>     R13: 0000000000000000  R14: 00000000c0ed040e  R15: 00007ffff443ca20
>     ORIG_RAX: 00000000000000a5  CS: 0033  SS: 002b
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> ---
>  fs/reiserfs/super.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -140,7 +140,13 @@ static int remove_save_link_only(struct
>  static int reiserfs_quota_on_mount(struct super_block *, int);
>  #endif
>  
> -/* look for uncompleted unlinks and truncates and complete them */
> +/*
> + *look for uncompleted unlinks and truncates and complete them
> + *
> + * Called with super_block write locked.  If quotas are enabled,
> + * we have to release/retake lest we call dquot_quota_on_mount(),
> + * proceed to schedule_on_each_cpu() and deadlock our own worker.
> + */
>  static int finish_unfinished(struct super_block *s)
>  {
>  	INITIALIZE_PATH(path);
> @@ -187,7 +193,9 @@ static int finish_unfinished(struct supe
>  				quota_enabled[i] = 0;
>  				continue;
>  			}
> +			reiserfs_write_unlock(s);
>  			ret = reiserfs_quota_on_mount(s, i);
> +			reiserfs_write_lock(s);
>  			if (ret < 0)
>  				reiserfs_warning(s, "reiserfs-2500",
>  						 "cannot turn on journaled "
> 


