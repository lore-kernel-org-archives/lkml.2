Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab1GUOdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:33:31 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:52189 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab1GUOda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:33:30 -0400
X-AuditID: 12074422-b7ba7ae000000a14-13-4e2838aa4f39
From: Andy Lutomirski <luto@MIT.EDU>
To: mingo@redhat.com, wzt <wzt.wzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de, hpa@zytor.com, Michal Hocko <mhocko@suse.cz>,
        Zhitong Wang <zhitong.wangzt@alibaba-inc.com>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH] x86: Fix memory leak of init_vdso_vars()
Date: Thu, 21 Jul 2011 10:33:14 -0400
Message-Id: <d1a1b6416d71a5062fb3b3e364f9db6b6d4ef6b2.1311258580.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <20110705062148.GA6056@program>
References: <20110705062148.GA6056@program>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsUixCmqrbvKQsPPYPcROYvjEywt+q4cZbeY
	tlHc4vKuOWwWr5q/s1pcOrCAyWLzpqnMFms+n2Kz+LHhMavF7Y93WB24PCa+/cjisXPWXXaP
	Tas62TzenTvH7jHvZKDH+31X2TzOLDjC7vF5k5zHiZYvrAGcUVw2Kak5mWWpRfp2CVwZPRN2
	sxTc5q64u6WZtYFxG2cXIweHhICJxLOL2l2MnECmmMSFe+vZuhi5OIQE9jFKXLv7hhnC2cAo
	8eHzVyYI5xmTxIaVy5lAWtgEVCQ6lj4As0UEdCW+7rjNCFLELPCBUeLd62XsIAlhAUuJ7W9W
	soHYLAKqEh1PV4I18AoESZz818cGsVtO4sjl52BxTgEdiY6ua6wgtpCAtkT/yn6mCYx8CxgZ
	VjHKpuRW6eYmZuYUpybrFicn5uWlFuma6uVmluilppRuYgQFMLuL0g7GnweVDjEKcDAq8fA6
	8Kn7CbEmlhVX5h5ilORgUhLlVTXT8BPiS8pPqcxILM6ILyrNSS0+xCjBwawkwvumAqicNyWx
	siq1KB8mJc3BoiTOW+L931dIID2xJDU7NbUgtQgmK8PBoSTBKwiMVCHBotT01Iq0zJwShDQT
	ByfIcB6g4fXmQDW8xQWJucWZ6RD5U4yKUuK8bCDNAiCJjNI8uF5YgnnFKA70ijDvf5B2HmBy
	gut+BTSYCWhwi7oqyOCSRISUVAOjnoLxFtZMzwCRNdNammLtxFt05jw7KmvOc+jIIhupSGaP
	t5Ff3hlKGv01XXW82m9Rmc0nn+sy+o6az1icBL27LFVmud/XzUvate3hpNS7l9Z8TTN7Lrek
	2kBvqmqBmX+ZX8Xama7VKp9PXWTfMPf0qqMvEljfhz3MOmj3Yt3GqTaMUqbHL1xQYinOSDTU
	Yi4qTgQAXBD9kAsDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhitong Wang <wzt.wzt@gmail.com>

If init_vdso_vars ran out of memory (not very likely), then it would
leak a few pages as well.

Also rename init_vdso_vars to just init_vdso, since initializing
vvars is just about the only thing this function doesn't do.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
[Rebased and slightly simplified from the original.]
Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/vma.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index c39938d..cabaf0e 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -54,7 +54,7 @@ found:
 	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
 }
 
-static int __init init_vdso_vars(void)
+static int __init init_vdso(void)
 {
 	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
 	int i;
@@ -69,19 +69,24 @@ static int __init init_vdso_vars(void)
 		struct page *p;
 		p = alloc_page(GFP_KERNEL);
 		if (!p)
-			goto oom;
+			goto oom_free;
 		vdso_pages[i] = p;
 		copy_page(page_address(p), vdso_start + i*PAGE_SIZE);
 	}
 
 	return 0;
 
- oom:
+oom_free:
+	for(i--; i >= 0; i--)
+		__free_page(vdso_pages[i]);
+	__free_page(vdso_pages);
+
+oom:
 	printk("Cannot allocate vdso\n");
 	vdso_enabled = 0;
 	return -ENOMEM;
 }
-subsys_initcall(init_vdso_vars);
+subsys_initcall(init_vdso);
 
 struct linux_binprm;
 
-- 
1.7.6

