Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab0LHBEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:04:20 -0500
Received: from kroah.org ([198.145.64.141]:33928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932926Ab0LHBEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:04:13 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:49 2010
Message-Id: <20101208005749.542321940@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [281/289] [media] msp3400: fix mute audio regression
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

commit 0310871d8f71da4ad8643687fbc40f219a0dac4d upstream.

The switch to the new control framework caused a regression where the audio was
no longer unmuted after the carrier scan finished.

The original code attempted to set the volume control to its current value in
order to have the set-volume control code to be called that handles the volume
and muting. However, the framework will not call that code unless the new volume
value is different from the old.

Instead we now call msp_s_ctrl directly.

It is a bit of a hack: we really need a v4l2_ctrl_refresh_ctrl function for this
(or something along those lines).

Thanks to Andy Walls for bisecting this and to Shane Shrybman for reporting it!

Reported-by: Shane Shrybman <shrybman@teksavvy.com>
Thanks-to: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/msp3400-driver.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/media/video/msp3400-driver.c
+++ b/drivers/media/video/msp3400-driver.c
@@ -382,7 +382,12 @@ static int msp_s_ctrl(struct v4l2_ctrl *
 
 void msp_update_volume(struct msp_state *state)
 {
-	v4l2_ctrl_s_ctrl(state->volume, v4l2_ctrl_g_ctrl(state->volume));
+	/* Force an update of the volume/mute cluster */
+	v4l2_ctrl_lock(state->volume);
+	state->volume->val = state->volume->cur.val;
+	state->muted->val = state->muted->cur.val;
+	msp_s_ctrl(state->volume);
+	v4l2_ctrl_unlock(state->volume);
 }
 
 /* --- v4l2 ioctls --- */


