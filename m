Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031236Ab2HGWxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:53:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031207Ab2HGWqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:46:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: =?UTF-8?q?=5B=2020/49=5D=20drm/radeon=3A=20Try=20harder=20to=20avoid=20HW=20cursor=20ending=20on=20a=20multiple=20of=20128=20columns=2E?=
Date: Tue,  7 Aug 2012 15:44:38 -0700
Message-Id: <20120807222028.698155941@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <michel.daenzer@amd.com>

commit f60ec4c7df043df81e62891ac45383d012afe0da upstream.

This could previously fail if either of the enabled displays was using a
horizontal resolution that is a multiple of 128, and only the leftmost column
of the cursor was (supposed to be) visible at the right edge of that display.

The solution is to move the cursor one pixel to the left in that case.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=33183

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_cursor.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_cursor.c
+++ b/drivers/gpu/drm/radeon/radeon_cursor.c
@@ -257,8 +257,14 @@ int radeon_crtc_cursor_move(struct drm_c
 				if (!(cursor_end & 0x7f))
 					w--;
 			}
-			if (w <= 0)
+			if (w <= 0) {
 				w = 1;
+				cursor_end = x - xorigin + w;
+				if (!(cursor_end & 0x7f)) {
+					x--;
+					WARN_ON_ONCE(x < 0);
+				}
+			}
 		}
 	}
 


