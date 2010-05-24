Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab0EXX1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:27:31 -0400
Received: from kroah.org ([198.145.64.141]:59465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619Ab0EXXXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:49 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:15 2010
Message-Id: <20100524231815.798139777@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [29/39] x86, amd: Check X86_FEATURE_OSVW bit before accessing OSVW MSRs
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andreas Herrmann <herrmann.der.user@googlemail.com>

commit f01487119dda3d9f58c9729c7361ecc50a61c188 upstream.

If host CPU is exposed to a guest the OSVW MSRs are not guaranteed
to be present and a GP fault occurs. Thus checking the feature flag is
essential.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100427101348.GC4489@alberich.amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/process.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -539,11 +539,13 @@ static int __cpuinit check_c1e_idle(cons
 		 * check OSVW bit for CPUs that are not affected
 		 * by erratum #400
 		 */
-		rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
-		if (val >= 2) {
-			rdmsrl(MSR_AMD64_OSVW_STATUS, val);
-			if (!(val & BIT(1)))
-				goto no_c1e_idle;
+		if (cpu_has(c, X86_FEATURE_OSVW)) {
+			rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
+			if (val >= 2) {
+				rdmsrl(MSR_AMD64_OSVW_STATUS, val);
+				if (!(val & BIT(1)))
+					goto no_c1e_idle;
+			}
 		}
 		return 1;
 	}


