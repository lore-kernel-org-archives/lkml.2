Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162Ab1ESSJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:09:32 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53679 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934148Ab1ESSJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:26 -0400
X-Sasl-enc: l9PhBqcJKvQpfGhi4ju+OO+lw81Fv+a0uRdDI3CTWlwO 1305828565
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:06:00 2011
Message-Id: <20110519180600.189183372@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [62/71] [media] v4l: Release module if subdev registration fails
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit b7534f002d3c81d18abfbf57179d07d3ec763bb5 upstream.

If v4l2_device_register_subdev() fails, the reference to the subdev
module taken by the function isn't released. Fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/v4l2-device.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -131,14 +131,17 @@ int v4l2_device_register_subdev(struct v
 	sd->v4l2_dev = v4l2_dev;
 	if (sd->internal_ops && sd->internal_ops->registered) {
 		err = sd->internal_ops->registered(sd);
-		if (err)
+		if (err) {
+			module_put(sd->owner);
 			return err;
+		}
 	}
 	/* This just returns 0 if either of the two args is NULL */
 	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler);
 	if (err) {
 		if (sd->internal_ops && sd->internal_ops->unregistered)
 			sd->internal_ops->unregistered(sd);
+		module_put(sd->owner);
 		return err;
 	}
 	spin_lock(&v4l2_dev->lock);


