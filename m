Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934423Ab1CYCKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 22:10:04 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50415 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934394Ab1CYCJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 22:09:59 -0400
X-Sasl-enc: Hbqkkhh0qxNwgJPSHo5arzqVzBPMdJ9fYco8hbddTyWG 1301018998
Date: Thu, 24 Mar 2011 23:09:54 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Burt Triplett <burt@pbjtriplett.org>
Subject: x86/microcode: intel: correctly handle negative revisions
Message-ID: <20110325020954.GC4535@khazad-dum.debian.net>
References: <4D65EE74.1050709@pbjtriplett.org>
 <20110312023001.GB27550@khazad-dum.debian.net>
 <4D87E2CD.6020306@pbjtriplett.org>
 <20110324001451.GA7950@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324001451.GA7950@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the Intel SDM vol 3A, microcode revisions are signed 32-bit
numbers.  The code was handling them as unsigned int in some places and as
an int in other places.

As per the clarification posted by Burt Triplett from the Intel BITS
project, negative microcode revisions are used internally at Intel and
should always get loaded.  Also, they should not be overriden unless we
can somehow differentiate "automated" loading from "forced" loading (which
we cannot at this time).  Burt says the SDM will be updated with this
information eventually.

The code should:

1. Ignore attempts to load a zero-revision microcode (that value is
reserved for the CPU to signal that it is running with the factory
microcode, and must not be present in a normal microcode update);

2. Always load negative revision microcodes, to help Intel's engineers;

3. Avoid upgrading from a BIOS-loaded negative revision microcode to
a normal microcode, to not get in the way of Intel's engineers.

4. Upgrade from revision 0 (no updates loaded in CPU) to any revision.

It was already doing some of that, but I don't feel like trying to track
down exactly how the old code with its mix of signed/unsigned handling of
revisions would behave in each of the above cases.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
LKML-Reference: <4D87E2CD.6020306@pbjtriplett.org>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Burt Triplett <burt@pbjtriplett.org>

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 1a1b606..92b7cfe 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -89,7 +89,7 @@ MODULE_LICENSE("GPL");
 
 struct microcode_header_intel {
 	unsigned int            hdrver;
-	unsigned int            rev;
+	int                     rev;
 	unsigned int            date;
 	unsigned int            sig;
 	unsigned int            cksum;
@@ -178,10 +178,15 @@ static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
 	return (!sigmatch(sig, csig->sig, pf, csig->pf)) ? 0 : 1;
 }
 
+/*
+ * rev < 0 : devel/test microcode, always install
+ * rev = 0 : (cpu: no microcode installed.  data file: illegal)
+ * rev > 0 : normal microcode, avoid downgrading
+ */
 static inline int
 update_match_revision(struct microcode_header_intel *mc_header, int rev)
 {
-	return (mc_header->rev <= rev) ? 0 : 1;
+	return !!(mc_header->rev < 0 || (mc_header->rev > rev && rev >= 0));
 }
 
 static int microcode_sanity_check(void *mc)
@@ -298,7 +303,7 @@ static int apply_microcode(int cpu)
 {
 	struct microcode_intel *mc_intel;
 	struct ucode_cpu_info *uci;
-	unsigned int val[2];
+	int val[2];
 	int cpu_num;
 
 	cpu_num = raw_smp_processor_id();
-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
