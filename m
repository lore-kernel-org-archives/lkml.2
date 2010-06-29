Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0F2DOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:14:21 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:55856 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648Ab0F2DOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:14:19 -0400
Date: Tue, 29 Jun 2010 08:43:26 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "l.fu@pengutronix.de" <l.fu@pengutronix.de>
Subject: Re: [PATCHv2 1/3] mfd: add STMPE I/O Expander support
Message-ID: <20100629031324.GA6430@bnru02.bnr.st.com>
References: <20100621154514.GA416@pengutronix.de>
 <1277214929-32240-1-git-send-email-rabin.vincent@stericsson.com>
 <20100627235515.GB9264@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100627235515.GB9264@sortiz-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Mon, Jun 28, 2010 at 01:55:16 +0200, Samuel Ortiz wrote:
> On Tue, Jun 22, 2010 at 07:25:27PM +0530, Rabin Vincent wrote:
> > +int stmpe_reg_read(struct stmpe *stmpe, u8 reg)
> > +{
> > +	int ret;
> > +
> > +	ret = i2c_smbus_read_byte_data(stmpe->i2c, reg);
> > +	if (ret < 0)
> > +		dev_err(stmpe->dev, "failed to read reg %#x: %d\n",
> > +			reg, ret);
> > +
> > +	dev_vdbg(stmpe->dev, "rd: reg %#x => data %#x\n", reg, ret);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(stmpe_reg_read);
> I think your locking is broken here.
> If your exporting this routine (and the next ones below), you'd better make
> sure you're under stmpe->lock for the stmpe register concurrent access.

stmpe_reg_read() and stmpe_reg_write() are just a call to one
i2c_smbus_* function, and the I2C core takes a bus_lock internally
preventing concurrent accesses.

The only place where the I2C core locking is not sufficient is the
read/modify/write sequence, and we provide stmpe_set_bits() for that,
which takes a lock.  If someone uses reg_read()/reg_write() sequences on
registers where they should be using set_bits(), adding extra locking in
reg_read()/reg_write() will not provide any additional safeguard.

The same scheme is used by adp5520.

Could you please explain why more locking is needed?

> What I suggest is that you'd have the exported routines taking your stmpe
> lock, and then have an internal version (e.g. named with a __stmpe prefix)
> without lock taken for your core code. In your case, you could probably call
> the i2c I/O routines directly, that's up to you.
> 
> > +/**
> > + * stmpe_set_bits() - set the value of a bitfield in a stmpe register
> > + * @stmpe:	device to write to
> > + * @reg:	register to write
> > + * @mask:	mask of bits to set
> > + * @val:	value to set
> > + */
> > +int stmpe_set_bits(struct stmpe *stmpe, u8 reg, u8 mask, u8 val)
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&stmpe->lock);
> > +
> > +	ret = stmpe_reg_read(stmpe, reg);
> That one for example would be __stmpe_read().
> 
> > +/**
> > + * stmpe_block_write() - write multiple stmpe registers
> > + * @stmpe:	device to write to
> > + * @reg:	first register
> > + * @length:	number of registers
> > + * @values:	values to write
> > + */
> > +int stmpe_block_write(struct stmpe *stmpe, u8 reg, u8 length,
> > +			const u8 *values)
> > +{
> > +	int ret;
> > +
> > +	dev_vdbg(stmpe->dev, "wr: regs %#x (%d)\n", reg, length);
> > +#ifdef VERBOSE_DEBUG
> > +	print_hex_dump_bytes("stmpe wr: ", dump_prefix_offset, values, length);
> > +#endif
> I don't really enjoy this part for 2 reasons:
> - You should use a less generic ifdef switch, prefixed with STMPE_ for
> example.

The dev_vdbg() in the previous line is activated via VERBOSE_DEBUG, so
the idea was to have this dump use the same config.  I'll fix it as your
recommended, though.  Will fix your other comments too.

Rabin
