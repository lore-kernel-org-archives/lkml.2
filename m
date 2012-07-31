Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2GaOPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:15:43 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:36242 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2GaOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:15:42 -0400
Date: Tue, 31 Jul 2012 16:15:36 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] samples/seccomp: fix endianness bug in LO_ARG define
Message-ID: <20120731141536.GA4262@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12073114-5024-0000-0000-000003628841
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The LO_ARG define needs to consider endianness also for 32 bit builds.

The "bpf_fancy" test case didn't work on s390 in 32 bit and compat mode
because the LO_ARG define resulted in a BPF program which read the upper
halve of the 64 bit system call arguments instead of the lower halves.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 samples/seccomp/bpf-helper.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/samples/seccomp/bpf-helper.h b/samples/seccomp/bpf-helper.h
index 643279d..38ee70f 100644
--- a/samples/seccomp/bpf-helper.h
+++ b/samples/seccomp/bpf-helper.h
@@ -59,6 +59,16 @@ void seccomp_bpf_print(struct sock_filter *filter, size_t count);
 #define FIND_LABEL(labels, label) seccomp_bpf_label((labels), #label)
 
 #define EXPAND(...) __VA_ARGS__
+
+/* Ensure that we load the logically correct offset. */
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define LO_ARG(idx) offsetof(struct seccomp_data, args[(idx)])
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#define LO_ARG(idx) offsetof(struct seccomp_data, args[(idx)]) + sizeof(__u32)
+#else
+#error "Unknown endianness"
+#endif
+
 /* Map all width-sensitive operations */
 #if __BITS_PER_LONG == 32
 
@@ -70,21 +80,16 @@ void seccomp_bpf_print(struct sock_filter *filter, size_t count);
 #define JLE(x, jt) JLE32(x, EXPAND(jt))
 #define JA(x, jt) JA32(x, EXPAND(jt))
 #define ARG(i) ARG_32(i)
-#define LO_ARG(idx) offsetof(struct seccomp_data, args[(idx)])
 
 #elif __BITS_PER_LONG == 64
 
 /* Ensure that we load the logically correct offset. */
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #define ENDIAN(_lo, _hi) _lo, _hi
-#define LO_ARG(idx) offsetof(struct seccomp_data, args[(idx)])
 #define HI_ARG(idx) offsetof(struct seccomp_data, args[(idx)]) + sizeof(__u32)
 #elif __BYTE_ORDER == __BIG_ENDIAN
 #define ENDIAN(_lo, _hi) _hi, _lo
-#define LO_ARG(idx) offsetof(struct seccomp_data, args[(idx)]) + sizeof(__u32)
 #define HI_ARG(idx) offsetof(struct seccomp_data, args[(idx)])
-#else
-#error "Unknown endianness"
 #endif
 
 union arg64 {
-- 
1.7.11.4

