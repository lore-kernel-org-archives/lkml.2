Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab0LLXws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:52:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36841 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0LLXsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:32 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: andrew.hendry@gmail.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [204/223] memory corruption in X.25 facilities parsing
Message-Id: <20101212234831.0B240B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: andrew hendry <andrew.hendry@gmail.com>

commit a6331d6f9a4298173b413cf99a40cc86a9d92c37 upstream.

Signed-of-by: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/x25/x25_facilities.c |    8 ++++----
 net/x25/x25_in.c         |    2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

Index: linux/net/x25/x25_facilities.c
===================================================================
--- linux.orig/net/x25/x25_facilities.c
+++ linux/net/x25/x25_facilities.c
@@ -134,15 +134,15 @@ int x25_parse_facilities(struct sk_buff
 		case X25_FAC_CLASS_D:
 			switch (*p) {
 			case X25_FAC_CALLING_AE:
-				if (p[1] > X25_MAX_DTE_FACIL_LEN)
-					break;
+				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
+					return 0;
 				dte_facs->calling_len = p[2];
 				memcpy(dte_facs->calling_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLING_AE;
 				break;
 			case X25_FAC_CALLED_AE:
-				if (p[1] > X25_MAX_DTE_FACIL_LEN)
-					break;
+				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
+					return 0;
 				dte_facs->called_len = p[2];
 				memcpy(dte_facs->called_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLED_AE;
Index: linux/net/x25/x25_in.c
===================================================================
--- linux.orig/net/x25/x25_in.c
+++ linux/net/x25/x25_in.c
@@ -119,6 +119,8 @@ static int x25_state1_machine(struct soc
 						&x25->vc_facil_mask);
 			if (len > 0)
 				skb_pull(skb, len);
+			else
+				return -1;
 			/*
 			 *	Copy any Call User Data.
 			 */
