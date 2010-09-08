Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0IHTk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:40:28 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55330 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab0IHTkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=au+WifgHT5r7sdx/M4Ke6Me0r16lu3BGFKvLePhhnFgp2/NalEMxSn5EhukVLgkK7k
         oeyg2O8sZB7fxjpmY1USu1ERwKNYKUVJiXhNiU3XpAq8coQOcShAuv//9/DZWBpjmerr
         aUXJ6sVrtf15+e88pzsH8qJsoqYWuYUhsWKNk=
Date: Wed, 8 Sep 2010 21:39:56 +0200
From: Dan Carpenter <error27@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] mtd: sanity check input
Message-ID: <20100908193956.GB3463@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
	Ben Hutchings <bhutchings@solarflare.com>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If "ur_idx" is wrong we could go past the end of the array.  The
"ur_idx" comes from root so it's not a huge deal, but adding a sanity
check makes the code more robust.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index a825002..9c00549 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -513,6 +513,9 @@ static int mtd_ioctl(struct file *file, u_int cmd, u_long arg)
 		if (get_user(ur_idx, &(ur->regionindex)))
 			return -EFAULT;
 
+		if (ur_idx >= mtd->numeraseregions)
+			return -EINVAL;
+
 		kr = &(mtd->eraseregions[ur_idx]);
 
 		if (put_user(kr->offset, &(ur->offset))
