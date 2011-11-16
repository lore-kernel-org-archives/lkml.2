Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab1KPRzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:55:46 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:43846
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753167Ab1KPRzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:55:44 -0500
X-SpamScore: -16
X-BigFish: VS-16(zz936eK1432N98dK4015Lzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Subject: Re: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
From: York Sun <yorksun@freescale.com>
To: <guenter.roeck@ericsson.com>
CC: Tabi Timur-B04825 <B04825@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "B29983@freescale.com" <B29983@freescale.com>
In-Reply-To: <1321464968.2309.384.camel@groeck-laptop>
References: <1321338462-6138-1-git-send-email-guenter.roeck@ericsson.com>
	 <CAOZdJXUPO5PyMkAw-2EPvy_qSUuqsgUA7Gr8mKUX7HyShoXk3g@mail.gmail.com>
	 <E6AF40B3BFC8A9428EACB47497F0F4B62DC687@039-SN1MPN1-002.039d.mgd.msft.net>
	 <ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>
	 <1321464509.7847.41.camel@oslab-l1>
	 <1321464968.2309.384.camel@groeck-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 09:55:35 -0800
Message-ID: <1321466135.7847.55.camel@oslab-l1>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 09:36 -0800, Guenter Roeck wrote:
> On Wed, 2011-11-16 at 12:28 -0500, York Sun wrote:
> > I am not sure if this mail will reach the list as I am not subscribed.
> > 
> > In the v2 patch (actually both version), you wrote
> > 
> > > +		byte = readb(i2c->base + MPC_I2C_DR);
> > > +
> > > +		/* Adjust length if first received byte is length */
> > > +		if (i == 0 && recv_len) {
> > > +			if (byte == 0 || byte > I2C_SMBUS_BLOCK_MAX)
> > > +				return -EPROTO;
> > > +			length += byte;
> > > +			/*
> > > +			 * For block reads, generate txack here if data length
> > > +			 * is 1 byte (total length is 2 bytes).
> > > +			 */
> > > +			if (length == 2)
> > > +				writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA
> > > +					 | CCR_TXAK);
> > > +		}
> > > +		data[i] = byte;
> > 
> > I am wondering if the first byte should be left out for data[] if the
> > recv_len is non-zero. If I understand correctly, this patch is to
> > support of SMBus with multiple byte read. The SMBus is different from
> > I2C bus on multiple byte. The first data is byte count vs slave data for
> > I2C. So you will receive all data preceded by the byte count, which is
> > one more than your loop.
> > 
> York,
> 
> The calling code expects the data length in data[0], and the actual data
> in data[1] .. data[<byte_count>]. The initial value for length is 1; the
> byte count is added to it, so <byte count + 1> bytes are placed into the
> buffer.
> 
> Thanks,
> Guenter

Thanks for explanation. I am more confused by the length += byte now.
For I2C bus, if you need length of byte, just keep reading until you get
all of them. Of course you need to deal with the ACK. For SMBus, it is
similar but you shouldn't read more after the byte count which is in the
first data. If you want to read length of data but the block size is
bigger than length, you should call block read at first place. If the
block size is smaller than length, why increase the length? Does your
SMBus controller only support fixed block size and not support single
byte read? If it does, I would do

Block, Block, Block, byte, byte... until length of data

Regards,

York



