Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab2JIXdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:33:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:33622 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2JIXdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:33:00 -0400
Date: Tue, 9 Oct 2012 20:32:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Ryan Mallon <rmallon@gmail.com>, Joe Perches <joe@perches.com>,
        walter harms <wharms@bfs.de>, Antti Palosaari <crope@iki.fi>,
        kernel-janitors@vger.kernel.org, shubhrajyoti@ti.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for
 i2c_msg initialization
Message-ID: <20121009203238.63d2275f@infradead.org>
In-Reply-To: <alpine.DEB.2.02.1210081028340.1989@hadrien>
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
	<20121007225639.364a41b4@infradead.org>
	<50723661.6040107@gmail.com>
	<alpine.DEB.2.02.1210081028340.1989@hadrien>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 8 Oct 2012 10:31:33 +0200 (CEST)
Julia Lawall <julia.lawall@lip6.fr> escreveu:

> I found only 15 uses of I2C_MSG_OP, out of 653 uses of one of the three
> macros.  Since I2C_MSG_OP has the complete set of flags, I think it should
> be OK?
> 
> One of the uses, in drivers/media/i2c/adv7604.c, is as follows:
> 
>        struct i2c_msg msg[2] = { { client->addr, 0, 1, msgbuf0 },
>                                  { client->addr, 0 | I2C_M_RD, len, msgbuf1 }
> 
> I'm not sure what was intended, but I guess the second structure is
> supposed to only do a read?

Yes, this is just typical I2C register read I2C messsage. The first line
specifies what register should be read (the content of msgbuf0), with is
a one char value, and the second line stores the registers contents at
msgbuf1.

This is exactly what I said before: this is a typical situation:

Just one macro could be used for that, with 4 parameters:

	I2C_MSG_READ_SUBADDR(addr, sub_addr, len, buf);

Almost all of those I2C messages will fall on 3 cases only:
	- a read msg (3 parameters, 1 msg);
	- a write message (3 parameters, 1 msg);
	- a write subaddr followed by a read (4 parameters, 2 msgs).

You'll find very few exceptions to it, where additional I2C flags are
needed, or several different transactions were grouped together, due
to the I2C locking or in order to use I2C repeat-start mode[1].

In a matter of fact, as the maintainer, I prefer to fully see the entire
I2C message for those exceptions, as those other usages require more care
while reviewing/merging.


[1] very, very few media i2c bus drivers implement any other flags except
for I2C_M_RD. That's why it is so rare to see them there.

> 
> julia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
