Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab0LYJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 04:57:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63328 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab0LYJ5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 04:57:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eJ0bgZjO11zLMXQ386h5p9dU2p75VDo0saRxgV+21/7cec76bejVcpc1mV7aYPxGgb
         NVP7291Ml2+GupAiS/yzXojPzIo/TTCJ4kFsNBjlVwRPC+G58SzQezA6ivMR+phMGbd9
         p6YTMoHV80dx4zrHRilxrMqyaYJmqKGQRFVz4=
Date: Sat, 25 Dec 2010 11:57:09 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <David.Woodhouse@intel.com>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH, Bugfix] RAMOOPS: Don't overflow over non-allocated regions
Message-ID: <20101225095709.GA1345@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Current code mis-calculates the ramoops header size, leading to an
overflow over the next record at best, or over a non-allocated region
at worst. Fix that calculation.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
--

Shouldn't this be added to -stable too?

Happy New Year!

 drivers/char/ramoops.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 73dcb0e..d3d63be 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -29,7 +29,6 @@
 #include <linux/ramoops.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
-#define RAMOOPS_HEADER_SIZE   (5 + sizeof(struct timeval))
 
 #define RECORD_SIZE 4096
 
@@ -65,8 +64,8 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 			struct ramoops_context, dump);
 	unsigned long s1_start, s2_start;
 	unsigned long l1_cpy, l2_cpy;
-	int res;
-	char *buf;
+	int res, hdr_size;
+	char *buf, *buf_orig;
 	struct timeval timestamp;
 
 	/* Only dump oopses if dump_oops is set */
@@ -74,6 +73,8 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 		return;
 
 	buf = (char *)(cxt->virt_addr + (cxt->count * RECORD_SIZE));
+	buf_orig = buf;
+
 	memset(buf, '\0', RECORD_SIZE);
 	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
 	buf += res;
@@ -81,8 +82,9 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 	res = sprintf(buf, "%lu.%lu\n", (long)timestamp.tv_sec, (long)timestamp.tv_usec);
 	buf += res;
 
-	l2_cpy = min(l2, (unsigned long)(RECORD_SIZE - RAMOOPS_HEADER_SIZE));
-	l1_cpy = min(l1, (unsigned long)(RECORD_SIZE - RAMOOPS_HEADER_SIZE) - l2_cpy);
+	hdr_size = buf - buf_orig;
+	l2_cpy = min(l2, (unsigned long)(RECORD_SIZE - hdr_size));
+	l1_cpy = min(l1, (unsigned long)(RECORD_SIZE - hdr_size) - l2_cpy);
 
 	s2_start = l2 - l2_cpy;
 	s1_start = l1 - l1_cpy;

-- 
Darwish
http://darwish.07.googlepages.com
