Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2JVJUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:20:50 -0400
Received: from zmc.proxad.net ([212.27.53.206]:45147 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2JVJUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:20:48 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: cbouatmailru@gmail.com
Cc: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        stable@vger.kernel.org, Florian Fainelli <ffainelli@freebox.fr>
Subject: [PATCH v2] pstore/ram: fix undefined usage of rounddown_pow_of_two(0)
Date: Mon, 22 Oct 2012 11:19:28 +0200
Message-Id: <1350897568-14262-1-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350647942-5260-1-git-send-email-ffainelli@freebox.fr>
References: <1350647942-5260-1-git-send-email-ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

record_size / console_size / ftrace_size can be 0 (this is how you
disable the feature), but rounddown_pow_of_two(0) is undefined. As suggested
by Kees Cook, use !is_power_of_2() as a condition to call rounddown_pow_of_two
and avoid its undefined behavior on the value 0. This issue has been present
since commit 1894a253 (ramoops: Move to fs/pstore/ram.c).

CC: stable@vger.kernel.org
Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
Changes since v1:
- use !is_power_of_2(size) instead of (!size)

 fs/pstore/ram.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1a4f6da..bdd840d 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -374,10 +374,14 @@ static int __devinit ramoops_probe(struct platform_device *pdev)
 		goto fail_out;
 	}
 
-	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
-	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
-	pdata->console_size = rounddown_pow_of_two(pdata->console_size);
-	pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
+	if (!is_power_of_2(pdata->mem_size))
+		pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
+	if (!is_power_of_2(pdata->record_size))
+		pdata->record_size = rounddown_pow_of_two(pdata->record_size);
+	if (!is_power_of_2(pdata->console_size))
+		pdata->console_size = rounddown_pow_of_two(pdata->console_size);
+	if (!is_power_of_2(pdata->ftrace_size))
+		pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
 
 	cxt->dump_read_cnt = 0;
 	cxt->size = pdata->mem_size;
-- 
1.7.9.5

