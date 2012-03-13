Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab2CMBF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:05:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:46710 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab2CMARv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:51 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 026/196] ROSE: prevent heap corruption with bad facilities
Date: Mon, 12 Mar 2012 20:12:34 -0400
Message-Id: <1331597724-31358-27-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/rose/rose_subr.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/rose/rose_subr.c b/net/rose/rose_subr.c
index 1734abb..174d51c 100644
--- a/net/rose/rose_subr.c
+++ b/net/rose/rose_subr.c
@@ -290,10 +290,15 @@ static int rose_parse_national(unsigned char *p, struct rose_facilities_struct *
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
@@ -333,6 +338,11 @@ static int rose_parse_ccitt(unsigned char *p, struct rose_facilities_struct *fac
 
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
@@ -373,12 +383,16 @@ int rose_parse_facilities(unsigned char *p,
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
-- 
1.7.9.3

