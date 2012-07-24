Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2GXPGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:06:19 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:35994 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911Ab2GXPGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:06:18 -0400
X-IronPort-AV: E=Sophos;i="4.77,646,1336341600"; 
   d="scan'208";a="167987674"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drivers/staging/media/easycap/easycap_main.c: add missing usb_free_urb
Date: Tue, 24 Jul 2012 17:06:09 +0200
Message-Id: <1343142370-27876-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add missing usb_free_urb on failure path after usb_alloc_urb.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@km exists@
local idexpression e;
expression e1,e2,e3;
type T,T1;
identifier f;
@@

* e = usb_alloc_urb(...)
... when any
    when != e = e1
    when != e1 = (T)e
    when != e1(...,(T)e,...)
    when != &e->f
if(...) { ... when != e2(...,(T1)e,...)
                 when != e3 = e
                 when forall
(
             return <+...e...+>;
|
*             return ...;
) }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/media/easycap/easycap_main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index a1c45e4..8269c77 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -3083,6 +3083,7 @@ static int create_video_urbs(struct easycap *peasycap)
 		peasycap->allocation_video_urb += 1;
 		pdata_urb = kzalloc(sizeof(struct data_urb), GFP_KERNEL);
 		if (!pdata_urb) {
+			usb_free_urb(purb);
 			SAM("ERROR: Could not allocate struct data_urb.\n");
 			return -ENOMEM;
 		}

