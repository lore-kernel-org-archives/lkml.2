Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2GPHr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:47:28 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34211 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2GPHrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:47:25 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.44.123]
In-Reply-To: <CAK=WgbaTrjSPqEKKt+bt0uD1x+yNXxRZfJUGZjjMnWGV0aAV3Q@mail.gmail.com>
References: <1341936444-3094-1-git-send-email-fuga@studiofuga.com>
 <CAK=Wgbaf0On3teqOw1myqkS4Dei3Vw2Zn=0xfOv-YiNUjFr0fg@mail.gmail.com>
 <485F7F7C-2D0C-4B14-8A46-D42C9F8ED4E4@studiofuga.com> <CAK=WgbZFHzHLxQfoWW4Cz_PpBCzER75KCd=C3WS-7w_LryKuQA@mail.gmail.com>
 <47AF0F55-39D1-4B7E-BE0E-D2395989322D@studiofuga.com> <CAK=WgbaTrjSPqEKKt+bt0uD1x+yNXxRZfJUGZjjMnWGV0aAV3Q@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 16 Jul 2012 10:47:03 +0300
Message-ID: <CAK=Wgbbah8JvyJz0rJJTPFtu-UY-OfOxsEwh9B-74F7YdXTs3A@mail.gmail.com>
Subject: Re: [PATCH] rpmsg bus subsys_initcall initialization ordering
To: Federico Fuga <fuga@studiofuga.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Federico,

On Fri, Jul 13, 2012 at 9:00 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> I agree. I'll take it, but will change the commit log to make it
> omaprpc-agnostic.

Here's what I'm going to apply:

commit 913552b8c7a0f06cc1bff27f8e9953bffe6a1817
Author: Federico Fuga <fuga@studiofuga.com>
Date:   Mon Jul 16 10:36:51 2012 +0300

    rpmsg: fix dependency on initialization order

    When rpmsg drivers are built into the kernel, they must not initialize
    before the rpmsg bus does, otherwise they'd trigger a BUG() in
    drivers/base/driver.c line 169 (driver_register()).

    To fix that, and to stop depending on arbitrary linkage ordering of
    those built-in rpmsg driver, we let the rpmsg bus initialize at
    subsys_initcall.

    Signed-off-by: Federico Fuga <fuga@studiofuga.com>
    [ohad: rewrite the commit log]
    Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 0af7fd3..e564a01 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -1104,7 +1104,7 @@ static int __init rpmsg_init(void)

        return ret;
 }
-module_init(rpmsg_init);
+subsys_initcall(rpmsg_init);

 static void __exit rpmsg_fini(void)
 {
