Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab1FPHbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:31:12 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58084 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755880Ab1FPHBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:37 -0400
X-Sasl-enc: d2GORuR/dF/AxEz2haf2KidsvON6u9dymk1YZBgw3NPk 1308207696
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:36 2011
Message-Id: <20110616000236.356167697@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [75/89] drm/radeon/kms: do bounds checking for 3D_LOAD_VBPNTR and
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 bump array limit

From: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>

commit a27bb4b209dd6c327fa4e7185f2487f9508a58db upstream.

To my knowledge, the limit is 16 on r300.
(the docs don't say what the limit is)

The lack of bounds checking can be abused to do all sorts of things
(from bypassing parts of the CS checker to crashing the kernel).

Bugzilla:
https://bugs.freedesktop.org/show_bug.cgi?id=36745

Signed-off-by: Marek Olšák <maraeo@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r100_track.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/r100_track.h
+++ b/drivers/gpu/drm/radeon/r100_track.h
@@ -63,7 +63,7 @@ struct r100_cs_track {
 	unsigned			num_arrays;
 	unsigned			max_indx;
 	unsigned			color_channel_mask;
-	struct r100_cs_track_array	arrays[11];
+	struct r100_cs_track_array	arrays[16];
 	struct r100_cs_track_cb 	cb[R300_MAX_CB];
 	struct r100_cs_track_cb 	zb;
 	struct r100_cs_track_cb 	aa;
@@ -146,6 +146,12 @@ static inline int r100_packet3_load_vbpn
 	ib = p->ib->ptr;
 	track = (struct r100_cs_track *)p->track;
 	c = radeon_get_ib_value(p, idx++) & 0x1F;
+	if (c > 16) {
+	    DRM_ERROR("Only 16 vertex buffers are allowed %d\n",
+		      pkt->opcode);
+	    r100_cs_dump_packet(p, pkt);
+	    return -EINVAL;
+	}
 	track->num_arrays = c;
 	for (i = 0; i < (c - 1); i+=2, idx+=3) {
 		r = r100_cs_packet_next_reloc(p, &reloc);


