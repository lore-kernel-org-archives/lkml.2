Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0LMPsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:48:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53843 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab0LMPsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:48:52 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] n_gsm: Fix message length handling when building header
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 13 Dec 2010 15:27:27 +0000
Message-ID: <20101213152658.19871.37910.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: \"Mills, Ken K\" <ken.k.mills@intel.com>

Fix message length handling when building header

When the message length is greater than 127, the length field in the header
is built incorrectly. According to the spec, when the length is less than 128
the length field is a single byte formatted as: bbbbbbb1. When it is greater
than 127 then the field is two bytes of the format: bbbbbbb0 bbbbbbbb.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org
---

 drivers/tty/n_gsm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 8c24a63..6652024 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -726,8 +726,8 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 		if (msg->len < 128)
 			*--dp = (msg->len << 1) | EA;
 		else {
-			*--dp = ((msg->len & 127) << 1) | EA;
-			*--dp = (msg->len >> 6) & 0xfe;
+			*--dp = (msg->len >> 7);	/* bits 7 - 15 */
+			*--dp = (msg->len & 127) << 1;	/* bits 0 - 6 */
 		}
 	}
 

