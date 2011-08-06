Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab1HFALp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:11:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab1HFALk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:11:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:11 2011
Message-Id: <20110806000411.841655997@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans Verkuil <hans.verkuil@cisco.com>, Mike Isely <isely@pobox.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [03/50] [media] pvrusb2: fix g/s_tuner support
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 50e9efd60b213ce43ad6979bfc18e25eec2d8413 upstream.

The tuner-core subdev requires that the type field of v4l2_tuner is
filled in correctly. This is done in v4l2-ioctl.c, but pvrusb2 doesn't
use that yet, so we have to do it manually based on whether the current
input is radio or not.

Tested with my pvrusb2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -3015,6 +3015,8 @@ static void pvr2_subdev_update(struct pv
 	if (hdw->input_dirty || hdw->audiomode_dirty || hdw->force_dirty) {
 		struct v4l2_tuner vt;
 		memset(&vt, 0, sizeof(vt));
+		vt.type = (hdw->input_val == PVR2_CVAL_INPUT_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		vt.audmode = hdw->audiomode_val;
 		v4l2_device_call_all(&hdw->v4l2_dev, 0, tuner, s_tuner, &vt);
 	}
@@ -5101,6 +5103,8 @@ void pvr2_hdw_status_poll(struct pvr2_hd
 {
 	struct v4l2_tuner *vtp = &hdw->tuner_signal_info;
 	memset(vtp, 0, sizeof(*vtp));
+	vtp->type = (hdw->input_val == PVR2_CVAL_INPUT_RADIO) ?
+		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	hdw->tuner_signal_stale = 0;
 	/* Note: There apparently is no replacement for VIDIOC_CROPCAP
 	   using v4l2-subdev - therefore we can't support that AT ALL right


