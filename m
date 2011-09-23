Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1IWPXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:23:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62529 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1IWPXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:23:13 -0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: linux-serial@vger.kernel.org
Cc: gregkh@suse.de, alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tty/n_gsm: fix a bug in gsm_dlci_data_output (adaption = 2 case)
Date: Fri, 23 Sep 2011 19:22:55 +0400
Message-Id: <1316791376-4863-1-git-send-email-mikhail.kshevetskiy@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in adaption=2 case we should put 1 or 2 byte with modem status bits
at the beginning of a buffer pointed by "dp". n_gsm use 1 byte case,
so it allocate a buffer of len + 1 size. As result we should:
  * put 1 byte of modem status bits
  * increase data pointer
  * put "len" bytes of data
but actually we have:
  * increase first byte with the value of modem status bits
  * decrease "len"
  * put orig_len - 1 bytes of data starting from the buffer beggining
This is evidently wrong.

Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
---
 drivers/tty/n_gsm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 8a50e4e..143dc5e 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -834,8 +834,7 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 		break;
 	case 2:	/* Unstructed with modem bits. Always one byte as we never
 		   send inline break data */
-		*dp += gsm_encode_modem(dlci);
-		len--;
+		*dp++ = gsm_encode_modem(dlci);
 		break;
 	}
 	WARN_ON(kfifo_out_locked(dlci->fifo, dp , len, &dlci->lock) != len);
-- 
1.7.5.4

