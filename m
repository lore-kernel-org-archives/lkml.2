Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2IYP33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:29:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab2IYP31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:29:27 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI: Only allow users with CAP_SYS_RAWIO rights to overwrite ACPI funcs at runtime
Date: Tue, 25 Sep 2012 17:25:11 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.20-desktop; KDE/4.6.0; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com,
        initramfs@vger.kernel.org, robert.moore@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        yinghai@kernel.org, eric.piel@tremplin-utc.net, vojcek@tlen.pl
References: <1348234085-39220-1-git-send-email-trenn@suse.de> <201209240840.29342.trenn@suse.de> <20120924102159.346d0735@pyramind.ukuu.org.uk>
In-Reply-To: <20120924102159.346d0735@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251725.13085.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI: Only allow users with CAP_SYS_RAWIO rights to overwrite ACPI funcs at runtime

and tab align file_operations callbacks.

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 drivers/acpi/custom_method.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
index 5d42c24..9a0294d 100644
--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -72,9 +72,15 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
 	return count;
 }
 
+static int open_check_acc(struct inode *inode, struct file *filp)
+{
+	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
+}
+
 static const struct file_operations cm_fops = {
-	.write = cm_write,
-	.llseek = default_llseek,
+	.write	= cm_write,
+	.llseek	= default_llseek,
+	.open	= open_check_acc,
 };
 
 static int __init acpi_custom_method_init(void)
