Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab2APSwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:52:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab2APSuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:50:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:17 2012
Message-Id: <20120116184517.476961050@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [20/48] drm/radeon/kms: workaround invalid AVI infoframe checksum issue
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

commit 92db7f6c860b8190571a9dc1fcbc16d003422fe8 upstream.

This change was verified to fix both issues with no video I've
investigated. I've also checked checksum calculation with fglrx on:
RV620, HD54xx, HD5450, HD6310, HD6320.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600_hdmi.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -196,6 +196,13 @@ static void r600_hdmi_videoinfoframe(
 	frame[0xD] = (right_bar >> 8);
 
 	r600_hdmi_infoframe_checksum(0x82, 0x02, 0x0D, frame);
+	/* Our header values (type, version, length) should be alright, Intel
+	 * is using the same. Checksum function also seems to be OK, it works
+	 * fine for audio infoframe. However calculated value is always lower
+	 * by 2 in comparison to fglrx. It breaks displaying anything in case
+	 * of TVs that strictly check the checksum. Hack it manually here to
+	 * workaround this issue. */
+	frame[0x0] += 2;
 
 	WREG32(offset+R600_HDMI_VIDEOINFOFRAME_0,
 		frame[0x0] | (frame[0x1] << 8) | (frame[0x2] << 16) | (frame[0x3] << 24));


