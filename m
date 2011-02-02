Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1BBAxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:53:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:18592 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab1BBAow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418281"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: ken.k.mills@intel.com, alan@linux.intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [104/139] n_gsm: Fix message length handling when building header
Message-Id: <20110202004502.937553E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ken Mills <ken.k.mills@intel.com>

commit be7a7411d63ccad165d66fe8e0b11b2ee336159b upstream.

Fix message length handling when building header

When the message length is greater than 127, the length field in the header
is built incorrectly. According to the spec, when the length is less than 128
the length field is a single byte formatted as: bbbbbbb1. When it is greater
than 127 then the field is two bytes of the format: bbbbbbb0 bbbbbbbb.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/n_gsm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/char/n_gsm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/char/n_gsm.c
+++ linux-2.6.35.y/drivers/char/n_gsm.c
@@ -717,8 +717,8 @@ static void __gsm_data_queue(struct gsm_
 		if (msg->len < 128)
 			*--dp = (msg->len << 1) | EA;
 		else {
-			*--dp = (msg->len >> 6) | EA;
-			*--dp = (msg->len & 127) << 1;
+			*--dp = (msg->len >> 7);	/* bits 7 - 15 */
+			*--dp = (msg->len & 127) << 1;	/* bits 0 - 6 */
 		}
 	}
 
