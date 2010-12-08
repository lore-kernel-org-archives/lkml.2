Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0LHAv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:51:58 -0500
Received: from kroah.org ([198.145.64.141]:58677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab0LHAsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:12 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:35 2010
Message-Id: <20101208004435.416065395@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [111/127] x25: Prevent crashing when parsing bad X.25 facilities
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 5ef41308f94dcbb3b7afc56cdef1c2ba53fa5d2f upstream.

Now with improved comma support.

On parsing malformed X.25 facilities, decrementing the remaining length
may cause it to underflow.  Since the length is an unsigned integer,
this will result in the loop continuing until the kernel crashes.

This patch adds checks to ensure decrementing the remaining length does
not cause it to wrap around.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/x25/x25_facilities.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/x25/x25_facilities.c
+++ b/net/x25/x25_facilities.c
@@ -61,6 +61,8 @@ int x25_parse_facilities(struct sk_buff
 	while (len > 0) {
 		switch (*p & X25_FAC_CLASS_MASK) {
 		case X25_FAC_CLASS_A:
+			if (len < 2)
+				return 0;
 			switch (*p) {
 			case X25_FAC_REVERSE:
 				if((p[1] & 0x81) == 0x81) {
@@ -104,6 +106,8 @@ int x25_parse_facilities(struct sk_buff
 			len -= 2;
 			break;
 		case X25_FAC_CLASS_B:
+			if (len < 3)
+				return 0;
 			switch (*p) {
 			case X25_FAC_PACKET_SIZE:
 				facilities->pacsize_in  = p[1];
@@ -125,6 +129,8 @@ int x25_parse_facilities(struct sk_buff
 			len -= 3;
 			break;
 		case X25_FAC_CLASS_C:
+			if (len < 4)
+				return 0;
 			printk(KERN_DEBUG "X.25: unknown facility %02X, "
 			       "values %02X, %02X, %02X\n",
 			       p[0], p[1], p[2], p[3]);
@@ -132,6 +138,8 @@ int x25_parse_facilities(struct sk_buff
 			len -= 4;
 			break;
 		case X25_FAC_CLASS_D:
+			if (len < p[1] + 2)
+				return 0;
 			switch (*p) {
 			case X25_FAC_CALLING_AE:
 				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
@@ -149,9 +157,7 @@ int x25_parse_facilities(struct sk_buff
 				break;
 			default:
 				printk(KERN_DEBUG "X.25: unknown facility %02X,"
-					"length %d, values %02X, %02X, "
-					"%02X, %02X\n",
-					p[0], p[1], p[2], p[3], p[4], p[5]);
+					"length %d\n", p[0], p[1]);
 				break;
 			}
 			len -= p[1] + 2;


