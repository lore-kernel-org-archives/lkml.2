Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab1DMOzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:55:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab1DMOzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:55:35 -0400
From: =?UTF-8?q?Petr=20P=C3=ADsa=C5=99?= <ppisar@redhat.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        =?UTF-8?q?Petr=20P=C3=ADsa=C5=99?= <ppisar@redhat.com>
Subject: [PATCH] Clean console safely
Date: Wed, 13 Apr 2011 16:54:33 +0200
Message-Id: <1302706473-16519-1-git-send-email-ppisar@redhat.com>
In-Reply-To: <1302705651.2768.21.camel@localhost>
References: <1302705651.2768.21.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Traditional \E[2J sequence erases console display but scroll-back
buffer and underlying device (frame) buffer keep data that can be
accessed by scrolling console back.

This patch introduce new \E[J parameter 3 that allows to scramble
scroll-back buffer explicitly. Session locking programs (screen,
vlock) can use it to prevent attacker to browse locked console
history.

Signed-off-by: Petr Písař <ppisar@redhat.com>
---
 drivers/tty/vt/vt.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 4bea1ef..fe96a1f 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1197,6 +1197,12 @@ static void csi_J(struct vc_data *vc, int vpar)
 					      vc->vc_x + 1);
 			}
 			break;
+		case 3: /* erase scroll-back buffer (and whole display) */
+			scr_memsetw(vc->vc_screenbuf, vc->vc_video_erase_char,
+				    vc->vc_screenbuf_size >> 1);
+			set_origin(vc);
+			if (CON_IS_VISIBLE(vc))
+				update_screen(vc);
 		case 2: /* erase whole display */
 			count = vc->vc_cols * vc->vc_rows;
 			start = (unsigned short *)vc->vc_origin;
-- 
1.7.4.4

