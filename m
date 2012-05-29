Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2E2NyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:54:15 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:58331 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2E2NyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:54:14 -0400
Date: Tue, 29 May 2012 15:54:42 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at arch/x86/kernel/smpboot.c:310
 topology_sane.clone.1+0x6e/0x81()
Message-ID: <20120529135442.GE29157@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudes,

I'm getting the warning below on current linus. AFAICT, it is caused by

static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
{
        if (c->phys_proc_id == o->phys_proc_id)
                return topology_sane(c, o, "mc");

        return false;
}

and the reason is, IMHO, that because this is a MCM box which has two
nodes in one physical package, i.e., phys_proc_id is 0 on both CPU6 and
CPU0 but it has two internal nodes, 0 and 1 and CPUs 0-5 are on node 0
and CPUs 6-11 are on node 1, the warning fires.

Maybe we could do something like this untested hunk:

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 433529e29be4..e52538cd48bb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -348,7 +348,8 @@ static bool __cpuinit match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
        if (c->phys_proc_id == o->phys_proc_id)
-               return topology_sane(c, o, "mc");
+               if (!cpu_has(c, X86_FEATURE_AMD_DCM))
+                       return topology_sane(c, o, "mc");
 
        return false;
 }

or you have a better idea...?

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

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
