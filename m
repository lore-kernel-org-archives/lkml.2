Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab0EUG7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:59:38 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:36658 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751219Ab0EUG7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:59:37 -0400
Date: Fri, 21 May 2010 16:59:33 +1000
From: CaT <cat@zip.com.au>
To: linux-kernel@vger.kernel.org, ccaulfie@redhat.com, teigland@redhat.com,
       cluster-devel@redhat.com
Subject: 2.6.34: dlm: possible circular locking dependency detected
Message-ID: <20100521065933.GH2657@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organisation: Furball Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to use OCFS2 over drbd on kernel 2.6.34 (both nodes) and in
trying to use it across both I got the following on the initial
node I prepared. Please shout for more info.

[81409.510188] o2net: connected to node monkeynut (num 0) at 10.y.y.y:x
[81459.237087] ocfs2_dlm: Node 0 joins domain A064327F6A5C49E39DA35032B3484154
[81459.237092] ocfs2_dlm: Nodes in domain ("A064327F6A5C49E39DA35032B3484154"): 0 1
[81459.321394]
[81459.321395] =======================================================
[81459.321515] [ INFO: possible circular locking dependency detected ]
[81459.321592] 2.6.34-x.20100520-164221 #5
[81459.321651] -------------------------------------------------------
[81459.321715] dlm_thread/610 is trying to acquire lock:
[81459.321777]  (&(&dlm->ast_lock)->rlock){+.+...}, at: [<ffffffff81264768>] dlm_queue_bast+0x8e/0x1b9
[81459.322000]
[81459.322000] but task is already holding lock:
[81459.322137]  (&(&res->spinlock)->rlock){+.+...}, at: [<ffffffff8125093f>] dlm_thread+0x7aa/0x169b
[81459.322360]
[81459.322361] which lock already depends on the new lock.
[81459.322361]
[81459.322533]
[81459.322534] the existing dependency chain (in reverse order) is:
[81459.322648]
[81459.322648] -> #1 (&(&res->spinlock)->rlock){+.+...}:
[81459.322883]        [<ffffffff81092845>] __lock_acquire+0x1433/0x17a8
[81459.322992]        [<ffffffff81092c84>] lock_acquire+0xca/0xf6
[81459.323090]        [<ffffffff8161dd02>] _raw_spin_lock+0x2c/0x38
[81459.323193]        [<ffffffff812ff89d>] _atomic_dec_and_lock+0x41/0x64
[81459.323294]        [<ffffffff8125a79c>] dlm_lockres_release_ast+0x29/0x9f
[81459.323429]        [<ffffffff812513e2>] dlm_thread+0x124d/0x169b
[81459.323531]        [<ffffffff81080dc2>] kthread+0x7d/0x85
[81459.323649]        [<ffffffff8102eee4>] kernel_thread_helper+0x4/0x10
[81459.323758]
[81459.323758] -> #0 (&(&dlm->ast_lock)->rlock){+.+...}:
[81459.324007]        [<ffffffff8109256a>] __lock_acquire+0x1158/0x17a8
[81459.324112]        [<ffffffff81092c84>] lock_acquire+0xca/0xf6
[81459.324218]        [<ffffffff8161dd02>] _raw_spin_lock+0x2c/0x38
[81459.324326]        [<ffffffff81264768>] dlm_queue_bast+0x8e/0x1b9
[81459.324431]        [<ffffffff81250f21>] dlm_thread+0xd8c/0x169b
[81459.324534]        [<ffffffff81080dc2>] kthread+0x7d/0x85
[81459.324682]        [<ffffffff8102eee4>] kernel_thread_helper+0x4/0x10
[81459.324785]
[81459.324786] other info that might help us debug this:
[81459.324786]
[81459.324971] 1 lock held by dlm_thread/610:
[81459.325031]  #0:  (&(&res->spinlock)->rlock){+.+...}, at: [<ffffffff8125093f>] dlm_thread+0x7aa/0x169b
[81459.325276]
[81459.325276] stack backtrace:
[81459.325383] Pid: 610, comm: dlm_thread Not tainted 2.6.34-x.20100520-164221 #5
[81459.325461] Call Trace:
[81459.325520]  [<ffffffff81090eaf>] print_circular_bug+0xc0/0xd1
[81459.325579]  [<ffffffff8109256a>] __lock_acquire+0x1158/0x17a8
[81459.325643]  [<ffffffff81092c84>] lock_acquire+0xca/0xf6
[81459.325706]  [<ffffffff81264768>] ? dlm_queue_bast+0x8e/0x1b9
[81459.325767]  [<ffffffff8161dd02>] _raw_spin_lock+0x2c/0x38
[81459.325844]  [<ffffffff81264768>] ? dlm_queue_bast+0x8e/0x1b9
[81459.325938]  [<ffffffff81264768>] dlm_queue_bast+0x8e/0x1b9
[81459.326003]  [<ffffffff81250f21>] dlm_thread+0xd8c/0x169b
[81459.326081]  [<ffffffff81081226>] ? autoremove_wake_function+0x0/0x38
[81459.326148]  [<ffffffff81250195>] ? dlm_thread+0x0/0x169b
[81459.326211]  [<ffffffff81080dc2>] kthread+0x7d/0x85
[81459.326274]  [<ffffffff8102eee4>] kernel_thread_helper+0x4/0x10
[81459.326339]  [<ffffffff8161e710>] ? restore_args+0x0/0x30
[81459.326402]  [<ffffffff81080d45>] ? kthread+0x0/0x85
[81459.326463]  [<ffffffff8102eee0>] ? kernel_thread_helper+0x0/0x10

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
