Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2EXMO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 08:14:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33363 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293Ab2EXMOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 08:14:55 -0400
Date: Thu, 24 May 2012 13:14:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120524121451.GL5361@opensource.wolfsonmicro.com>
References: <201205221053.21792.marc@cpdesign.com.au>
 <201205241908.38278.marc@cpdesign.com.au>
 <20120524103749.GJ5361@opensource.wolfsonmicro.com>
 <201205242122.29648.marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205242122.29648.marc@cpdesign.com.au>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 09:22:29PM +1000, Marc Reilly wrote:

> > > 	map->reg_shift = config->pad_bits % 8;
> > > 	map->format.buf_size = (config->reg_bits
> > > 	
> > >                           + config->val_bits
> > > 					         
> > > 					         + map->reg_shift) / 8;

> > Yes, that's been missed in the addition of padding.  We should also be
> > using DIV_ROUND_UP() which we aren't at the minute.  

> That would break, in _regmap_read_raw():

> 	ret = map->bus->read(map->bus_context, map->work_buf,
> 			     map->format.reg_bytes + map->format.pad_bytes,
> 			     val, val_len);

> If pad_bytes was 1 here, then the register size would end up being 2 bytes.

The above is about buf_size...  pad_bytes isn't in the quoted text which
is the issue.

> The way I understood the pad_bytes field was it was the number of _complete_ 
> padding bytes (ie, full 8 bits) between the register address and value. Any 
> remainder of padding bits is incorporated into the register and shifted by 
> shift bits.

Yes.

> > We could also do
> > reg_bytes + pad_bytes + val_bytes which should cover everything I think?

> If we want to cover everything, we could do reg_bytes + pad_bytes + val_bytes 
> + 3 ... :) (I'm not seriously suggesting that).

Yes, but the above should be the total that goes onto the wire.
