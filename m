Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0HMW7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 18:59:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:41253 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab0HMW7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 18:59:18 -0400
Date: Fri, 13 Aug 2010 22:58:59 GMT
Message-Id: <201008132258.o7DMwxnR009499@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/uv for 2.6.36 - second batch
Cc: <stable@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Cliff Wickman <cpw@sgi.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 13 Aug 2010 22:59:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Second x86/uv batch, as promised.

The following changes since commit 2be1f3a73dd02e38e181cf5abacb3d45a6a2d6b8:

  Merge branch 'for-linus' of git://git390.marist.edu/pub/scm/linux-2.6 (2010-08-13 10:54:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-uv-for-linus

Cliff Wickman (3):
      x86, UV: Make kdump avoid stack dumps
      x86, UV: Initialize BAU hub map
      x86, UV: Make kdump avoid stack dumps - fix !CONFIG_KEXEC breakage

 arch/x86/include/asm/kdebug.h      |    6 ++++++
 arch/x86/kernel/apic/x2apic_uv_x.c |    4 ++++
 arch/x86/kernel/crash.c            |    3 +++
 arch/x86/kernel/tlb_uv.c           |   26 ++++++++++++++------------
 4 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index fa7c0b9..5bdfca8 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -33,5 +33,11 @@ extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
+#ifdef CONFIG_KEXEC
+extern int in_crash_kexec;
+#else
+/* no crash dump is ever in progress if no crash kernel can be kexec'd */
+#define in_crash_kexec 0
+#endif
 
 #endif /* _ASM_X86_KDEBUG_H */
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index e46f98f..7b598b8 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -604,6 +604,10 @@ int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 {
 	if (reason != DIE_NMI_IPI)
 		return NOTIFY_OK;
+
+	if (in_crash_kexec)
+		/* do nothing if entering the crash kernel */
+		return NOTIFY_OK;
 	/*
 	 * Use a lock so only one cpu prints at a time
 	 * to prevent intermixed output.
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index ebd4c51..764c7c2 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -28,6 +28,8 @@
 #include <asm/reboot.h>
 #include <asm/virtext.h>
 
+int in_crash_kexec;
+
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
 static void kdump_nmi_callback(int cpu, struct die_args *args)
@@ -61,6 +63,7 @@ static void kdump_nmi_callback(int cpu, struct die_args *args)
 
 static void kdump_nmi_shootdown_cpus(void)
 {
+	in_crash_kexec = 1;
 	nmi_shootdown_cpus(kdump_nmi_callback);
 
 	disable_local_APIC();
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 59efb53..312ef02 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -1484,15 +1484,16 @@ calculate_destination_timeout(void)
 /*
  * initialize the bau_control structure for each cpu
  */
-static void uv_init_per_cpu(int nuvhubs)
+static void __init uv_init_per_cpu(int nuvhubs)
 {
 	int i;
 	int cpu;
 	int pnode;
 	int uvhub;
+	int have_hmaster;
 	short socket = 0;
 	unsigned short socket_mask;
-	unsigned int uvhub_mask;
+	unsigned char *uvhub_mask;
 	struct bau_control *bcp;
 	struct uvhub_desc *bdp;
 	struct socket_desc *sdp;
@@ -1516,28 +1517,29 @@ static void uv_init_per_cpu(int nuvhubs)
 	uvhub_descs = (struct uvhub_desc *)
 		kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
 	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
+	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
 		memset(bcp, 0, sizeof(struct bau_control));
 		pnode = uv_cpu_hub_info(cpu)->pnode;
 		uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
-		uvhub_mask |= (1 << uvhub);
+		*(uvhub_mask + (uvhub/8)) |= (1 << (uvhub%8));
 		bdp = &uvhub_descs[uvhub];
 		bdp->num_cpus++;
 		bdp->uvhub = uvhub;
 		bdp->pnode = pnode;
 		/* kludge: 'assuming' one node per socket, and assuming that
 		   disabling a socket just leaves a gap in node numbers */
-		socket = (cpu_to_node(cpu) & 1);;
+		socket = (cpu_to_node(cpu) & 1);
 		bdp->socket_mask |= (1 << socket);
 		sdp = &bdp->socket[socket];
 		sdp->cpu_number[sdp->num_cpus] = cpu;
 		sdp->num_cpus++;
 	}
-	uvhub = 0;
-	while (uvhub_mask) {
-		if (!(uvhub_mask & 1))
-			goto nexthub;
+	for (uvhub = 0; uvhub < nuvhubs; uvhub++) {
+		if (!(*(uvhub_mask + (uvhub/8)) & (1 << (uvhub%8))))
+			continue;
+		have_hmaster = 0;
 		bdp = &uvhub_descs[uvhub];
 		socket_mask = bdp->socket_mask;
 		socket = 0;
@@ -1551,8 +1553,10 @@ static void uv_init_per_cpu(int nuvhubs)
 				bcp->cpu = cpu;
 				if (i == 0) {
 					smaster = bcp;
-					if (socket == 0)
+					if (!have_hmaster) {
+						have_hmaster++;
 						hmaster = bcp;
+					}
 				}
 				bcp->cpus_in_uvhub = bdp->num_cpus;
 				bcp->cpus_in_socket = sdp->num_cpus;
@@ -1566,11 +1570,9 @@ nextsocket:
 			socket++;
 			socket_mask = (socket_mask >> 1);
 		}
-nexthub:
-		uvhub++;
-		uvhub_mask = (uvhub_mask >> 1);
 	}
 	kfree(uvhub_descs);
+	kfree(uvhub_mask);
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
 		bcp->baudisabled = 0;
