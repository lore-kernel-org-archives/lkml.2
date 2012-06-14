Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2FNIjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:39:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60682 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2FNIjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:39:41 -0400
Date: Thu, 14 Jun 2012 01:39:21 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-161270fc1f9ddfc17154e0d49291472a9cdef7db@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, andreas.herrmann3@amd.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <20120529135442.GE29157@aftab.osrc.amd.com>
References: <20120529135442.GE29157@aftab.osrc.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/smp: Fix topology checks on AMD MCM CPUs
Git-Commit-ID: 161270fc1f9ddfc17154e0d49291472a9cdef7db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 01:39:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  161270fc1f9ddfc17154e0d49291472a9cdef7db
Gitweb:     http://git.kernel.org/tip/161270fc1f9ddfc17154e0d49291472a9cdef7db
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 6 Jun 2012 17:31:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Jun 2012 14:56:12 +0200

x86/smp: Fix topology checks on AMD MCM CPUs

The warning below triggers on AMD MCM packages because physical package
IDs on the cores of a _physical_ socket are the same. I.e., this field
says which CPUs belong to the same physical package.

However, the same two CPUs belong to two different internal, i.e.
"logical" nodes in the same physical socket which is reflected in the
CPU-to-node map on x86 with NUMA.

Which makes this check wrong on the above topologies so circumvent it.

[    0.444413] Booting Node   0, Processors  #1 #2 #3 #4 #5 Ok.
[    0.461388] ------------[ cut here ]------------
[    0.465997] WARNING: at arch/x86/kernel/smpboot.c:310 topology_sane.clone.1+0x6e/0x81()
[    0.473960] Hardware name: Dinar
[    0.477170] sched: CPU #6's mc-sibling CPU #0 is not on the same node! [node: 1 != 0]. Ignoring dependency.
[    0.486860] Booting Node   1, Processors  #6
[    0.491104] Modules linked in:
[    0.494141] Pid: 0, comm: swapper/6 Not tainted 3.4.0+ #1
[    0.499510] Call Trace:
[    0.501946]  [<ffffffff8144bf92>] ? topology_sane.clone.1+0x6e/0x81
[    0.508185]  [<ffffffff8102f1fc>] warn_slowpath_common+0x85/0x9d
[    0.514163]  [<ffffffff8102f2b7>] warn_slowpath_fmt+0x46/0x48
[    0.519881]  [<ffffffff8144bf92>] topology_sane.clone.1+0x6e/0x81
[    0.525943]  [<ffffffff8144c234>] set_cpu_sibling_map+0x251/0x371
[    0.532004]  [<ffffffff8144c4ee>] start_secondary+0x19a/0x218
[    0.537729] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.628197]  #7 #8 #9 #10 #11 Ok.
[    0.807108] Booting Node   3, Processors  #12 #13 #14 #15 #16 #17 Ok.
[    0.897587] Booting Node   2, Processors  #18 #19 #20 #21 #22 #23 Ok.
[    0.917443] Brought up 24 CPUs

We ran a topology sanity check test we have here on it and
it all looks ok... hopefully :).

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120529135442.GE29157@aftab.osrc.amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fd019d7..c3a6bac 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -349,9 +349,12 @@ static bool __cpuinit match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 
 static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
-	if (c->phys_proc_id == o->phys_proc_id)
-		return topology_sane(c, o, "mc");
+	if (c->phys_proc_id == o->phys_proc_id) {
+		if (cpu_has(c, X86_FEATURE_AMD_DCM))
+			return true;
 
+		return topology_sane(c, o, "mc");
+	}
 	return false;
 }
 
