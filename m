Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab0GAWBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:01:49 -0400
Received: from kroah.org ([198.145.64.141]:33771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875Ab0GAVND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:03 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:48 2010
Message-Id: <20100701174248.458460809@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [024/200] ALSA: pcm: fix delta calculation at boundary wraparound
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit b406e6103baa3da85950f22d3d46d21a8da654c5 upstream.

In the cleanup of the hw_ptr update functions in 2.6.33, the calculation
of the delta value was changed to use the modulo operator to protect
against a negative difference due to the pointer wrapping around at the
boundary.

However, the ptr variables are unsigned, so a negative difference would
result in the two complement's value which has no relation to the actual
difference relative to the boundary; the result is typically some value
near LONG_MAX-boundary.  Furthermore, even if the modulo operation would
be done with signed types, the result of a negative dividend could be
negative.

The invalid delta value is then caught by the following checks, but this
means that the pointer update is ignored.

To fix this, use a range check as in the other pointer calculations.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/pcm_lib.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -345,7 +345,9 @@ static int snd_pcm_update_hw_ptr0(struct
 		new_hw_ptr = hw_base + pos;
 	}
       __delta:
-	delta = (new_hw_ptr - old_hw_ptr) % runtime->boundary;
+	delta = new_hw_ptr - old_hw_ptr;
+	if (delta < 0)
+		delta += runtime->boundary;
 	if (xrun_debug(substream, in_interrupt ?
 			XRUN_DEBUG_PERIODUPDATE : XRUN_DEBUG_HWPTRUPDATE)) {
 		char name[16];


