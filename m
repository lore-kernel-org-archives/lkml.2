Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0LLXp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44583 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab0LLXpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:05 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: samuel@sortiz.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [9/223] irda: Fix heap memory corruption in iriap.c
Message-Id: <20101212234504.3DDF3B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Samuel Ortiz <samuel@sortiz.org>

commit 37f9fc452d138dfc4da2ee1ce5ae85094efc3606 upstream.

While parsing the GetValuebyClass command frame, we could potentially write
passed the skb->data pointer.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/irda/iriap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/net/irda/iriap.c
===================================================================
--- linux.orig/net/irda/iriap.c
+++ linux/net/irda/iriap.c
@@ -502,7 +502,8 @@ static void iriap_getvaluebyclass_confir
 		IRDA_DEBUG(4, "%s(), strlen=%d\n", __func__, value_len);
 
 		/* Make sure the string is null-terminated */
-		fp[n+value_len] = 0x00;
+		if (n + value_len < skb->len)
+			fp[n + value_len] = 0x00;
 		IRDA_DEBUG(4, "Got string %s\n", fp+n);
 
 		/* Will truncate to IAS_MAX_STRING bytes */
