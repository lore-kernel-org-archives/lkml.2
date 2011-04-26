Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab1DZVjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:39:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:47888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607Ab1DZVNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831564"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: drosenberg@vsecurity.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [14/106] ROSE: prevent heap corruption with bad facilities
Message-Id: <20110426211252.7D8943E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/rose/rose_subr.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/net/rose/rose_subr.c
===================================================================
--- linux-2.6.35.y.orig/net/rose/rose_subr.c
+++ linux-2.6.35.y/net/rose/rose_subr.c
@@ -290,10 +290,15 @@ static int rose_parse_national(unsigned 
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
@@ -333,6 +338,11 @@ static int rose_parse_ccitt(unsigned cha
 
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
@@ -373,12 +383,16 @@ int rose_parse_facilities(unsigned char 
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
