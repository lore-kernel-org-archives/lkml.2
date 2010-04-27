Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0D0KV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:21:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37635 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0D0KV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:21:57 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Apr 2010 06:21:56 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=SoX+t5vMDV9ScZSWglBhfa9swOGaR8QGrhE3lJXKzk0+YozskkjFT/HqRISm1CZpwu
         IFszoAG//D+DI+AUKb3H5aUF3GIX9Lk9aGMkKIbWCRvWLy4e3OIBMrjHQEFw4xkyLSb6
         igpTba18pnhmPz6VjW2+fUrorYkULzqYY0oZc=
Date: Tue, 27 Apr 2010 12:13:48 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, amd: Check X86_FEATURE_OSVW bit before accessing OSVW
 MSRs
Message-ID: <20100427101348.GC4489@alberich.amd.com>
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

Cc: <stable@kernel.org> # .32.x .33.x
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

