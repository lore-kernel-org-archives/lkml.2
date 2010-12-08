Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab0LHAxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:53:06 -0500
Received: from kroah.org ([198.145.64.141]:58637 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403Ab0LHAsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:06 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:34 2010
Message-Id: <20101208004434.816700080@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        maximilian attems <max@stro.at>
Subject: [105/127] V4L/DVB (13154): uvcvideo: Handle garbage at the end of streaming interface descriptors
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit c4ed8c66d79d707d89fe732ff5b97739edf1ba62 upstream.

At least one 5986:0241 webcam model includes vendor-specific descriptors
at the end of its streaming interface descriptors. Print an information
UVC_TRACE_DESCR message and try to continue parsing the descriptors
rather than bailing out with an error.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_driver.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -436,7 +436,8 @@ static int uvc_parse_format(struct uvc_d
 	/* Parse the frame descriptors. Only uncompressed, MJPEG and frame
 	 * based formats have frame descriptors.
 	 */
-	while (buflen > 2 && buffer[2] == ftype) {
+	while (buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
+	       buffer[2] == ftype) {
 		frame = &format->frame[format->nframes];
 		if (ftype != UVC_VS_FRAME_FRAME_BASED)
 			n = buflen > 25 ? buffer[25] : 0;
@@ -513,12 +514,14 @@ static int uvc_parse_format(struct uvc_d
 		buffer += buffer[0];
 	}
 
-	if (buflen > 2 && buffer[2] == UVC_VS_STILL_IMAGE_FRAME) {
+	if (buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
+	    buffer[2] == UVC_VS_STILL_IMAGE_FRAME) {
 		buflen -= buffer[0];
 		buffer += buffer[0];
 	}
 
-	if (buflen > 2 && buffer[2] == UVC_VS_COLORFORMAT) {
+	if (buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
+	    buffer[2] == UVC_VS_COLORFORMAT) {
 		if (buflen < 6) {
 			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
 			       "interface %d COLORFORMAT error\n",
@@ -759,6 +762,11 @@ static int uvc_parse_streaming(struct uv
 		buffer += buffer[0];
 	}
 
+	if (buflen)
+		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming interface "
+			"%d has %u bytes of trailing descriptor garbage.\n",
+			dev->udev->devnum, alts->desc.bInterfaceNumber, buflen);
+
 	/* Parse the alternate settings to find the maximum bandwidth. */
 	for (i = 0; i < intf->num_altsetting; ++i) {
 		struct usb_host_endpoint *ep;


