Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910Ab1FWRjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:39:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:35776 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933887Ab1FWRi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Stuart Hayes <stuart_hayes@yahoo.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 231/247] dcdbas: force SMI to happen when expected
Date: Thu, 23 Jun 2011 13:34:59 -0400
Message-Id: <1308850515-15242-172-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stuart Hayes <stuart_hayes@yahoo.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit dd65c736d1b5312c80c88a64bf521db4959eded5 upstream.

The dcdbas driver can do an I/O write to cause a SMI to occur.  The SMI handler
looks at certain registers and memory locations, so the SMI needs to happen
immediately.  On some systems I/O writes are posted, though, causing the SMI to
happen well after the "outb" occurred, which causes random failures.  Following
the "outb" with an "inb" forces the write to go through even if it is posted.

Signed-off-by: Stuart Hayes <stuart_hayes@yahoo.com>
Acked-by: Doug Warzecha <douglas_warzecha@dell.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/firmware/dcdbas.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index fb09bb3..385478c 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -268,8 +268,10 @@ int dcdbas_smi_request(struct smi_cmd *smi_cmd)
 	}
 
 	/* generate SMI */
+	/* inb to force posted write through and make SMI happen now */
 	asm volatile (
-		"outb %b0,%w1"
+		"outb %b0,%w1\n"
+		"inb %w1"
 		: /* no output args */
 		: "a" (smi_cmd->command_code),
 		  "d" (smi_cmd->command_address),
-- 
1.7.4.4

