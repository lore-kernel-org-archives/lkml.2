Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0JBNy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 09:54:58 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:52926 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab0JBNy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 09:54:56 -0400
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drivers/media/dvb/ttpci/av7110_av.c: Add missing error handling code
Date: Sat,  2 Oct 2010 15:59:15 +0200
Message-Id: <1286027958-7333-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the error handling code with operations found in other nearby error
handling code.

A simplified version of the sematic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
@r@
statement S1,S2,S3;
constant C1,C2,C3;
@@

*if (...)
 {... S1 return -C1;}
...
*if (...)
 {... when != S1
    return -C2;}
...
*if (...)
 {... S1 return -C3;}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This is only a suggestion.  All of the other ways out of this function call
wake_up(&buf->queue);.  But I don't understand the code well enough to know
why, or whether there is a reason not to do it in this case.

 drivers/media/dvb/ttpci/av7110_av.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb/ttpci/av7110_av.c b/drivers/media/dvb/ttpci/av7110_av.c
index 6ef3996..3ce5ccf 100644
--- a/drivers/media/dvb/ttpci/av7110_av.c
+++ b/drivers/media/dvb/ttpci/av7110_av.c
@@ -245,8 +245,11 @@ int av7110_pes_play(void *dest, struct dvb_ringbuffer *buf, int dlen)
 		return -1;
 	}
 	while (1) {
-		if ((len = dvb_ringbuffer_avail(buf)) < 6)
+		len = dvb_ringbuffer_avail(buf);
+		if (len < 6) {
+			wake_up(&buf->queue);
 			return -1;
+		}
 		sync =  DVB_RINGBUFFER_PEEK(buf, 0) << 24;
 		sync |= DVB_RINGBUFFER_PEEK(buf, 1) << 16;
 		sync |= DVB_RINGBUFFER_PEEK(buf, 2) << 8;

