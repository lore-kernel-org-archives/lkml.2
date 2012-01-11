Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab2AKOZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 09:25:04 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39548 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777Ab2AKOZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 09:25:02 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] x86, mce: Fix rcu splat in drain_mce_log_buffer()
To: bp@amd64.org
Cc: tony.luck@intel.com, tglx@linutronix.de, mingo@elte.hu,
        paulmck@linux.vnet.ibm.com, hpa@zytor.com, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcos.mage@gmail.com, prasad@linux.vnet.ibm.com
Date: Wed, 11 Jan 2012 19:54:48 +0530
Message-ID: <20120111142213.16610.85866.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12011114-3864-0000-0000-000000E4A6A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While booting, the following message is seen:

[   21.665087] ===============================
[   21.669439] [ INFO: suspicious RCU usage. ]
[   21.673798] 3.2.0-0.0.0.28.36b5ec9-default #2 Not tainted
[   21.681353] -------------------------------
[   21.685864] arch/x86/kernel/cpu/mcheck/mce.c:194 suspicious rcu_dereference_index_check() usage!
[   21.695013]
[   21.695014] other info that might help us debug this:
[   21.695016]
[   21.703488]
[   21.703489] rcu_scheduler_active = 1, debug_locks = 1
[   21.710426] 3 locks held by modprobe/2139:
[   21.714754]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff8133afd3>] __driver_attach+0x53/0xa0
[   21.725020]  #1:
[   21.725323] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   21.733206]  (&__lockdep_no_validate__){......}, at: [<ffffffff8133afe1>] __driver_attach+0x61/0xa0
[   21.743015]  #2:  (i7core_edac_lock){+.+.+.}, at: [<ffffffffa01cfa5f>] i7core_probe+0x1f/0x5c0 [i7core_edac]
[   21.753708]
[   21.753709] stack backtrace:
[   21.758429] Pid: 2139, comm: modprobe Not tainted 3.2.0-0.0.0.28.36b5ec9-default #2
[   21.768253] Call Trace:
[   21.770838]  [<ffffffff810977cd>] lockdep_rcu_suspicious+0xcd/0x100
[   21.777366]  [<ffffffff8101aa41>] drain_mcelog_buffer+0x191/0x1b0
[   21.783715]  [<ffffffff8101aa78>] mce_register_decode_chain+0x18/0x20
[   21.790430]  [<ffffffffa01cf8db>] i7core_register_mci+0x2fb/0x3e4 [i7core_edac]
[   21.798003]  [<ffffffffa01cfb14>] i7core_probe+0xd4/0x5c0 [i7core_edac]
[   21.804809]  [<ffffffff8129566b>] local_pci_probe+0x5b/0xe0
[   21.810631]  [<ffffffff812957c9>] __pci_device_probe+0xd9/0xe0
[   21.816650]  [<ffffffff813362e4>] ? get_device+0x14/0x20
[   21.822178]  [<ffffffff81296916>] pci_device_probe+0x36/0x60
[   21.828061]  [<ffffffff8133ac8a>] really_probe+0x7a/0x2b0
[   21.833676]  [<ffffffff8133af23>] driver_probe_device+0x63/0xc0
[   21.839868]  [<ffffffff8133b01b>] __driver_attach+0x9b/0xa0
[   21.845718]  [<ffffffff8133af80>] ? driver_probe_device+0xc0/0xc0
[   21.852027]  [<ffffffff81339168>] bus_for_each_dev+0x68/0x90
[   21.857876]  [<ffffffff8133aa3c>] driver_attach+0x1c/0x20
[   21.863462]  [<ffffffff8133a64d>] bus_add_driver+0x16d/0x2b0
[   21.869377]  [<ffffffff8133b6dc>] driver_register+0x7c/0x160
[   21.875220]  [<ffffffff81296bda>] __pci_register_driver+0x6a/0xf0
[   21.881494]  [<ffffffffa01fe000>] ? 0xffffffffa01fdfff
[   21.886846]  [<ffffffffa01fe047>] i7core_init+0x47/0x1000 [i7core_edac]
[   21.893737]  [<ffffffff810001ce>] do_one_initcall+0x3e/0x180
[   21.899670]  [<ffffffff810a9b95>] sys_init_module+0xc5/0x220
[   21.905542]  [<ffffffff8149bc39>] system_call_fastpath+0x16/0x1b

Fix this by using rcu_access_index() instead of rcu_dereference_check_mce().
This is similar to what was done in commit a4dd992 (rcu: create new
rcu_access_index() and use in mce) for a similar case in mce_poll.
Link to that discussion: http://thread.gmane.org/gmane.linux.kernel/1058460/

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---
I am no MCE expert. Hence requesting a thorough review of the patch.

 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index f22a9f7..c191fec 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -191,7 +191,7 @@ static void drain_mcelog_buffer(void)
 {
 	unsigned int next, i, prev = 0;
 
-	next = rcu_dereference_check_mce(mcelog.next);
+	next = rcu_access_index(mcelog.next);
 
 	do {
 		struct mce *m;

