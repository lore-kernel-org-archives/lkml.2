Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab0FQAlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:41:10 -0400
Received: from [159.226.40.154] ([159.226.40.154]:39547 "EHLO mail.loongson.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0FQAlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:41:06 -0400
From: qiaochong <qiaochong@loongson.cn>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jsimmons@infradead.org,
       qiaochong@loongson.cn
Subject: [PATCH 1/2] fix vc->vc_origin on take_over_console.
Date: Thu, 17 Jun 2010 08:41:24 +0800
Message-Id: <1276735285-7045-2-git-send-email-qiaochong@loongson.cn>
X-Mailer: git-send-email 1.7.0.3.254.g4503b.dirty
In-Reply-To: <1276735285-7045-1-git-send-email-qiaochong@loongson.cn>
References: <1276735285-7045-1-git-send-email-qiaochong@loongson.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel will die on some platform when switch from vga mode to framebuffer mode.
The reason of this bug is that bind_con_driver reset vc->vc_origin to (unsigned long)vc->vc_screenbuf.
On vgacon vc->vc_origin is not releated to  vc->vc_screenbuf,if set
vc->vc_origin to vc->vc_screenbuf,kernel will die on vc_do_resize.

static int vc_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
        struct vc_data *vc, unsigned int cols, unsigned int lines)
{
    unsigned long old_origin, new_origin, new_scr_end, rlth, rrem, err = 0;
    unsigned int old_cols, old_rows, old_row_size, old_screen_size;
    unsigned int new_cols, new_rows, new_row_size, new_screen_size;
    unsigned int end, user;
...
        end = (old_rows > new_rows) ? old_origin +
            (old_row_size * new_rows) :
            vc->vc_scr_end;

...
/*
here for a test from vgacon to framebuffer:
old_origin=0x810814a0,end=0xb00b8fa0,vc->vc_origin=0x810814a0
the code bellow will copy memory from 0x810814a0 to 0xb00b8fa0,
this will cover kernel code,kernel died here.
*/

    while (old_origin < end) {

        scr_memcpyw((unsigned short *) new_origin,
                (unsigned short *) old_origin, rlth);
        if (rrem)
            scr_memsetw((void *)(new_origin + rlth),
                    vc->vc_video_erase_char, rrem);
        old_origin += old_row_size;
        new_origin += new_row_size;
    }

...
}

Signed-off-by: qiaochong <qiaochong@loongson.cn>
---
 drivers/char/vt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 50faa1f..29a5bdc 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -3063,7 +3063,8 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
 
 		old_was_color = vc->vc_can_do_color;
 		vc->vc_sw->con_deinit(vc);
-		vc->vc_origin = (unsigned long)vc->vc_screenbuf;
+		if (!vc->vc_origin)
+			vc->vc_origin = (unsigned long)vc->vc_screenbuf;
 		visual_init(vc, i, 0);
 		set_origin(vc);
 		update_attr(vc);
-- 
1.5.6.5

