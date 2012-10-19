Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab2JSMAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 08:00:22 -0400
Received: from zmc.proxad.net ([212.27.53.206]:55071 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2JSMAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 08:00:21 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: cbouatmailru@gmail.com
Cc: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <ffainelli@freebox.fr>, stable@vger.kernel.org
Subject: [PATCH] pstore/ram: fix undefined usage of rounddown_pow_of_two.
Date: Fri, 19 Oct 2012 13:59:02 +0200
Message-Id: <1350647942-5260-1-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

record_size / console_size / ftrace_size can be 0 (this is how you
disable the feature), but rounddown_pow_of_two(0) is undefined. This problem
has been present since commit 1894a253 (ramoops: Move to fs/pstore/ram.c).

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
CC: stable@vger.kernel.org
---
 fs/pstore/ram.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1a4f6da..0c2ae26 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -374,10 +374,14 @@ static int __devinit ramoops_probe(struct platform_device *pdev)
 		goto fail_out;
 	}
 
-	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
-	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
-	pdata->console_size = rounddown_pow_of_two(pdata->console_size);
-	pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
+	if (pdata->mem_size)
+		pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
+	if (pdata->record_size)
+		pdata->record_size = rounddown_pow_of_two(pdata->record_size);
+	if (pdata->console_size)
+		pdata->console_size = rounddown_pow_of_two(pdata->console_size);
+	if (pdata->ftrace_size)
+		pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
 
 	cxt->dump_read_cnt = 0;
 	cxt->size = pdata->mem_size;
-- 
1.7.9.5

