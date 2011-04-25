Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1DYUZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:03 -0400
Received: from 1wt.eu ([62.212.114.60]:34375 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab1DYUYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:55 -0400
Message-Id: <20110425200238.512234577@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 127/173] ROSE: prevent heap corruption with bad facilities
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit be20250c13f88375345ad99950190685eda51eb8 upstream.

When parsing the FAC_NATIONAL_DIGIS facilities field, it's possible for
a remote host to provide more digipeaters than expected, resulting in
heap corruption.  Check against ROSE_MAX_DIGIS to prevent overflows, and
abort facilities parsing on failure.

Additionally, when parsing the FAC_CCITT_DEST_NSAP and
FAC_CCITT_SRC_NSAP facilities fields, a remote host can provide a length
of less than 10, resulting in an underflow in a memcpy size, causing a
kernel panic due to massive heap corruption.  A length of greater than
20 results in a stack overflow of the callsign array.  Abort facilities
parsing on these invalid length values.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/rose/rose_subr.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/net/rose/rose_subr.c
+++ b/net/rose/rose_subr.c
@@ -289,10 +289,15 @@ static int rose_parse_national(unsigned
 				facilities->source_ndigis = 0;
 				facilities->dest_ndigis   = 0;
 				for (pt = p + 2, lg = 0 ; lg < l ; pt += AX25_ADDR_LEN, lg += AX25_ADDR_LEN) {
-					if (pt[6] & AX25_HBIT)
+					if (pt[6] & AX25_HBIT) {
+						if (facilities->dest_ndigis >= ROSE_MAX_DIGIS)
+							return -1;
 						memcpy(&facilities->dest_digis[facilities->dest_ndigis++], pt, AX25_ADDR_LEN);
-					else
+					} else {
+						if (facilities->source_ndigis >= ROSE_MAX_DIGIS)
+							return -1;
 						memcpy(&facilities->source_digis[facilities->source_ndigis++], pt, AX25_ADDR_LEN);
+					}
 				}
 			}
 			p   += l + 2;
@@ -332,6 +337,11 @@ static int rose_parse_ccitt(unsigned cha
 
 		case 0xC0:
 			l = p[1];
+
+			/* Prevent overflows*/
+			if (l < 10 || l > 20)
+				return -1;
+
 			if (*p == FAC_CCITT_DEST_NSAP) {
 				memcpy(&facilities->source_addr, p + 7, ROSE_ADDR_LEN);
 				memcpy(callsign, p + 12,   l - 10);
@@ -372,12 +382,16 @@ int rose_parse_facilities(unsigned char
 			switch (*p) {
 			case FAC_NATIONAL:		/* National */
 				len = rose_parse_national(p + 1, facilities, facilities_len - 1);
+				if (len < 0)
+					return 0;
 				facilities_len -= len + 1;
 				p += len + 1;
 				break;
 
 			case FAC_CCITT:		/* CCITT */
 				len = rose_parse_ccitt(p + 1, facilities, facilities_len - 1);
+				if (len < 0)
+					return 0;
 				facilities_len -= len + 1;
 				p += len + 1;
 				break;


