Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2BEHEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 02:04:40 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61503 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab2BEG7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 01:59:03 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/24] Make %pR could handle bus resource with domain
Date: Sat,  4 Feb 2012 22:57:47 -0800
Message-Id: <1328425088-6562-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F2E28AE.0010,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So could use %pR for busn_res with domain nr in start/end

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/vsprintf.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 8e75003..9397998 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -451,6 +451,12 @@ char *resource_string(char *buf, char *end, struct resource *res,
 		.precision = -1,
 		.flags = SPECIAL | SMALL | ZEROPAD,
 	};
+	static const struct printf_spec domain_spec = {
+		.base = 16,
+		.field_width = 4,
+		.precision = -1,
+		.flags = SMALL | ZEROPAD,
+	};
 	static const struct printf_spec bus_spec = {
 		.base = 16,
 		.field_width = 2,
@@ -507,11 +513,26 @@ char *resource_string(char *buf, char *end, struct resource *res,
 		specp = &mem_spec;
 		decode = 0;
 	}
-	p = number(p, pend, res->start, *specp);
-	if (res->start != res->end) {
-		*p++ = '-';
-		p = number(p, pend, res->end, *specp);
+
+	if (res->flags & IORESOURCE_BUS && busn_domain_nr(res->end)) {
+		p = number(p, pend, busn_domain_nr(res->start), domain_spec);
+		*p++ = ':';
+		p = number(p, pend, busn_bus_nr(res->start), *specp);
+		if (res->start != res->end) {
+			*p++ = '-';
+			p = number(p, pend, busn_domain_nr(res->end),
+					 domain_spec);
+			*p++ = ':';
+			p = number(p, pend, busn_bus_nr(res->end), *specp);
+		}
+	} else {
+		p = number(p, pend, res->start, *specp);
+		if (res->start != res->end) {
+			*p++ = '-';
+			p = number(p, pend, res->end, *specp);
+		}
 	}
+
 	if (decode) {
 		if (res->flags & IORESOURCE_MEM_64)
 			p = string(p, pend, " 64bit", str_spec);
-- 
1.7.7

