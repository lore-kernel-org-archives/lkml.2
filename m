Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0J0Jha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:37:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34591 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab0J0Jh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=taIy3usCZ4MAilvapv5K0fniyFVWN2sSsFGlHUCNaVOhbgnL1tfYqo+8pdGtjc8ye1
         BiqDneL4eYZb8dSCLFwgD6b07qrPuzTVPE9MJk53p2sE+w07UR4PLw2g9qGdl54parEp
         I0zi9NUSxbbvFfgIt/QSNHFOtFEBzESnjHhmI=
Date: Wed, 27 Oct 2010 11:37:16 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [RFC] [patch] fbcmap: integer overflow bug
Message-ID: <20101027093716.GD6062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an integer overflow bug in the FBIOPUTCMAP ioctl if
cmap->len * 2 overflows.

It's harmless, except that it messes up the cmap until someone types
`reset`.  It could have been caught by checking the return from
fb_copy_cmap().

Or it could have been caught by limiting the size of the cmaps to one
page.  The cmaps are allocated with GFP_ATOMIC and it makes sense to
limit them.

Different drivers use different sizes of cmaps.  There are about 150
drivers.  I've checked a bunch (50) of them and the larges cmap.len I've
found is gxt4500 which maxes out at 1024 so PAGE_SIZE is about twice that
length.  For some of the 50 I wasn't sure on the limit.

Is PAGE_SIZE a reasonable limit?  Does anyone know or do I have to audit
all 150 drivers?

diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
index f53b9f1..6dc5817 100644
--- a/drivers/video/fbcmap.c
+++ b/drivers/video/fbcmap.c
@@ -110,7 +110,9 @@ int fb_alloc_cmap(struct fb_cmap *cmap, int len, int transp)
     }
     cmap->start = 0;
     cmap->len = len;
-    fb_copy_cmap(fb_default_cmap(len), cmap);
+    if (fb_copy_cmap(fb_default_cmap(len), cmap))
+	goto fail;
+
     return 0;
 
 fail:
@@ -250,6 +252,9 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 	int rc, size = cmap->len * sizeof(u16);
 	struct fb_cmap umap;
 
+	if (cmap->len > PAGE_SIZE || cmap->len * sizeof(u16) > PAGE_SIZE)
+		return -EINVAL;
+
 	memset(&umap, 0, sizeof(struct fb_cmap));
 	rc = fb_alloc_cmap(&umap, cmap->len, cmap->transp != NULL);
 	if (rc)
