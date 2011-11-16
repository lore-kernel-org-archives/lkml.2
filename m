Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab1KPRhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:37:21 -0500
Received: from imr3.ericy.com ([198.24.6.13]:38175 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab1KPRhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:37:19 -0500
Subject: Re: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: York Sun <yorksun@freescale.com>
CC: Tabi Timur-B04825 <B04825@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "B29983@freescale.com" <B29983@freescale.com>
In-Reply-To: <1321464509.7847.41.camel@oslab-l1>
References: <1321338462-6138-1-git-send-email-guenter.roeck@ericsson.com>
	 <CAOZdJXUPO5PyMkAw-2EPvy_qSUuqsgUA7Gr8mKUX7HyShoXk3g@mail.gmail.com>
	 <E6AF40B3BFC8A9428EACB47497F0F4B62DC687@039-SN1MPN1-002.039d.mgd.msft.net>
	 <ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>
	 <1321464509.7847.41.camel@oslab-l1>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Wed, 16 Nov 2011 09:36:08 -0800
Message-ID: <1321464968.2309.384.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 12:28 -0500, York Sun wrote:
> I am not sure if this mail will reach the list as I am not subscribed.
> 
> In the v2 patch (actually both version), you wrote
> 
> > +		byte = readb(i2c->base + MPC_I2C_DR);
> > +
> > +		/* Adjust length if first received byte is length */
> > +		if (i == 0 && recv_len) {
> > +			if (byte == 0 || byte > I2C_SMBUS_BLOCK_MAX)
> > +				return -EPROTO;
> > +			length += byte;
> > +			/*
> > +			 * For block reads, generate txack here if data length
> > +			 * is 1 byte (total length is 2 bytes).
> > +			 */
> > +			if (length == 2)
> > +				writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA
> > +					 | CCR_TXAK);
> > +		}
> > +		data[i] = byte;
> 
> I am wondering if the first byte should be left out for data[] if the
> recv_len is non-zero. If I understand correctly, this patch is to
> support of SMBus with multiple byte read. The SMBus is different from
> I2C bus on multiple byte. The first data is byte count vs slave data for
> I2C. So you will receive all data preceded by the byte count, which is
> one more than your loop.
> 
York,

The calling code expects the data length in data[0], and the actual data
in data[1] .. data[<byte_count>]. The initial value for length is 1; the
byte count is added to it, so <byte count + 1> bytes are placed into the
buffer.

Thanks,
Guenter

> York
> 
> 
> 
> On Wed, 2011-11-16 at 08:56 -0600, Timur Tabi wrote:
> > 
> > On Nov 16, 2011, at 12:01 AM, sun york-R58495 <R58495@freescale.com> wrote:
> > 
> > > Timur,
> > > 
> > > Which silicon has the i2c-mpc? Without the user's manual, I can only guess from the code. It looks like the code is going to deal with a block transaction with the first byte is the length. If that's true, there might be a problem with 
> > > 
> > > data[i]=byte
> > > 
> > > if the block is true. Since the first byte is the length, it shouldn't be the data at the same time, right?
> > 
> > Can you check thr mailing list thread?  It should explain everything.
> > 
> > 
> > > 
> > > York
> > > 
> > > ________________________________________
> > > From: Tabi Timur-B04825
> > > Sent: Tuesday, November 15, 2011 11:04 AM
> > > To: sun york-R58495
> > > Subject: Fwd: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
> > > 
> > > York,
> > > 
> > > If you have a moment, can you take a look at this patch?  I don't know
> > > enough about I2C to really understand it.
> > > 
> > > ---------- Forwarded message ----------
> > > From: Guenter Roeck <guenter.roeck@ericsson.com>
> > > Date: Tue, Nov 15, 2011 at 12:27 AM
> > > Subject: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
> > > To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
> > > Cc: Grant Likely <grant.likely@secretlab.ca>,
> > > linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, Guenter Roeck
> > > <guenter.roeck@ericsson.com>, Tang Yuantian <B29983@freescale.com>
> > > 
> > > 
> > > Add support for SMBUS_READ_BLOCK_DATA to the i2c-mpc bus driver.
> > > Required to support the PMBus zl6100 driver with i2c-mpc.
> > > 
> > > Reported-by: Tang Yuantian <B29983@freescale.com>
> > > Cc: Tang Yuantian <B29983@freescale.com>
> > > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > > ---
> > > drivers/i2c/busses/i2c-mpc.c |   33 +++++++++++++++++++++++++--------
> > > 1 files changed, 25 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
> > > index 107397a..77aade7 100644
> > > --- a/drivers/i2c/busses/i2c-mpc.c
> > > +++ b/drivers/i2c/busses/i2c-mpc.c
> > > @@ -454,7 +454,7 @@ static int mpc_write(struct mpc_i2c *i2c, int target,
> > > }
> > > 
> > > static int mpc_read(struct mpc_i2c *i2c, int target,
> > > -                   u8 *data, int length, int restart)
> > > +                   u8 *data, int length, int restart, bool block)
> > > {
> > >       unsigned timeout = i2c->adap.timeout;
> > >       int i, result;
> > > @@ -470,7 +470,7 @@ static int mpc_read(struct mpc_i2c *i2c, int target,
> > >               return result;
> > > 
> > >       if (length) {
> > > -               if (length == 1)
> > > +               if (length == 1 && !block)
> > >                       writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_TXAK);
> > >               else
> > >                       writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA);
> > > @@ -479,17 +479,28 @@ static int mpc_read(struct mpc_i2c *i2c, int target,
> > >       }
> > > 
> > >       for (i = 0; i < length; i++) {
> > > +               u8 byte;
> > > +
> > >               result = i2c_wait(i2c, timeout, 0);
> > >               if (result < 0)
> > >                       return result;
> > > 
> > > +               byte = readb(i2c->base + MPC_I2C_DR);
> > > +               /*
> > > +                * Adjust length if first received byte is length
> > > +                */
> > > +               if (i == 0 && block) {
> > > +                       if (byte == 0 || byte > I2C_SMBUS_BLOCK_MAX)
> > > +                               return -EPROTO;
> > > +                       length += byte;
> > > +               }
> > > +               data[i] = byte;
> > >               /* Generate txack on next to last byte */
> > >               if (i == length - 2)
> > >                       writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_TXAK);
> > >               /* Do not generate stop on last byte */
> > >               if (i == length - 1)
> > >                       writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_MTX);
> > > -               data[i] = readb(i2c->base + MPC_I2C_DR);
> > >       }
> > > 
> > >       return length;
> > > @@ -532,12 +543,17 @@ static int mpc_xfer(struct i2c_adapter *adap,
> > > struct i2c_msg *msgs, int num)
> > >                       "Doing %s %d bytes to 0x%02x - %d of %d messages\n",
> > >                       pmsg->flags & I2C_M_RD ? "read" : "write",
> > >                       pmsg->len, pmsg->addr, i + 1, num);
> > > -               if (pmsg->flags & I2C_M_RD)
> > > -                       ret =
> > > -                           mpc_read(i2c, pmsg->addr, pmsg->buf, pmsg->len, i);
> > > -               else
> > > +               if (pmsg->flags & I2C_M_RD) {
> > > +                       bool block = pmsg->flags & I2C_M_RECV_LEN;
> > > +
> > > +                       ret = mpc_read(i2c, pmsg->addr, pmsg->buf, pmsg->len, i,
> > > +                                      block);
> > > +                       if (block && ret > 0)
> > > +                               pmsg->len = ret;
> > > +               } else {
> > >                       ret =
> > >                           mpc_write(i2c, pmsg->addr, pmsg->buf, pmsg->len, i);
> > > +               }
> > >       }
> > >       mpc_i2c_stop(i2c);
> > >       return (ret < 0) ? ret : num;
> > > @@ -545,7 +561,8 @@ static int mpc_xfer(struct i2c_adapter *adap,
> > > struct i2c_msg *msgs, int num)
> > > 
> > > static u32 mpc_functionality(struct i2c_adapter *adap)
> > > {
> > > -       return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> > > +       return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL
> > > +         | I2C_FUNC_SMBUS_READ_BLOCK_DATA;
> > > }
> > > 
> > > static const struct i2c_algorithm mpc_algo = {
> > > --
> > > 1.7.3.1
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > > 
> > > 
> > > --
> > > Timur Tabi
> > > Linux kernel developer at Freescale
> 
> 
> 


