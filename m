Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab2KUG41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 01:56:27 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:41006 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab2KUG40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 01:56:26 -0500
Date: Tue, 20 Nov 2012 23:56:24 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lib/vsprintf.c: Fix handling of %zd when using ssize_t
Message-ID: <20121121065624.GB19837@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/printk-formats.txt says to use %zd for a ssize_t argument
and some drivers do. Unfortunately this prints a positive number for
negative values eg:

tpm_tis 70030000.tpm_tis: tpm_transmit: tpm_send: error 4294967234

Add a case to va_args a ssize_t type if the interpretation should be
signed.

Tested on PPC32.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 lib/vsprintf.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 39c99fe..41da074 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1485,7 +1485,10 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 				num = va_arg(args, long);
 				break;
 			case FORMAT_TYPE_SIZE_T:
-				num = va_arg(args, size_t);
+				if (spec.flags & SIGN)
+					num = va_arg(args, ssize_t);
+				else
+					num = va_arg(args, size_t);
 				break;
 			case FORMAT_TYPE_PTRDIFF:
 				num = va_arg(args, ptrdiff_t);
-- 
1.7.4.1

