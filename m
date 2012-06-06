Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab2FFPbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:31:04 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43571 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2FFPbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:31:02 -0400
Date: Wed, 6 Jun 2012 17:31:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Frank Arnold <Frank.Arnold@amd.com>
Subject: [PATCH -v2] x86, smp: Fix topology checks on AMD MCM
Message-ID: <20120606153126.GK3080@aftab.osrc.amd.com>
References: <20120529174804.GC8263@alberich.amd.com>
 <1338813717-28112-1-git-send-email-bp@amd64.org>
 <1338813830.28282.44.camel@twins>
 <20120604133722.GB15433@aftab.osrc.amd.com>
 <1338817117.28282.48.camel@twins>
 <20120604144850.GF15433@aftab.osrc.amd.com>
 <1338821761.28282.55.camel@twins>
 <20120604160113.GI15433@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604160113.GI15433@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

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

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/r/20120529135442.GE29157@aftab.osrc.amd.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---

This is -v2, we ran a topology sanity check test we have here on it and
it all looks ok... hopefully :).

 arch/x86/kernel/smpboot.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f56f96da77f5..9432dcd86340 100644
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
 
-- 
1.7.11.rc1


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
