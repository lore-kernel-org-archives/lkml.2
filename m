Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1KPS6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:58:23 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:28606
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336Ab1KPS6V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:58:21 -0500
X-SpamScore: -19
X-BigFish: VS-19(zz9371K936eK1432N98dK4015Lzz1202hzzz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: sun york-R58495 <R58495@freescale.com>
To: "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Tabi Timur-B04825 <B04825@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tang Yuantian-B29983 <B29983@freescale.com>
Subject: RE: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Topic: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Index: AQHMpJDB2MospmxCMEqh4kYjCYIqcZWv2bUG
Date: Wed, 16 Nov 2011 18:58:17 +0000
Message-ID: <E6AF40B3BFC8A9428EACB47497F0F4B62DDBAE@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1321338462-6138-1-git-send-email-guenter.roeck@ericsson.com>
	 <CAOZdJXUPO5PyMkAw-2EPvy_qSUuqsgUA7Gr8mKUX7HyShoXk3g@mail.gmail.com>
	 <E6AF40B3BFC8A9428EACB47497F0F4B62DC687@039-SN1MPN1-002.039d.mgd.msft.net>
	 <ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>
	 <1321464509.7847.41.camel@oslab-l1>
	 <1321464968.2309.384.camel@groeck-laptop>
	 <1321466135.7847.55.camel@oslab-l1>
	 <20111116190954.67c846fc@endymion.delvare>
	 <1321467638.7847.73.camel@oslab-l1>,<1321469491.2309.409.camel@groeck-laptop>
In-Reply-To: <1321469491.2309.409.camel@groeck-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.82.252]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Come on, I am trying to help. You said in the patch you have not been able to test this patch.

I would support your patch only if I can understand why it works.

York

________________________________________
From: Guenter Roeck [guenter.roeck@ericsson.com]
Sent: Wednesday, November 16, 2011 10:51 AM
To: sun york-R58495
Cc: Jean Delvare; Tabi Timur-B04825; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org; Tang Yuantian-B29983
Subject: Re: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA

On Wed, 2011-11-16 at 13:20 -0500, York Sun wrote:
> On Wed, 2011-11-16 at 19:09 +0100, Jean Delvare wrote:
> > On Wed, 16 Nov 2011 09:55:35 -0800, York Sun wrote:
> > > On Wed, 2011-11-16 at 09:36 -0800, Guenter Roeck wrote:
> > > > York,
> > > >
> > > > The calling code expects the data length in data[0], and the actual data
> > > > in data[1] .. data[<byte_count>]. The initial value for length is 1; the
> > > > byte count is added to it, so <byte count + 1> bytes are placed into the
> > > > buffer.
> > > >
> > > > Thanks,
> > > > Guenter
> > >
> > > Thanks for explanation. I am more confused by the length += byte now.
> > > For I2C bus, if you need length of byte, just keep reading until you get
> > > all of them. Of course you need to deal with the ACK. For SMBus, it is
> > > similar but you shouldn't read more after the byte count which is in the
> > > first data.
> >
> > You shouldn't read less either. The slave tells how much bytes it wants
> > to send, and the master must honor that.
> >
> > > If you want to read length of data but the block size is
> > > bigger than length, you should call block read at first place. If the
> > > block size is smaller than length, why increase the length? Does your
> > > SMBus controller only support fixed block size and not support single
> > > byte read? If it does, I would do
> > >
> > > Block, Block, Block, byte, byte... until length of data
> >
> > Your thinking is too focused on I2C block reads (or even block read of
> > data over the network or on disk). SMBus block read is something
> > completely different. It's not about reading 200 bytes of data and
> > receiving it in 16-byte chunks (I2C block read works that way, on
> > EEPROMs in particular.) There is no "data length" and "block size" to
> > compare to each other. It's about reading the value of _one_ register
> > and this value happens to be multi-byte. There is typically _no_
> > register pointer increment (automatic or not) involved as can happen
> > with EEPROMs. If an SMBus block read from register N returns 10 bytes,
> > you're not going to read the next 10 bytes from register N+10. There
> > are no "next 10 bytes" to read, and register N+10 is something
> > completely unrelated.
> >
> > And for this reason, it is not possible to mix SMBus block reads with
> > byte reads, as can be done with I2C block reads.
> >
> > Also note that there is a limit of 32 bytes for SMBus block transfers,
> > per SMBus specification. All slaves and masters must comply with it.
> >
> > I hope I managed to clarify the case this time...
> >
>
> You have made it much clear. If block size is fixed and block read
> cannot mix with byte read, shall we do this
>
> if length < block_size
>    read block_size
> else {
>    while (length) {
>        read block_size
>        length -= block_size
>    }
>

I am giving up. I don't need SMBus block reads to work on our board, I
am having trouble installing my test image on it, I don't see
constructive feedback but only a theoretic discussion about how SMBus
block reads work or are perceived to work or should work, for which I
don't have time, and we already know that the zl6100 driver (which
originated this discussion and was the reason for the patch) is working
fine with the patch applied.

I simply don't have time for this, and spent way too much time on it
already. Jean, please drop this patch. If someone else needs it, he or
she can revive and re-submit it. If folks can complain about the patch
w/o understanding how SMBus block reads work, but are not willing to
test it, something is wrong anyway.

Thanks,
Guenter




