Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab1CJIKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:10:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59994 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab1CJIKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:10:07 -0500
Date: Thu, 10 Mar 2011 09:10:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110310081001.GA18873@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Cliff Wickman (1):
      x86, UV: Initialize the broadcast assist unit base destination node id properly

Daniel J Blueman (1):
      x86, build: Make sure mkpiggy fails on read error

Yinghai Lu (1):
      x86, numa: Fix numa_emulation code with memory-less node0


 arch/x86/boot/compressed/mkpiggy.c |    7 ++++++-
 arch/x86/include/asm/uv/uv_bau.h   |    2 +-
 arch/x86/mm/numa_64.c              |    6 +-----
 arch/x86/platform/uv/tlb_uv.c      |    4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 646aa78..46a8238 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -62,7 +62,12 @@ int main(int argc, char *argv[])
 	if (fseek(f, -4L, SEEK_END)) {
 		perror(argv[1]);
 	}
-	fread(&olen, sizeof olen, 1, f);
+
+	if (fread(&olen, sizeof(olen), 1, f) != 1) {
+		perror(argv[1]);
+		return 1;
+	}
+
 	ilen = ftell(f);
 	olen = getle32(&olen);
 	fclose(f);
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index ce1d54c..3e094af 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -176,7 +176,7 @@ struct bau_msg_payload {
 struct bau_msg_header {
 	unsigned int dest_subnodeid:6;	/* must be 0x10, for the LB */
 	/* bits 5:0 */
-	unsigned int base_dest_nodeid:15; /* nasid (pnode<<1) of */
+	unsigned int base_dest_nodeid:15; /* nasid of the */
 	/* bits 20:6 */			  /* first bit in uvhub map */
 	unsigned int command:8;	/* message type */
 	/* bits 28:21 */
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 95ea155..1337c51 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -780,11 +780,7 @@ void __cpuinit numa_add_cpu(int cpu)
 	int physnid;
 	int nid = NUMA_NO_NODE;
 
-	apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
-	if (apicid != BAD_APICID)
-		nid = apicid_to_node[apicid];
-	if (nid == NUMA_NO_NODE)
-		nid = early_cpu_to_node(cpu);
+	nid = early_cpu_to_node(cpu);
 	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
 
 	/*
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index df58e9c..a7b38d3 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1364,11 +1364,11 @@ uv_activation_descriptor_init(int node, int pnode)
 		memset(bd2, 0, sizeof(struct bau_desc));
 		bd2->header.sw_ack_flag = 1;
 		/*
-		 * base_dest_nodeid is the nasid (pnode<<1) of the first uvhub
+		 * base_dest_nodeid is the nasid of the first uvhub
 		 * in the partition. The bit map will indicate uvhub numbers,
 		 * which are 0-N in a partition. Pnodes are unique system-wide.
 		 */
-		bd2->header.base_dest_nodeid = uv_partition_base_pnode << 1;
+		bd2->header.base_dest_nodeid = UV_PNODE_TO_NASID(uv_partition_base_pnode);
 		bd2->header.dest_subnodeid = 0x10; /* the LB */
 		bd2->header.command = UV_NET_ENDPOINT_INTD;
 		bd2->header.int_both = 1;
