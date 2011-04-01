Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab1DAOYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:24:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35646 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab1DAOX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:23:58 -0400
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Carpenter <error27@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] drivers/staging/intel_sst/intel_sst_app_interface.c: introduce missing kfree
Date: Fri,  1 Apr 2011 16:23:45 +0200
Message-Id: <1301667827-20056-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stream_bufs is initialized at the beginning of the function, and then the
#ifdef code declares a new variable with the same name and initializes
that.  If the if in the ifdef is taken, the then branch returns, implying
that the first stream_bufs is never used and is leaked.  The first
initialization is thus moved down after the ifdef.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/intel_sst/intel_sst_app_interface.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index a367991..401961a 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -418,10 +418,6 @@ static int snd_sst_fill_kernel_list(struct stream_info *stream,
 	static int sent_offset;
 	static unsigned long sent_index;
 
-	stream_bufs = kzalloc(sizeof(*stream_bufs), GFP_KERNEL);
-	if (!stream_bufs)
-		return -ENOMEM;
-	stream_bufs->addr = sst_drv_ctx->mmap_mem;
 #ifdef CONFIG_MRST_RAR_HANDLER
 	if (stream->ops == STREAM_OPS_PLAYBACK_DRM) {
 		for (index = stream->sg_index; index < nr_segs; index++) {
@@ -448,6 +444,10 @@ static int snd_sst_fill_kernel_list(struct stream_info *stream,
 		return retval;
 	}
 #endif
+	stream_bufs = kzalloc(sizeof(*stream_bufs), GFP_KERNEL);
+	if (!stream_bufs)
+		return -ENOMEM;
+	stream_bufs->addr = sst_drv_ctx->mmap_mem;
 	mmap_len = sst_drv_ctx->mmap_len;
 	stream_bufs->addr = sst_drv_ctx->mmap_mem;
 	bufp = stream->cur_ptr;

