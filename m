Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0ELL7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 07:59:20 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:43614 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab0ELL7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 07:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=c2rdUSgSn/lMu3IZf0VMnqbfsMiaYM/y93xe/csq+ib5Hz56q8pwSAFXzr3ldIElkn
         lENg6Wb3adZjxCQsODiFjpp/hQPqyzY1Be1Hwh9xWVxJMQMzwXe8irZAuwm8bh8MKFji
         HtHgWWnxr6tQXn1txaENqHK+BlLBtkUAvygAc=
Date: Wed, 12 May 2010 13:59:14 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH resend] x86, amd: Check X86_FEATURE_OSVW bit before
 accessing OSVW MSRs
Message-ID: <20100512115914.GA10254@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If host CPU is exposed to a guest the OSVW MSRs are not guaranteed
to be present and a GP fault occurs. Thus checking the feature flag is
essential.

Cc: <stable@kernel.org> # .32.x .33.x, .34.x
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/process.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 28ad9f4..0415c3e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -546,11 +546,13 @@ static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
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
-- 
1.6.4.4

