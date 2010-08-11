Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab0HKXuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:50:06 -0400
Received: from kroah.org ([198.145.64.141]:57552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758481Ab0HKXuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:50:03 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:46:25 2010
Message-Id: <20100811234625.809935586@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:45:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kay Sievers <kay.sievers@vrfy.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [10/11] bdi: register sysfs bdi device only once per queue
In-Reply-To: <20100811234809.GA676@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kay Sievers <kay.sievers@vrfy.org>

commit f1d0b063d993527754f062c589b73f125024d216 upstream.

Devices which share the same queue, like floppies and mtd devices, get
registered multiple times in the bdi interface, but bdi accounts only the
last registered device of the devices sharing one queue.

On remove, all earlier registered devices leak, stay around in sysfs, and
cause "duplicate filename" errors if the devices are re-created.

This prevents the creation of multiple bdi interfaces per queue, and the
bdi device will carry the dev_t name of the block device which is the
first one registered, of the pool of devices using the same queue.

[akpm@linux-foundation.org: add a WARN_ON so we know which drivers are misbehaving]
Tested-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/backing-dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -176,6 +176,9 @@ int bdi_register(struct backing_dev_info
 	int ret = 0;
 	struct device *dev;
 
+	if (WARN_ON(bdi->dev))
+		goto exit;
+
 	va_start(args, fmt);
 	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
 	va_end(args);


