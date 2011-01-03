Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab1ACLai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:30:38 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:24989
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367Ab1ACLag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:30:36 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jan 2011 06:30:36 EST
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzz8275bh8275dhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEG1XE-01-56L-02
X-M-MSG: 
Date: Mon, 3 Jan 2011 12:15:14 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        <atswartz@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dan Carpenter <error27@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@kernel.org>
Subject: [PATCH] arch/x86/oprofile/op_model_amd.c: perform initialisation
 on a single CPU
Message-ID: <20110103111514.GM4739@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101230173847.GA2734@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.12.10 12:38:47, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > On 29.12.10 11:37:43, Ingo Molnar wrote:
> > 
> > > Hm, i'm not sure this fix is correct:
> > > 
> > >  static int op_amd_init(struct oprofile_operations *ops)
> > >  {
> > > +       /*
> > > +        * init_ibs() preforms implictly cpu-local operations, so pin this
> > > +        * thread to its current CPU
> > > +        */
> > > +       preempt_disable();
> > >         init_ibs();
> > > +       preempt_enable();
> > > 
> > > If init_ibs() is indeed CPU local, then it needs to be called on all CPUs. Does 
> > > that happen and if not why not? AFAICS it's only called on one CPU.
> > 
> > It is correct to run init_ibs() only on one cpu.  It only checks the ibs 
> > capabilities and sets up pci devices (if necessary). It runs only on one cpu but 
> > operates with the local APIC and some MSRs, thus it is better to disable 
> > preemption.
> 
> Ok, but in that case the prempt_disable()/enable() should be put into init_ibs(), 
> not be open-coded at the caller like that.
> 
> The comment about its cpu-localness could move to init_ibs() as well.

Ingo,

the patch below addresses this.  Please apply to tip/perf/urgent.

Thanks,

-Robert

--

>From 41659787561d3b384dac0b8458de95e35d8f2a34 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Mon, 3 Jan 2011 10:36:53 +0100
Subject: [PATCH] arch/x86/oprofile/op_model_amd.c: perform initialisation on a single CPU

Disable preemption in init_ibs(). The function only checks the ibs
capabilities and sets up pci devices (if necessary). It runs only on
one cpu but operates with the local APIC and some MSRs, thus it is
better to disable preemption.

[    7.034377] BUG: using smp_processor_id() in preemptible [00000000] code:
modprobe/483
[    7.034385] caller is setup_APIC_eilvt+0x155/0x180
[    7.034389] Pid: 483, comm: modprobe Not tainted 2.6.37-rc1-20101110+ #1
[    7.034392] Call Trace:
[    7.034400]  [<ffffffff812a2b72>] debug_smp_processor_id+0xd2/0xf0
[    7.034404]  [<ffffffff8101e985>] setup_APIC_eilvt+0x155/0x180
[    7.034413]  [<ffffffffa002e168>] op_amd_init+0x88/0x2b0 [oprofile]
[    7.034420]  [<ffffffffa0043000>] ? oprofile_init+0x0/0x42 [oprofile]
[    7.034425]  [<ffffffffa0043315>] op_nmi_init+0x249/0x2af [oprofile]
[    7.034431]  [<ffffffffa00430b4>] oprofile_arch_init+0x11/0x29 [oprofile]
[    7.034437]  [<ffffffffa0043010>] oprofile_init+0x10/0x42 [oprofile]
[    7.034441]  [<ffffffff810001e3>] do_one_initcall+0x43/0x170
[    7.034445]  [<ffffffff8108a52a>] sys_init_module+0xba/0x200
[    7.034449]  [<ffffffff8100285b>] system_call_fastpath+0x16/0x1b

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=22812

Reported-by: <atswartz@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@kernel.org>         [2.6.37.x]
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index a011bcc..8d7d883 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -630,7 +630,14 @@ static int __init_ibs_nmi(void)
 	return 0;
 }
 
-/* initialize the APIC for the IBS interrupts if available */
+/*
+ * check and reserve APIC extended interrupt LVT offset for IBS if
+ * available
+ *
+ * init_ibs() preforms implicitly cpu-local operations, so pin this
+ * thread to its current CPU
+ */
+
 static void init_ibs(void)
 {
 	ibs_caps = get_ibs_caps();
@@ -638,13 +645,15 @@ static void init_ibs(void)
 	if (!ibs_caps)
 		return;
 
-	if (__init_ibs_nmi()) {
+	preempt_disable();
+
+	if (__init_ibs_nmi())
 		ibs_caps = 0;
-		return;
-	}
+	else
+		printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n",
+		       (unsigned)ibs_caps);
 
-	printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n",
-	       (unsigned)ibs_caps);
+	preempt_enable();
 }
 
 static int (*create_arch_files)(struct super_block *sb, struct dentry *root);
-- 
1.7.3.2



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

