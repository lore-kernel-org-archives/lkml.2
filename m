Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab2EXNJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 09:09:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43304 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2EXNJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 09:09:17 -0400
From: Marc Reilly <marc@cpdesign.com.au>
Reply-To: marc@cpdesign.com.au
Organization: Creative Product Design
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Date: Thu, 24 May 2012 23:06:08 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: Shawn Guo <shawn.guo@freescale.com>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201205221053.21792.marc@cpdesign.com.au> <201205242122.29648.marc@cpdesign.com.au> <20120524121451.GL5361@opensource.wolfsonmicro.com>
In-Reply-To: <20120524121451.GL5361@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205242306.09053.marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


> > > Yes, that's been missed in the addition of padding.  We should also be
> > > using DIV_ROUND_UP() which we aren't at the minute.
> > 
> > That would break, in _regmap_read_raw():
> > 	ret = map->bus->read(map->bus_context, map->work_buf,
> > 	
> > 			     map->format.reg_bytes + map->format.pad_bytes,
> > 			     val, val_len);
> > 
> > If pad_bytes was 1 here, then the register size would end up being 2
> > bytes.
> 
> The above is about buf_size...  pad_bytes isn't in the quoted text which
> is the issue.

I misunderstood where you intended to put the DIV_ROUND_UP, sorry.

Something like this:

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -246,7 +246,9 @@ struct regmap *regmap_init(struct device *dev,
 		map->lock = regmap_lock_mutex;
 		map->unlock = regmap_unlock_mutex;
 	}
-	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
+	map->format.buf_size = DIV_ROUND_UP(config->reg_bits +
+					    config->val_bits +
+					    config->pad_bits % 8, 8);
 	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
 	map->format.pad_bytes = config->pad_bits / 8;
 	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
-- 

Hope that fixes things.

Cheers,
Marc
