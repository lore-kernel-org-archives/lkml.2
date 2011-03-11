Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1CKAe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:34:26 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:35358 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754408Ab1CKAeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:34:25 -0500
Subject: Re: BUG at mm/mmap.c:2309 when cx18.ko and cx18-alsa.ko loaded
From: Andy Walls <awalls@md.metrocast.net>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        David Miller <davem@davemloft.net>, linux-media@vger.kernel.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>
In-Reply-To: <1299445446.2310.157.camel@localhost>
References: <1299204400.2812.35.camel@localhost>
	 <1299362366.2570.27.camel@localhost> <1299377017.2341.50.camel@localhost>
	 <AANLkTimU9qV11p+wTDz4SCvaoYyxpja8tmJ5D7-ki==B@mail.gmail.com>
	 <1299445446.2310.157.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 19:34:38 -0500
Message-ID: <1299803678.13462.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-10_11:2011-03-10,2011-03-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1103100191
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-06 at 16:04 -0500, Andy Walls wrote:
> On Sun, 2011-03-06 at 10:37 -0800, Hugh Dickins wrote:

> > I do expect the underlying problem to be somewhere down the driver
> > end, given that nobody else has been reporting these issues.  I'm
> > hoping that once the cx18 guys have time to try to reproduce it,
> > they'll be better able to track it down.

Hi Hugh,

You were correct.  The mistake was in the cx18 driver, in the last thing
that I touched, of course.  The code causing the bug isn't anywhere
aside from my private repo.

All,

Sorry for all the noise.

The bug was so idiotic, I fell compelled to show the fix:

diff --git a/drivers/media/video/cx18/cx18-scb.c b/drivers/media/video/cx18/cx18
index fd89ad0..d17ffc8 100644
--- a/drivers/media/video/cx18/cx18-scb.c
+++ b/drivers/media/video/cx18/cx18-scb.c
@@ -28,8 +28,8 @@
 
 int cx18_scb_init_mdl_ent_mgmt(struct cx18 *cx)
 {
-       cx->scb_mdl_ent_map = kzalloc(BITS_TO_LONGS(SCB_MDL_ENTRIES),
-                                     GFP_KERNEL);
+       cx->scb_mdl_ent_map = kzalloc(BITS_TO_LONGS(SCB_MDL_ENTRIES)
+                                               * sizeof(long), GFP_KERNEL);
        if (cx->scb_mdl_ent_map == NULL) {
                CX18_ERR("Fatal: unable to allocate bitmap for managing SCB MDL"
                         "entries\n");

So now the subsequent call to

	bitmap_zero(cx->scb_mdl_ent_map, SCB_MDL_ENTRIES);

doesn't walk off the end of what was allocated.

Apparently BITS_TO_LONGS() is not BITS_TO_LONGS_TO_BYTES().

Regards,
Andy

