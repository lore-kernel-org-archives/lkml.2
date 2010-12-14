Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab0LNAko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:40:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54480 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab0LNAkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:40:42 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=-ZvRZYIYPmgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=meVymXHHAAAA:8 a=HE3f-QE9bJ1rzL6B5SoA:9 a=Ii7i9yHk4dDRN9hEFlwRcgnY-qkA:4 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101214004040.275907600@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 19:38:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] fs: Remove unlikely() from fput_light()
References: <20101214003807.693481687@goodmis.org>
Content-Disposition: inline; filename=0001-fs-Remove-unlikely-from-fput_light.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In fput_light(), there's an unlikely(fput_needed), which running on
my normal desktop doing firefox, xchat, evolution and part of my distcc farm,
and running the annotate branch profiler shows that the unlikely is not
very unlikely.

 correct incorrect  %        Function             File              Line
 ------- ---------  -        --------             ----              ----
       0       48 100 fput_light                file.h               26
115828710 897415279  88 fput_light              file.h               26
865271179 5286128445  85 fput_light             file.h               26
19568539  8923664  31 fput_light                file.h               26
12353677  3562279  22 fput_light                file.h               26
  267691    67062  20 fput_light                file.h               26
15014853   348172   2 fput_light                file.h               26
  209258      205   0 fput_light                file.h               26
 1364164        0   0 fput_light                file.h               26

Which gives 1032903812 times it was correct and 6203351846 times it was
incorrect, or 85% incorrect.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/file.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/file.h b/include/linux/file.h
index b1e1297..e85baeb 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -23,7 +23,7 @@ extern struct file *alloc_file(struct path *, fmode_t mode,
 
 static inline void fput_light(struct file *file, int fput_needed)
 {
-	if (unlikely(fput_needed))
+	if (fput_needed)
 		fput(file);
 }
 
-- 
1.7.2.3


