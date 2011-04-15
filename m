Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1DOIJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 04:09:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab1DOIJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 04:09:10 -0400
From: =?UTF-8?q?Petr=20P=C3=ADsa=C5=99?= <ppisar@redhat.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>, "Chris Ball" <cjb@laptop.org>,
        "Daniel Taylor" <Daniel.Taylor@wdc.com>,
        =?UTF-8?q?Petr=20P=C3=ADsa=C5=99?= <ppisar@redhat.com>
Subject: [PATCH] Clean console safely
Date: Fri, 15 Apr 2011 10:08:08 +0200
Message-Id: <1302854888-3606-1-git-send-email-ppisar@redhat.com>
In-Reply-To: <25B374CC0D9DFB4698BB331F82CD0CF2E3EC04@wdscexbe08.sc.wdc.com>
References: <25B374CC0D9DFB4698BB331F82CD0CF2E3EC04@wdscexbe08.sc.wdc.com>
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
 drivers/tty/vt/vt.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 4bea1ef..cb661ca 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1197,6 +1197,13 @@ static void csi_J(struct vc_data *vc, int vpar)
 					      vc->vc_x + 1);
 			}
 			break;
+		case 3: /* erase scroll-back buffer (and whole display) */
+			scr_memsetw(vc->vc_screenbuf, vc->vc_video_erase_char,
+				    vc->vc_screenbuf_size >> 1);
+			set_origin(vc);
+			if (CON_IS_VISIBLE(vc))
+				update_screen(vc);
+			/* fall through */
 		case 2: /* erase whole display */
 			count = vc->vc_cols * vc->vc_rows;
 			start = (unsigned short *)vc->vc_origin;
-- 
1.7.4.4

