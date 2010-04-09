Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0DIXQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:16:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60489 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab0DIXQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:16:22 -0400
Date: Fri, 9 Apr 2010 16:16:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-04-05 - another RCU whinge (not network this time)
Message-ID: <20100409231614.GE2421@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
 <6417.1270771048@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6417.1270771048@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 07:57:28PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 05 Apr 2010 16:09:45 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-04-05-16-09 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Hit another one.  I seem to be on a roll...
> 
> Seen in dmesg, happened near end of the initrd..
> 
> [   26.756864] 
> [   26.756866] ===================================================
> [   26.756869] [ INFO: suspicious rcu_dereference_check() usage. ]
> [   26.756871] ---------------------------------------------------
> [   26.756874] fs/proc/array.c:241 invoked rcu_dereference_check() without protection!

Color me confused.  I cloned James Toy's git repository at
git://zen-kernel.org/kernel/mmotm.git, and gitk claims that I am on tag
2010-04-05-16-09, which matches the string above.  But when I look at
fs/proc/array.c near line 241, I see:

238 static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
239                                     sigset_t *catch)
240 {
241         struct k_sigaction *k;
242         int i;
243 
244         k = p->sighand->action;
245         for (i = 1; i <= _NSIG; ++i, ++k) {
246                 if (k->sa.sa_handler == SIG_IGN)
247                         sigaddset(ign, i);
248                 else if (k->sa.sa_handler != SIG_DFL)
249                         sigaddset(catch, i);
250         }
251 }

It seems unlikely that line 241 generated the above error.

Am I on the wrong version?  Or do the git tags not mean what I think
that they mean?

							Thanx, Paul

> [   26.756876] 
> [   26.756877] other info that might help us debug this:
> [   26.756877] 
> [   26.756879] 
> [   26.756880] rcu_scheduler_active = 1, debug_locks = 0
> [   26.756883] 2 locks held by pidof/2197:
> [   26.756884]  #0:  (&p->lock){+.+.+.}, at: [<ffffffff810f4c2a>] seq_read+0x3a/0x42d
> [   26.756894]  #1:  (&(&sighand->siglock)->rlock){......}, at: [<ffffffff81047eff>] lock_task_sighand+0x79/0xcf
> [   26.756903] 
> [   26.756903] stack backtrace:
> [   26.756906] Pid: 2197, comm: pidof Not tainted 2.6.34-rc3-mmotm0405 #3
> [   26.756909] Call Trace:
> [   26.756914]  [<ffffffff810638c5>] lockdep_rcu_dereference+0xaa/0xb2
> [   26.756919]  [<ffffffff8112ed88>] collect_sigign_sigcatch+0x37/0xa0
> [   26.756923]  [<ffffffff8112f066>] do_task_stat+0x275/0x837
> [   26.756927]  [<ffffffff81063f83>] ? mark_held_locks+0x52/0x70
> [   26.756931]  [<ffffffff810af6be>] ? get_page_from_freelist+0x390/0x5ab
> [   26.756935]  [<ffffffff81062e7b>] ? register_lock_class+0x1e/0x325
> [   26.756938]  [<ffffffff8106421a>] ? trace_hardirqs_on+0xd/0xf
> [   26.756942]  [<ffffffff810af742>] ? get_page_from_freelist+0x414/0x5ab
> [   26.756946]  [<ffffffff81063d32>] ? mark_lock+0x2d/0x22c
> [   26.756949]  [<ffffffff81063d32>] ? mark_lock+0x2d/0x22c
> [   26.756953]  [<ffffffff81064fe7>] ? __lock_acquire+0x391/0xcfc
> [   26.756956]  [<ffffffff810b006f>] ? __alloc_pages_nodemask+0x796/0x823
> [   26.756961]  [<ffffffff810d4e60>] ? ____cache_alloc+0x10a/0x5cb
> [   26.756964]  [<ffffffff810d4e60>] ? ____cache_alloc+0x10a/0x5cb
> [   26.756969]  [<ffffffff8159f84c>] ? sub_preempt_count+0x35/0x49
> [   26.756973]  [<ffffffff8112f637>] proc_tgid_stat+0xf/0x11
> [   26.756977]  [<ffffffff8112c005>] proc_single_show+0x57/0x74
> [   26.756980]  [<ffffffff810f4ca1>] ? seq_read+0xb1/0x42d
> [   26.756983]  [<ffffffff810f4dc3>] seq_read+0x1d3/0x42d
> [   26.756988]  [<ffffffff810da357>] vfs_read+0xe0/0x140
> [   26.756991]  [<ffffffff810da46d>] sys_read+0x45/0x69
> [   26.756996]  [<ffffffff810026eb>] system_call_fastpath+0x16/0x1b
> [   26.788544] dracut: Switching root
> 


