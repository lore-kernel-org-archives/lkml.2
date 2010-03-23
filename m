Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0CWGWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 02:22:55 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:52960 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0CWGWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 02:22:53 -0400
Date: Tue, 23 Mar 2010 07:22:47 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark McClelland <mmcclell@bigfoot.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video: avoid NULL dereference
In-Reply-To: <20100322231441.b7e33bf9.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.1003230722290.8768@ask.diku.dk>
References: <Pine.LNX.4.64.1003212230380.12371@ask.diku.dk>
 <20100322231441.b7e33bf9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

It seems impossible for ov to be NULL at this point.

The semantic match that finds the problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E, E1;
identifier f;
statement S1,S3;
iterator iter;
@@

if ((E == NULL && ...) || ...)
{
  ... when != false ((E == NULL && ...) || ...)
      when != true  ((E != NULL && ...) || ...)
      when != iter(E,...) S1
      when != E = E1
(
  sizeof(E->f)
|
* E->f
)
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/ov511.c         |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index e0bce8d..dd1b1ac 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -5916,11 +5916,6 @@ ov51x_disconnect(struct usb_interface *intf)
 	mutex_lock(&ov->lock);
 	usb_set_intfdata (intf, NULL);
 
-	if (!ov) {
-		mutex_unlock(&ov->lock);
-		return;
-	}
-
 	/* Free device number */
 	ov511_devused &= ~(1 << ov->nr);
 
