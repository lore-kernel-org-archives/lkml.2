Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2JHB5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 21:57:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:55092 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2JHB5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 21:57:03 -0400
Date: Sun, 7 Oct 2012 22:56:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, walter harms <wharms@bfs.de>,
        Antti Palosaari <crope@iki.fi>, kernel-janitors@vger.kernel.org,
        rmallon@gmail.com, shubhrajyoti@ti.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for
 i2c_msg initialization
Message-ID: <20121007225639.364a41b4@infradead.org>
In-Reply-To: <1349646718.15802.16.camel@joe-AO722>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
	<1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr>
	<5071AEF3.6080108@bfs.de>
	<alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6>
	<5071B834.1010200@bfs.de>
	<alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6>
	<1349633780.15802.8.camel@joe-AO722>
	<alpine.DEB.2.02.1210072053550.2745@localhost6.localdomain6>
	<1349645970.15802.12.camel@joe-AO722>
	<alpine.DEB.2.02.1210072342460.2745@localhost6.localdomain6>
	<1349646718.15802.16.camel@joe-AO722>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 07 Oct 2012 14:51:58 -0700
Joe Perches <joe@perches.com> escreveu:

> On Sun, 2012-10-07 at 23:43 +0200, Julia Lawall wrote:
> > On Sun, 7 Oct 2012, Joe Perches wrote:
> > >> Are READ and WRITE the action names?  They are really the important
> > >> information in this case.
> > >
> > > Yes, most (all?) uses of _READ and _WRITE macros actually
> > > perform some I/O.
> > 
> > I2C_MSG_READ_DATA?
> > I2C_MSG_READ_INFO?
> > I2C_MSG_READ_INIT?
> > I2C_MSG_PREPARE_READ?
> 
> Dunno, naming is hard.  Maybe:
> 
> I2C_INPUT_MSG
> I2C_OUTPUT_MSG
> I2C_OP_MSG

READ/WRITE sounds better, IMHO, as it will generally match with the
function names (they're generally named like foo_i2c_read or foo_reg_read).
I think none of them uses input or output. Btw, with I2C buses, a
register read is coded as a write ops, that sets the register's sub-address,
followed by a read ops from that (and subsequent) registers.

I'm afraid that using INPUT/OUTPUT will sound confusing.

So, IMHO, I2C_READ_MSG and I2C_WRITE_MSG sounds better.

Btw, as the WRITE + READ operation is very common (I think it is
much more common than a simple READ msg), it could make sense to have
just one macro for it, like:

INIT_I2C_READ_SUBADDR() that would take both write and read values.

I also don't like the I2C_MSG_OP. The operations there are always
read or write.

So, IMHO, the better would be to code the read and write message init message 
as something similar to:

#define DECLARE_I2C_MSG_READ(_msg, _addr, _buf, _len, _flags)					\
	struct i2c_msg _msg[1] = {								\
		{.addr = _addr, .buf = _buf, .len = _len, .flags = (_flags) | I2C_M_RD }	\
	}

#define DECLARE_I2C_MSG_WRITE(_msg, _addr, _buf, _len, _flags)					\
	struct i2c_msg _msg[1] = {								\
		{.addr = _addr, .buf = _buf, .len = _len, .flags = (_flags) & ~I2C_M_RD }	\
	}

#define DECLARE_I2C_MSG_READ_SUBADDR(_msg, _addr, _subaddr, _sublen,_subflags, _buf,_len, _flags)	\
	struct i2c_msg _msg[2] = {									\
		{.addr = _addr, .buf = _subbuf, .len = _sublen, .flags = (_subflags) & ~I2C_M_RD }	\
		{.addr = _addr, .buf = _buf, .len = _len, .flags = (_flags) | I2C_M_RD }		\
	}


Notes:

1) in the case of DECLARE_I2C_MSG_READ_SUBADDR(), I'm almost sure that, in all cases, the
first message will always have buffer size equal to 1. If so, you can simplify the number
of arguments there.

2) It could make sense to have, in fact, two versions for each, one with _FLAGS and another one
without. On most cases, the one without flags are used.

3) I bet that most of the cases where 2 messages are used, the first message has length equal
to one, and it uses a fixed u8 constant with the I2C sub-address. So, maybe it would be nice
to have a variant for this case.


Cheers,
Mauro
