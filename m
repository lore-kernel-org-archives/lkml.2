Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab1EPFaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 01:30:01 -0400
Received: from spamfilter.jmicron.com ([220.130.51.235]:3497 "EHLO
	jmsspam.jmicron.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906Ab1EPFaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 01:30:00 -0400
X-Greylist: delayed 658 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 May 2011 01:29:59 EDT
X-IronPort-AV: E=Sophos;i="4.64,373,1301846400"; 
   d="scan'208";a="1459927"
Message-Id: <201105160518.p4G5IqrK014870@jmr105.jmicron.com>
From: "Aries Lee" <arieslee@jmicron.com>
To: <linux-kernel@vger.kernel.org>
Cc: <devinchiu@jmicron.com>, "'Aries Lee'" <arieslee@jmicron.com>,
        <oakad@yahoo.com>
Subject: [PATCH 1/1] memstick: fix the bit shift problem for JMicron 38x controllers in ARM platform
Date: Mon, 16 May 2011 13:18:52 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Thread-Index: AcwTiL704fcTvjawSUeB+TdL8bf+pg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If x86 architecture, an unsigned variable shift more than 31 times means a
rotation.
But in some architecture, shift 32 bit or more will give a zero value.
For example, 
An unsigned int variable of 0x11223344 runs the operation "<< 32",
In x86 architecture, its value is still 0x11223344
But its value will change as 0x00000000 in ARM.

This patch try to fix those architecture-specific code, and made it both
work in x86 and the other architecture.

Signed-off-by: Aries Lee <arieslee@jmicron.com>
---
diff --git a/drivers/memstick/host/jmb38x_ms.c
b/drivers/memstick/host/jmb38x_ms.c
index d89d925..272e89c 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -287,8 +287,8 @@ static unsigned int jmb38x_ms_write_reg_data(struct
jmb38x_ms_host *host,
 		return off;
 
 	while (host->io_pos < 8 && length) {
-		host->io_word[1] &= ~(0xff << (host->io_pos * 8));
-		host->io_word[1] |=  buf[off++] << (host->io_pos * 8);
+		host->io_word[1] &= ~(0xff << ((host->io_pos-4) * 8));
+		host->io_word[1] |=  buf[off++] << ((host->io_pos-4) * 8);
 		host->io_pos++;
 		length--;
 	}


