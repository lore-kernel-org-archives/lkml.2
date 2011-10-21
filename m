Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab1JUVsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 17:48:10 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:40149 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1JUVsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 17:48:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/lkml
CC: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, selinux@tycho.nsa.gov,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] SELinux: Do not apply MMAP_ZERO check to PROT_NONE mappings
In-Reply-To: Roland McGrath's message of  Friday, 21 October 2011 14:39:16 -0700 <20111021213916.914462C0A5@topped-with-meat.com>
References: <20111021213916.914462C0A5@topped-with-meat.com>
Emacs: the answer to the world surplus of CPU cycles.
Message-Id: <20111021213955.7A46F2C0BF@topped-with-meat.com>
Date: Fri, 21 Oct 2011 14:39:55 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=fe7WOzsF c=1 sm=1 a=gmN3L6-WT1wA:10
		a=kj9zAlcOel0A:10 a=hOe2yjtxAAAA:8 a=4cy4ZfLFnbfrfChgsJEA:9
		a=CjuIK1q_8ugA:10 a=Uzso29ByltnbLLyh:21 a=5lY6_s-9Q76-PHGN:21
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An mmap with PROT_NONE is done specifically to ensure that an address
will fault.  So doing this on addresses below CONFIG_LSM_MMAP_MIN_ADDR
is not seeking a "dangerous" operation.  Conversely, it's an attempt
to ensure robustness in case CONFIG_LSM_MMAP_MIN_ADDR or vm.mmap_min_addr
is less restrictive than the user wants to be.

Since we might let a low mapping exist at all without a check, we
add another check to prevent mprotect from granting access to such
a mapping without passing an MMAP_ZERO security check.

Signed-off-by: Roland McGrath <roland@hack.frob.com>
---
 security/selinux/hooks.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 76e6f04..1e3657b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3062,7 +3062,8 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 	 * at bad behaviour/exploit that we always want to get the AVC, even
 	 * if DAC would have also denied the operation.
 	 */
-	if (addr < CONFIG_LSM_MMAP_MIN_ADDR) {
+	if (addr < CONFIG_LSM_MMAP_MIN_ADDR &&
+	    (addr_only || prot != PROT_NONE)) {
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
 				  MEMPROTECT__MMAP_ZERO, NULL);
 		if (rc)
@@ -3091,6 +3092,20 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 	if (selinux_checkreqprot)
 		prot = reqprot;
 
+	/*
+	 * Notice that we are intentionally putting the SELinux check before
+	 * the secondary cap_file_mprotect check.  This is such a likely attempt
+	 * at bad behaviour/exploit that we always want to get the AVC, even
+	 * if DAC would have also denied the operation.
+	 */
+	if (addr < CONFIG_LSM_MMAP_MIN_ADDR && prot != PROT_NONE) {
+		u32 sid = current_sid();
+		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
+				  MEMPROTECT__MMAP_ZERO, NULL);
+		if (rc)
+			return rc;
+	}
+
 	/* do DAC check on address space usage */
 	rc = cap_file_mprotect(vma, reqprot, prot)
 	if (rc)
