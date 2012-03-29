Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab2C2Fb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 01:31:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49972 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab2C2Fbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 01:31:53 -0400
X-IronPort-AV: E=Sophos;i="4.75,335,1330876800"; 
   d="scan'208";a="4646200"
Message-ID: <4F73F507.2060501@cn.fujitsu.com>
Date: Thu, 29 Mar 2012 13:37:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: x86@kernel.org, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH x86,mm]  cleanup: don't corrupt pgt_buf_end when we don't
 allocated from it
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-29 13:29:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-29 13:29:37,
	Serialize complete at 2012-03-29 13:29:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when after_bootmem, alloc_low_page() allow page from get_zeroed_page(),
so we should not corrupt pgt_buf_end.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 436a030..cba66c6 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -317,7 +317,7 @@ void __init cleanup_highmap(void)
 
 static __ref void *alloc_low_page(unsigned long *phys)
 {
-	unsigned long pfn = pgt_buf_end++;
+	unsigned long pfn;
 	void *adr;
 
 	if (after_bootmem) {
@@ -327,6 +327,7 @@ static __ref void *alloc_low_page(unsigned long *phys)
 		return adr;
 	}
 
+	pfn = pgt_buf_end++;
 	if (pfn >= pgt_buf_top)
 		panic("alloc_low_page: ran out of memory");
 
