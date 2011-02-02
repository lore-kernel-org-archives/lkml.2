Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab1BBAue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:50:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:3685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab1BBApF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960919"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: darwish.07@gmail.com, marco.stornelli@gmail.com,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [115/139] RAMOOPS: Don't overflow over non-allocated regions
Message-Id: <20110202004514.245283E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ahmed S. Darwish <darwish.07@gmail.com>

commit 1873bb8115e678ad9fd0aac9dbbc68383bc36e06 upstream.

The current code mis-calculates the ramoops header size, leading to an
overflow over the next record at best, or over a non-allocated region at
worst.  Fix that calculation.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/ramoops.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/drivers/char/ramoops.c
===================================================================
--- linux-2.6.35.y.orig/drivers/char/ramoops.c
+++ linux-2.6.35.y/drivers/char/ramoops.c
@@ -27,7 +27,6 @@
 #include <linux/ioport.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
-#define RAMOOPS_HEADER_SIZE   (5 + sizeof(struct timeval))
 
 #define RECORD_SIZE 4096
 
@@ -63,8 +62,8 @@ static void ramoops_do_dump(struct kmsg_
 			struct ramoops_context, dump);
 	unsigned long s1_start, s2_start;
 	unsigned long l1_cpy, l2_cpy;
-	int res;
-	char *buf;
+	int res, hdr_size;
+	char *buf, *buf_orig;
 	struct timeval timestamp;
 
 	/* Only dump oopses if dump_oops is set */
@@ -72,6 +71,8 @@ static void ramoops_do_dump(struct kmsg_
 		return;
 
 	buf = (char *)(cxt->virt_addr + (cxt->count * RECORD_SIZE));
+	buf_orig = buf;
+
 	memset(buf, '\0', RECORD_SIZE);
 	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
 	buf += res;
@@ -79,8 +80,9 @@ static void ramoops_do_dump(struct kmsg_
 	res = sprintf(buf, "%lu.%lu\n", (long)timestamp.tv_sec, (long)timestamp.tv_usec);
 	buf += res;
 
-	l2_cpy = min(l2, (unsigned long)(RECORD_SIZE - RAMOOPS_HEADER_SIZE));
-	l1_cpy = min(l1, (unsigned long)(RECORD_SIZE - RAMOOPS_HEADER_SIZE) - l2_cpy);
+	hdr_size = buf - buf_orig;
+	l2_cpy = min(l2, (unsigned long)(RECORD_SIZE - hdr_size));
+	l1_cpy = min(l1, (unsigned long)(RECORD_SIZE - hdr_size) - l2_cpy);
 
 	s2_start = l2 - l2_cpy;
 	s1_start = l1 - l1_cpy;
