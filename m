Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623Ab2ELAUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:20:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42602 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761571Ab2ELAUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:20:25 -0400
Date: Fri, 11 May 2012 17:18:57 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 11/11] pstore/ram: Add ECC support
Message-ID: <20120512001857.GK14782@lizard>
References: <20120512001506.GA8653@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120512001506.GA8653@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is now straightforward: just introduce a module parameter and pass
the needed value to persistent_ram_new().

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index cf0ad92..eeb4e32 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -61,6 +61,11 @@ module_param(dump_oops, int, 0600);
 MODULE_PARM_DESC(dump_oops,
 		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
 
+static int ramoops_ecc;
+module_param_named(ecc, ramoops_ecc, int, 0600);
+MODULE_PARM_DESC(ramoops_ecc,
+		"set to 1 to enable ECC support");
+
 struct ramoops_context {
 	struct persistent_ram_zone **przs;
 	phys_addr_t phys_addr;
@@ -251,7 +256,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 		size_t sz = cxt->record_size;
 		phys_addr_t start = cxt->phys_addr + sz * i;
 
-		cxt->przs[i] = persistent_ram_new(start, sz, 0);
+		cxt->przs[i] = persistent_ram_new(start, sz, ramoops_ecc);
 		if (IS_ERR(cxt->przs[i])) {
 			err = PTR_ERR(cxt->przs[i]);
 			pr_err("failed to initialize a prz\n");
@@ -283,9 +288,10 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	record_size = pdata->record_size;
 	dump_oops = pdata->dump_oops;
 
-	pr_info("attached 0x%lx@0x%llx (%ux0x%zx)\n",
+	pr_info("attached 0x%lx@0x%llx (%ux0x%zx), ecc: %s\n",
 		cxt->size, (unsigned long long)cxt->phys_addr,
-		cxt->max_count, cxt->record_size);
+		cxt->max_count, cxt->record_size,
+		ramoops_ecc ? "on" : "off");
 
 	return 0;
 
-- 
1.7.9.2
