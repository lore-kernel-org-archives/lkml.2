Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab0JHHDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:03:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62600 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0JHHDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:03:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=dmHUNonOuFbd16lYOf3YSHvhz/HpYT9LbHO3bSTfir0S+NQyQB6D9JOhgwvZznc5g0
         bvpU6dmnzBp9UiZZMoGt1RG+/wXSChp9CgLbv9aZoVK3g8xJmh+lAHk2CgPJKnbZwEih
         B171ZXBNp/KEz7n9k17Q17if1pErHaGePmsUc=
Date: Fri, 8 Oct 2010 09:03:07 +0200
From: Dan Carpenter <error27@gmail.com>
To: Achim Leubner <achim_leubner@adaptec.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] gdth: integer overflow in ioctl
Message-ID: <20101008070307.GF11681@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Achim Leubner <achim_leubner@adaptec.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gdth_ioctl_alloc() takes the size variable as an int.
copy_from_user() takes the size variable as an unsigned long.
gen.data_len and gen.sense_len are unsigned longs.
On x86_64 longs are 64 bit and ints are 32 bit.

We could pass in a very large number and the allocation would truncate
the size to 32 bits and allocate a small buffer.  Then when we do the
copy_from_user(), it would result in a memory corruption.

CC: stable@kernel.org
Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index b860d65..4cf7ffa 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4175,6 +4175,14 @@ static int ioc_general(void __user *arg, char *cmnd)
     ha = gdth_find_ha(gen.ionode);
     if (!ha)
         return -EFAULT;
+
+    if (gen.data_len > INT_MAX)
+        return -EINVAL;
+    if (gen.sense_len > INT_MAX)
+        return -EINVAL;
+    if (gen.data_len + gen.sense_len > INT_MAX)
+        return -EINVAL;
+
     if (gen.data_len + gen.sense_len != 0) {
         if (!(buf = gdth_ioctl_alloc(ha, gen.data_len + gen.sense_len,
                                      FALSE, &paddr)))
