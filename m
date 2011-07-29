Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab1G2MkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:40:23 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:43059 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1G2MkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:40:21 -0400
Message-Id: <20110729124000.809651778@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 29 Jul 2011 14:39:47 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 3/3] kexec-tools: Emit program check on s390 for checksum failure
References: <20110729123944.562622201@linux.vnet.ibm.com>
Content-Disposition: inline; filename=kexec-tools-s390-kdump-entry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

With this patch on s390 a program check interrupt is emitted if purgatory
checksums are not valid. This establishes a error handling mechanism where
the caller of crash_kexec/purgatory can catch the error by installing a
program check handler function. On s390 this will be used by our stand-alone
dump tools. The tools first get control and install a program check handler.
Then if kdump is pre-loaded, the dump tools jump into the old kernel where
crash_kexec->purgatory is executed. If kdump fails on this code path, a
program check is emitted and then control is passed back to the stand-alone
dump tools that will then create a full-blown dump as backup mechanism.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 purgatory/arch/i386/purgatory-x86.c      |    7 +++++++
 purgatory/arch/ia64/purgatory-ia64.c     |    7 +++++++
 purgatory/arch/ppc/purgatory-ppc.c       |    7 +++++++
 purgatory/arch/ppc64/purgatory-ppc64.c   |    7 +++++++
 purgatory/arch/s390/purgatory-s390.c     |   11 +++++++++++
 purgatory/arch/x86_64/purgatory-x86_64.c |    7 +++++++
 purgatory/include/purgatory.h            |    1 +
 purgatory/purgatory.c                    |    4 +---
 8 files changed, 48 insertions(+), 3 deletions(-)

--- a/purgatory/arch/i386/purgatory-x86.c
+++ b/purgatory/arch/i386/purgatory-x86.c
@@ -55,3 +55,10 @@ void post_verification_setup_arch(void)
 	if (panic_kernel)    crashdump_backup_memory();
 	if (jump_back_entry) x86_setup_jump_back_entry();
 }
+
+void sha256_digest_failed(void)
+{
+	for(;;) {
+		/* loop forever */
+	}
+}
--- a/purgatory/arch/ia64/purgatory-ia64.c
+++ b/purgatory/arch/ia64/purgatory-ia64.c
@@ -305,3 +305,10 @@ void post_verification_setup_arch(void)
 {
 	/* Nothing for now */
 }
+
+void sha256_digest_failed(void)
+{
+	for(;;) {
+		/* loop forever */
+	}
+}
--- a/purgatory/arch/ppc/purgatory-ppc.c
+++ b/purgatory/arch/ppc/purgatory-ppc.c
@@ -44,3 +44,10 @@ void crashdump_backup_memory(void)
 {
 	return;
 }
+
+void sha256_digest_failed(void)
+{
+	for(;;) {
+		/* loop forever */
+	}
+}
--- a/purgatory/arch/ppc64/purgatory-ppc64.c
+++ b/purgatory/arch/ppc64/purgatory-ppc64.c
@@ -40,3 +40,10 @@ void post_verification_setup_arch(void)
 	if (panic_kernel)
 		crashdump_backup_memory();
 }
+
+void sha256_digest_failed(void)
+{
+	for(;;) {
+		/* loop forever */
+	}
+}
--- a/purgatory/arch/s390/purgatory-s390.c
+++ b/purgatory/arch/s390/purgatory-s390.c
@@ -6,6 +6,12 @@
  * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
  */
 
+#define EMIT_PGM_CHECK() do {			\
+	asm volatile(			\
+		"0:     j       0b+2\n"	\
+	: :);				\
+} while (0)
+
 unsigned long kdump_psw_addr = 0;
 
 void setup_arch(void)
@@ -15,3 +21,8 @@ void setup_arch(void)
 void post_verification_setup_arch(void)
 {
 }
+
+void sha256_digest_failed(void)
+{
+	EMIT_PGM_CHECK();
+}
--- a/purgatory/arch/x86_64/purgatory-x86_64.c
+++ b/purgatory/arch/x86_64/purgatory-x86_64.c
@@ -28,3 +28,10 @@ void post_verification_setup_arch(void)
 	if (panic_kernel)    crashdump_backup_memory();
 	if (jump_back_entry) x86_setup_jump_back_entry();
 }
+
+void sha256_digest_failed(void)
+{
+	for(;;) {
+		/* loop forever */
+	}
+}
--- a/purgatory/include/purgatory.h
+++ b/purgatory/include/purgatory.h
@@ -6,5 +6,6 @@ void sprintf(char *buffer, const char *f
 void printf(const char *fmt, ...);
 void setup_arch(void);
 void post_verification_setup_arch(void);
+void sha256_digest_failed(void);
 
 #endif /* PURGATORY_H */
--- a/purgatory/purgatory.c
+++ b/purgatory/purgatory.c
@@ -34,9 +34,7 @@ void verify_sha256_digest(void)
 			printf("%hhx ", sha256_digest[i]);
 		}
 		printf("\n");
-		for(;;) {
-			/* loop forever */
-		}
+		sha256_digest_failed();
 	}
 }
 

