Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab2BIPs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:48:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab2BIPs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:48:26 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Reduce the number of expensive division instructions done by
 _parse_integer()
To: adobriyan@gmail.com
Cc: torvalds@linux-foundation.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 09 Feb 2012 15:48:20 +0000
Message-ID: <20120209154819.32070.93358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_parse_integer() does one or two division instructions (which are slow) per
digit parsed to perform the overflow check.

Furthermore, these are particularly expensive examples of division instruction
as the number of clock cycles required to complete them may go up with the
position of the most significant set bit in the dividend:

	if (*res > div_u64(ULLONG_MAX - val, base))

which is as maximal as possible.

Worse, on 32-bit arches, more than one of these division instructions may be
required per digit.

So, assuming we don't support a base of more than 16, skip the check if the
top nibble of the result is not set at this point.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 lib/kstrtox.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index 7a94c8f..f80c896 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -64,7 +64,7 @@ unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long
 
 		if (val >= base)
 			break;
-		if (*res > div_u64(ULLONG_MAX - val, base))
+		if (unlikely(*res >> 60) && *res > div_u64(ULLONG_MAX - val, base))
 			overflow = 1;
 		*res = *res * base + val;
 		rv++;

