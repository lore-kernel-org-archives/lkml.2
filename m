Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0DIWMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:12:30 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:43967 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751655Ab0DIWMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:12:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WJl8PeRTW85GqjfpgvHlWJ33EXiK5R4p+pIy80xh1pA1bS+2qioVusKkiFZSIcVePL33mB+X3dZ4DG1PJ7kxspVPryXr5AwjNGDpewb1mZz1XqPlxTfPmldKeTBomlb1;
Date: Fri, 9 Apr 2010 15:12:27 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, James Simmons <jsimmons@infradead.org>
Subject: [PATCH] vt: try harder to print output when panicing
Message-ID: <20100409151227.43fa7d43@virtuousgeek.org>
In-Reply-To: <20100409151050.74ef6dcd@virtuousgeek.org>
References: <20100409151050.74ef6dcd@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At panic time (i.e. when oops_in_progress is set) we should try a bit
harder to update the screen and make sure output gets to the VT, since
some drivers are capable of flipping back to it.

So make sure we try to unblank and update the display if called from a
panic context.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/char/vt.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index bd1d116..29ec1c9 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -698,7 +698,10 @@ void redraw_screen(struct vc_data *vc, int is_switch)
 			update_attr(vc);
 			clear_buffer_attributes(vc);
 		}
-		if (update && vc->vc_mode != KD_GRAPHICS)
+
+		/* Forcibly update if we're panicing */
+		if ((update && vc->vc_mode != KD_GRAPHICS) ||
+		    oops_in_progress)
 			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
 	}
 	set_cursor(vc);
@@ -2498,7 +2501,7 @@ static void vt_console_print(struct console *co, const char *b, unsigned count)
 		goto quit;
 	}
 
-	if (vc->vc_mode != KD_TEXT)
+	if (vc->vc_mode != KD_TEXT && !oops_in_progress)
 		goto quit;
 
 	/* undraw cursor first */
@@ -3703,7 +3706,8 @@ void do_unblank_screen(int leaving_gfx)
 		return;
 	}
 	vc = vc_cons[fg_console].d;
-	if (vc->vc_mode != KD_TEXT)
+	/* Try to unblank in oops case too */
+	if (vc->vc_mode != KD_TEXT && !oops_in_progress)
 		return; /* but leave console_blanked != 0 */
 
 	if (blankinterval) {
@@ -3712,7 +3716,7 @@ void do_unblank_screen(int leaving_gfx)
 	}
 
 	console_blanked = 0;
-	if (vc->vc_sw->con_blank(vc, 0, leaving_gfx))
+	if (vc->vc_sw->con_blank(vc, 0, leaving_gfx) || oops_in_progress)
 		/* Low-level driver cannot restore -> do it ourselves */
 		update_screen(vc);
 	if (console_blank_hook)
-- 
1.6.6.1

