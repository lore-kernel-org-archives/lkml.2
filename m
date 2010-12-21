Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622Ab0LUE6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:58:40 -0500
Received: from kroah.org ([198.145.64.141]:59855 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933547Ab0LUE6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:58:39 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ken Mills <ken.k.mills@intel.com>, Alan Cox <alan@linux.intel.com>,
        stable@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] n_gsm: Fix message length handling when building header
Date: Mon, 20 Dec 2010 20:58:36 -0800
Message-Id: <1292907517-12275-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101221044205.GB11750@kroah.com>
References: <20101221044205.GB11750@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Mills <ken.k.mills@intel.com>

Fix message length handling when building header

When the message length is greater than 127, the length field in the header
is built incorrectly. According to the spec, when the length is less than 128
the length field is a single byte formatted as: bbbbbbb1. When it is greater
than 127 then the field is two bytes of the format: bbbbbbb0 bbbbbbbb.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/n_gsm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 81b4658..2fc5cf2 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -716,8 +716,8 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 		if (msg->len < 128)
 			*--dp = (msg->len << 1) | EA;
 		else {
-			*--dp = ((msg->len & 127) << 1) | EA;
-			*--dp = (msg->len >> 6) & 0xfe;
+			*--dp = (msg->len >> 7);	/* bits 7 - 15 */
+			*--dp = (msg->len & 127) << 1;	/* bits 0 - 6 */
 		}
 	}
 
-- 
1.7.3.2

