Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab2IPJnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 05:43:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab2IPJnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 05:43:00 -0400
Date: Sun, 16 Sep 2012 12:44:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>,
        Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH repost] virtio: don't crash when device is buggy
Message-ID: <20120916094427.GA24075@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120903143018.GA5353@redhat.com>
 <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
 <20120903202737.GD6181@redhat.com>
 <CAJK669ZvnnG6fGOog-Z47B7xqyn9hcx5dAD7S--+2PSgE+hrLA@mail.gmail.com>
 <20120904135022.GI9805@redhat.com>
 <CAJK669Z1UYakBWartChfoeKL_eU5=GFZMGhH8R_Q-difVm0ygQ@mail.gmail.com>
 <20120904185541.GB3602@redhat.com>
 <87k3w7j49i.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3w7j49i.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Because of a sanity check in virtio_dev_remove, a buggy device can crash
kernel.  And in case of rproc it's userspace so it's not a good idea.
We are unloading a driver so how bad can it be?
Be less aggressive in handling this error: if it's a driver bug,
warning once should be enough.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

--

3.6 material?

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index c3b3f7f..1e8659c 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -159,7 +159,7 @@ static int virtio_dev_remove(struct device *_d)
 	drv->remove(dev);
 
 	/* Driver should have reset device. */
-	BUG_ON(dev->config->get_status(dev));
+	WARN_ON_ONCE(dev->config->get_status(dev));
 
 	/* Acknowledge the device's existence again. */
 	add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);

-- 
MST
