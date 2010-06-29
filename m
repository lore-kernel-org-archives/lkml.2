Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0F2Pde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:33:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:35130 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab0F2Pdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,505,1272870000"; 
   d="scan'208";a="634699076"
Date: Tue, 29 Jun 2010 17:33:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "l.fu@pengutronix.de" <l.fu@pengutronix.de>
Subject: Re: [PATCHv2 1/3] mfd: add STMPE I/O Expander support
Message-ID: <20100629153326.GA4752@sortiz-mobl>
References: <20100621154514.GA416@pengutronix.de>
 <1277214929-32240-1-git-send-email-rabin.vincent@stericsson.com>
 <20100627235515.GB9264@sortiz-mobl>
 <20100629031324.GA6430@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629031324.GA6430@bnru02.bnr.st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

On Tue, Jun 29, 2010 at 08:43:26AM +0530, Rabin VINCENT wrote:
> Hi Samuel,
> 
> On Mon, Jun 28, 2010 at 01:55:16 +0200, Samuel Ortiz wrote:
> > On Tue, Jun 22, 2010 at 07:25:27PM +0530, Rabin Vincent wrote:
> > > +int stmpe_reg_read(struct stmpe *stmpe, u8 reg)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = i2c_smbus_read_byte_data(stmpe->i2c, reg);
> > > +	if (ret < 0)
> > > +		dev_err(stmpe->dev, "failed to read reg %#x: %d\n",
> > > +			reg, ret);
> > > +
> > > +	dev_vdbg(stmpe->dev, "rd: reg %#x => data %#x\n", reg, ret);
> > > +
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL(stmpe_reg_read);
> > I think your locking is broken here.
> > If your exporting this routine (and the next ones below), you'd better make
> > sure you're under stmpe->lock for the stmpe register concurrent access.
> 
> stmpe_reg_read() and stmpe_reg_write() are just a call to one
> i2c_smbus_* function, and the I2C core takes a bus_lock internally
> preventing concurrent accesses.
> 
> The only place where the I2C core locking is not sufficient is the
> read/modify/write sequence, and we provide stmpe_set_bits() for that,
> which takes a lock.  If someone uses reg_read()/reg_write() sequences on
> registers where they should be using set_bits(), adding extra locking in
> reg_read()/reg_write() will not provide any additional safeguard.
> 
> The same scheme is used by adp5520.
> 
> Could you please explain why more locking is needed?
Without the extra locking, there's nothing preventing me from writing to a
register while you're in the middle of a stmpe_set_bits() call.

> > > +/**
> > > + * stmpe_block_write() - write multiple stmpe registers
> > > + * @stmpe:	device to write to
> > > + * @reg:	first register
> > > + * @length:	number of registers
> > > + * @values:	values to write
> > > + */
> > > +int stmpe_block_write(struct stmpe *stmpe, u8 reg, u8 length,
> > > +			const u8 *values)
> > > +{
> > > +	int ret;
> > > +
> > > +	dev_vdbg(stmpe->dev, "wr: regs %#x (%d)\n", reg, length);
> > > +#ifdef VERBOSE_DEBUG
> > > +	print_hex_dump_bytes("stmpe wr: ", dump_prefix_offset, values, length);
> > > +#endif
> > I don't really enjoy this part for 2 reasons:
> > - You should use a less generic ifdef switch, prefixed with STMPE_ for
> > example.
> 
> The dev_vdbg() in the previous line is activated via VERBOSE_DEBUG, so
> the idea was to have this dump use the same config.  
Ah, I didnt realize VERBOSE_DEBUG was defined from device.h. Should have
grepped for it in your patch, sorry.
I would still like it to be part of your header file though.

> I'll fix it as your recommended, though.  Will fix your other comments too.
Thanks in advance.

Cheers,
Samuel.


> Rabin

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
