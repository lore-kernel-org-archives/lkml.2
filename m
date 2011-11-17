Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab1KQSUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:20:07 -0500
Received: from imr4.ericy.com ([198.24.6.9]:51994 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1KQSUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:20:04 -0500
Subject: Re: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: York Sun <yorksun@freescale.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Tabi Timur-B04825 <B04825@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "B29983@freescale.com" <B29983@freescale.com>
In-Reply-To: <1321471473.7847.126.camel@oslab-l1>
References: <1321338462-6138-1-git-send-email-guenter.roeck@ericsson.com>
	 <CAOZdJXUPO5PyMkAw-2EPvy_qSUuqsgUA7Gr8mKUX7HyShoXk3g@mail.gmail.com>
	 <E6AF40B3BFC8A9428EACB47497F0F4B62DC687@039-SN1MPN1-002.039d.mgd.msft.net>
	 <ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>
	 <1321464509.7847.41.camel@oslab-l1>
	 <1321464968.2309.384.camel@groeck-laptop>
	 <1321466135.7847.55.camel@oslab-l1>
	 <20111116190954.67c846fc@endymion.delvare>
	 <1321467638.7847.73.camel@oslab-l1>
	 <20111116201048.4b7877dd@endymion.delvare>
	 <1321470915.7847.122.camel@oslab-l1>
	 <20111116201847.6b11dc7f@endymion.delvare>
	 <1321471473.7847.126.camel@oslab-l1>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 17 Nov 2011 10:18:44 -0800
Message-ID: <1321553924.2730.7.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 14:24 -0500, York Sun wrote:
> On Wed, 2011-11-16 at 20:18 +0100, Jean Delvare wrote:
> > On Wed, 16 Nov 2011 11:15:15 -0800, York Sun wrote:
> > > On Wed, 2011-11-16 at 20:10 +0100, Jean Delvare wrote:
> > > > On Wed, 16 Nov 2011 10:20:38 -0800, York Sun wrote:
> > > > > On Wed, 2011-11-16 at 19:09 +0100, Jean Delvare wrote:
> > > > > > Your thinking is too focused on I2C block reads (or even block read of
> > > > > > data over the network or on disk). SMBus block read is something
> > > > > > completely different. It's not about reading 200 bytes of data and
> > > > > > receiving it in 16-byte chunks (I2C block read works that way, on
> > > > > > EEPROMs in particular.) There is no "data length" and "block size" to
> > > > > > compare to each other. It's about reading the value of _one_ register
> > > > > > and this value happens to be multi-byte. There is typically _no_
> > > > > > register pointer increment (automatic or not) involved as can happen
> > > > > > with EEPROMs. If an SMBus block read from register N returns 10 bytes,
> > > > > > you're not going to read the next 10 bytes from register N+10. There
> > > > > > are no "next 10 bytes" to read, and register N+10 is something
> > > > > > completely unrelated.
> > > > > > 
> > > > > > And for this reason, it is not possible to mix SMBus block reads with
> > > > > > byte reads, as can be done with I2C block reads.
> > > > > > 
> > > > > > Also note that there is a limit of 32 bytes for SMBus block transfers,
> > > > > > per SMBus specification. All slaves and masters must comply with it.
> > > > > > 
> > > > > > I hope I managed to clarify the case this time...
> > > > > 
> > > > > You have made it much clear. If block size is fixed and block read
> > > > > cannot mix with byte read, shall we do this
> > > > > 
> > > > > if length < block_size
> > > > >    read block_size
> > > > > else {
> > > > >    while (length) {
> > > > >        read block_size
> > > > >        length -= block_size
> > > > >    }
> > > > 
> > > > Which part of
> > > > 
> > > >   There is no "data length" and "block size" to compare to each other.
> > > > 
> > > > did you not understand?
> > > 
> > > For example, if the length is 40 and the block size is 32, are you going
> > > to read 32, 72 byte or 64 byte?
> > 
> > The length is not 40. Which part of
> > 
> >   Also note that there is a limit of 32 bytes for SMBus block transfers,
> >   per SMBus specification. All slaves and masters must comply with it.
> > 
> > did you now understand?
> > 
> > Really, please. I understand you're only trying to help and understand
> > the patch, but at some point, if you have zero knowledge about the
> > topic, you're not the right person to review the patch, period. You are
> > still welcome to test the patch if you can and want, that's a
> > completely different task.
> > 
> 
> That's the point. Your patch doesn't check if the length is valid. You
> rely on the caller to know no more than 32 bytes can be transferred. It
> shouldn't limit the subfunction to transfer more than 32 bytes if
> hardware can support it by multiple transactions. If not, print out an
> error message.
> 

It is customary for kernel functions to only validate parameters
wherever a value enters or leaves the kernel, or at least a logical
boundary. Anything else would blow up the kernel size to a point where
it would be unusable. The patch checks if the block length received from
the SMBus slave is correct, which is exactly what it is supposed to do.

If you look closely, you may realize that the mpc_read also doesn't
validate of any of the other parameters. Are you going to request that
such validations be added as well ? How about the other functions in
this driver ? Should each function also validate each of its
parameters ? If not, where do you draw the line ?

Besides, the caller is the SMBus block read function, which does know
that SMBus block reads are limited to 32 bytes (plus length).

Guenter


