Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0GDEM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 00:12:26 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:55738 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257Ab0GDEMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 00:12:25 -0400
Subject: Re: [PATCH] VIDEO: ivtvfb, remove unneeded NULL test
From: Andy Walls <awalls@md.metrocast.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Tejun Heo <tj@kernel.org>, Ian Armstrong <ian@iarmst.demon.co.uk>,
       ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <1277206910-27228-1-git-send-email-jslaby@suse.cz>
References: <1277206910-27228-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Jul 2010 00:11:47 -0400
Message-ID: <1278216707.2644.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166
 definitions=2010-07-02_03:2010-02-06,2010-07-02,2010-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1007030141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 13:41 +0200, Jiri Slaby wrote:
> Stanse found that in ivtvfb_callback_cleanup there is an unneeded test
> for itv being NULL. But itv is initialized as container_of with
> non-zero offset, so it is never NULL (even if v4l2_dev is). This was
> found because itv is dereferenced earlier than the test.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Ian Armstrong <ian@iarmst.demon.co.uk>
> Cc: ivtv-devel@ivtvdriver.org
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/video/ivtv/ivtvfb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb.c
> index 9ff3425..5dc460e 100644
> --- a/drivers/media/video/ivtv/ivtvfb.c
> +++ b/drivers/media/video/ivtv/ivtvfb.c
> @@ -1219,7 +1219,7 @@ static int ivtvfb_callback_cleanup(struct device *dev, void *p)
>  	struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
>  	struct osd_info *oi = itv->osd_info;
>  
> -	if (itv && (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
> +	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
>  		if (unregister_framebuffer(&itv->osd_info->ivtvfb_info)) {
>  			IVTVFB_WARN("Framebuffer %d is in use, cannot unload\n",
>  				       itv->instance);

Jiri,

You missed an identical instance of the useless test 10 lines prior in
ivtvfb_callback_init(). :)

How about the patch below, instead?

Regards,
Andy

[PATCH] VIDEO: ivtvfb, fix NULL check

Jiri Slaby reported that stanse found ivtvfb_callback_cleanup has an
unneeded test for itv being NULL. itv was initialized as container_of
with non-zero offset, so it was never NULL (even if v4l2_dev was).

This fix now checks for v4l2_dev being NULL, and not itv.

Thanks to Jiri Slaby for reporting this problem and providing an initial
patch.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ian Armstrong <ian@iarmst.demon.co.uk>
Cc: ivtv-devel@ivtvdriver.org
Cc: linux-media@vger.kernel.org


 drivers/media/video/ivtv/ivtvfb.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb
index 9ff3425..2b3259c 100644
--- a/drivers/media/video/ivtv/ivtvfb.c
+++ b/drivers/media/video/ivtv/ivtvfb.c
@@ -1201,9 +1201,14 @@ static int ivtvfb_init_card(struct ivtv *itv)
 static int __init ivtvfb_callback_init(struct device *dev, void *p)
 {
        struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
-       struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
+       struct ivtv *itv;
 
-       if (itv && (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
+       if (v4l2_dev == NULL)
+               return 0;
+
+       itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
+
+       if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
                if (ivtvfb_init_card(itv) == 0) {
                        IVTVFB_INFO("Framebuffer registered on %s\n",
                                        itv->v4l2_dev.name);
@@ -1216,10 +1221,16 @@ static int __init ivtvfb_callback_init(struct device *de
 static int ivtvfb_callback_cleanup(struct device *dev, void *p)
 {
        struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
-       struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
-       struct osd_info *oi = itv->osd_info;
+       struct ivtv *itv;
+       struct osd_info *oi;
+
+       if (v4l2_dev == NULL)
+               return 0;
+
+       itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
+       oi = itv->osd_info;
 
-       if (itv && (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
+       if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
                if (unregister_framebuffer(&itv->osd_info->ivtvfb_info)) {
                        IVTVFB_WARN("Framebuffer %d is in use, cannot unload\n",
                                       itv->instance);


