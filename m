Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1ABHZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:40 -0500
Received: from mail.windriver.com ([147.11.1.11]:37108 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab1ABHZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:37 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Paul Fox <pgf@laptop.org>,
        Daniel Drake <dsd@laptop.org>, dilinger@queued.net,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 229/260] x86, olpc: Don't retry EC commands forever
Date: Sun,  2 Jan 2011 02:18:45 -0500
Message-Id: <1293952756-15010-230-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:20.0730 (UTC) FILETIME=[12A70DA0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fox <pgf@laptop.org>

commit 286e5b97eb22baab9d9a41ca76c6b933a484252c upstream.

Avoids a potential infinite loop.

It was observed once, during an EC hacking/debugging
session - not in regular operation.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Cc: dilinger@queued.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/olpc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 8297160..a23b382 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -117,6 +117,7 @@ int olpc_ec_cmd(unsigned char cmd, unsigned char *inbuf, size_t inlen,
 	unsigned long flags;
 	int ret = -EIO;
 	int i;
+	int restarts = 0;
 
 	spin_lock_irqsave(&ec_lock, flags);
 
@@ -173,7 +174,9 @@ restart:
 			if (wait_on_obf(0x6c, 1)) {
 				printk(KERN_ERR "olpc-ec:  timeout waiting for"
 						" EC to provide data!\n");
-				goto restart;
+				if (restarts++ < 10)
+					goto restart;
+				goto err;
 			}
 			outbuf[i] = inb(0x68);
 			printk(KERN_DEBUG "olpc-ec:  received 0x%x\n",
-- 
1.7.3.3

