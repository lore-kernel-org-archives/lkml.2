Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1AFAim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:38:42 -0500
Received: from kroah.org ([198.145.64.141]:36020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab1AFAbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:23 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:08 2011
Message-Id: <20110106002308.241538197@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Marco Stornelli <marco.stornelli@gmail.com>
Subject: [122/152] RAMOOPS: Dont overflow over non-allocated regions
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/char/ramoops.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
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


