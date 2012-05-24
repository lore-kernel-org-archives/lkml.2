Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2EXLZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 07:25:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44828 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2EXLZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 07:25:38 -0400
From: Marc Reilly <marc@cpdesign.com.au>
Reply-To: marc@cpdesign.com.au
Organization: Creative Product Design
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Date: Thu, 24 May 2012 21:22:29 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: Shawn Guo <shawn.guo@freescale.com>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201205221053.21792.marc@cpdesign.com.au> <201205241908.38278.marc@cpdesign.com.au> <20120524103749.GJ5361@opensource.wolfsonmicro.com>
In-Reply-To: <20120524103749.GJ5361@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205242122.29648.marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, May 24, 2012 08:37:49 PM Mark Brown wrote:
> On Thu, May 24, 2012 at 07:08:37PM +1000, Marc Reilly wrote:
> > I'm wondering about regmap_init where the buf_size is set up. I think it
> > will
> > 
> > only end up being 3 bytes. I think line 249 should be something like:
> > 	map->format.buf_size = (config->reg_bits
> > 	
> >                           + config->val_bits
> > 					         
> > 					         + (config->pad_bits % 8)) / 8;
> > 
> > or perhaps better:
> > 	map->reg_shift = config->pad_bits % 8;
> > 	map->format.buf_size = (config->reg_bits
> > 	
> >                           + config->val_bits
> > 					         
> > 					         + map->reg_shift) / 8;
> 
> Yes, that's been missed in the addition of padding.  We should also be
> using DIV_ROUND_UP() which we aren't at the minute.  

That would break, in _regmap_read_raw():

	ret = map->bus->read(map->bus_context, map->work_buf,
			     map->format.reg_bytes + map->format.pad_bytes,
			     val, val_len);

If pad_bytes was 1 here, then the register size would end up being 2 bytes.

The way I understood the pad_bytes field was it was the number of _complete_ 
padding bytes (ie, full 8 bits) between the register address and value. Any 
remainder of padding bits is incorporated into the register and shifted by 
shift bits.

> We could also do
> reg_bytes + pad_bytes + val_bytes which should cover everything I think?

If we want to cover everything, we could do reg_bytes + pad_bytes + val_bytes 
+ 3 ... :) (I'm not seriously suggesting that).

Cheers,
Marc
