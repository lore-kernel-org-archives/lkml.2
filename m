Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab2EHSXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:23:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:11241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab2EHSXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:23:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150637017"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH 07/23] x86, realmode: Set permission for real mode pages
Date: Tue,  8 May 2012 21:22:30 +0300
Message-Id: <1336501366-28617-8-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set proper permissions for rodata, text and data, removing the
realmode trampoline area as a remaining RWX memory mapping in the
kernel.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/kernel/realmode.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/realmode.c b/arch/x86/kernel/realmode.c
index a465775..d85ac20 100644
--- a/arch/x86/kernel/realmode.c
+++ b/arch/x86/kernel/realmode.c
@@ -86,7 +86,21 @@ static int __init set_real_mode_permissions(void)
 		PAGE_ALIGN(real_mode_header.end) -
 		__pa(real_mode_base);
 
-	set_memory_x((unsigned long) real_mode_base, all_size >> PAGE_SHIFT);
+	size_t ro_size =
+		PAGE_ALIGN(real_mode_header.ro_end) -
+		__pa(real_mode_base);
+
+	size_t text_size =
+		PAGE_ALIGN(real_mode_header.ro_end) -
+		real_mode_header.text_start;
+
+	unsigned long text_start =
+		(unsigned long) __va(real_mode_header.text_start);
+
+	set_memory_nx((unsigned long) real_mode_base, all_size >> PAGE_SHIFT);
+	set_memory_ro((unsigned long) real_mode_base, ro_size >> PAGE_SHIFT);
+	set_memory_x((unsigned long) text_start, text_size >> PAGE_SHIFT);
+
 	return 0;
 }
 
-- 
1.7.9.5

