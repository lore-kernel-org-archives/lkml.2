Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2LJMoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:44:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57557 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2LJMop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:44:45 -0500
Date: Mon, 10 Dec 2012 12:44:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Giridhar Maruthy <giridhar.maruthy@linaro.org>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        linux-samsung-soc@vger.kernel.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux-i2c@vger.kernel.org, ben-linux@fluff.org, khali@linux-fr.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] I2C: EXYNOS: Add slave support to i2c
Message-ID: <20121210124427.GI14363@n2100.arm.linux.org.uk>
References: <1354354961-28833-1-git-send-email-giridhar.maruthy@linaro.org> <CAHuqX+EQ0pZnm27yAVqC=NRX8huQ5EvbC8PGn2G3xYw4D71gQA@mail.gmail.com> <50C1DB05.7090500@linaro.org> <20121207123343.GU14363@n2100.arm.linux.org.uk> <CAHuqX+G7e4bR_xK2BAEdm4dedaBHE=CG3sHmzHamgCiOtivNwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHuqX+G7e4bR_xK2BAEdm4dedaBHE=CG3sHmzHamgCiOtivNwQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 03:02:28PM +0530, Giridhar Maruthy wrote:
> Hi Russel,
> 
> Thanks for review and please find my replies below.
> 
> On 7 December 2012 18:03, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Dec 07, 2012 at 05:33:17PM +0530, Tushar Behera wrote:
> >> On 12/03/2012 05:46 PM, Giridhar Maruthy wrote:
> >> > This patch adds slave support to i2c. The dt entry i2c-mode
> >> > decides at probe time if the controller needs to work in
> >> > slave mode and the controller is accordingly programmed.
> >
> > (I don't have the original patches.)
> >
> > Hmm.  How has slave-mode support been tested?
> 
> I have taken two I2C controllers in exynos5250.
> I configured one as slave and the other as master port.
> Then physically connected the pins of the two ports.
> >
> > Remembering that I2C slave devices do not initiate bus accesses, all
> > accesses will be started by some other master.  How are you dealing
> > with the bytes received from the master,
> 
> I run the slave read application in background.
> The resulting slave read will sleep till all bytes are received
> (wait_event_interruptible)

Oh god no, not more broken interruptible waits in I2C code.  I've seen
already the results of crap like this with a kernel I2C peripheral driver
falling over because the I2C layer returns -ERESTARTcrap with the Marvell
I2C bus adapter.

> once the master sends the data, an ack is given out by the slave controller
> in the ISR and the data is cached in the buffer(
> buffer sent by slave receive application).
> After all data is received, the read wakes up and the
> slave receive program gets the data.
> 
> > and how are you returning a response to the master in reply to a read request?
> 
> Similarl logic works in slave transmit mode (read request). Slave
> sleeps till the master initiates the transfer.
> >
> > We had support for this on PXA I2C through a callback from the driver
> > into PXA code (used for the Psion Teklogix Netbook device) and it worked
> > really well, but what you can't do is use the standard I2C interfaces
> > for slave mode.
> 
> I have a question here. Since the same framework can work for both
> master and slave, is there any technical limitations I have overseen
> which prevents the slave mode to work?

I don't really call your description above as "working" - it sounds like
a bodge - it sounds like trying to bend a layer designed for master mode
to sort-of-maybe-if-the-wind-is-in-the-right-direction-and-the-cows-are-
all-standing-up-work.  What if the application is trying to read in slave
mode while the master is also trying to read?  How do you deal with that?
What about the converse?  What if the application is trying to write data
and the master also issues a write request?

Finally, what about a multi-master situation?  I can see no way for your
implementation to have any hope of working there because there is no
distinction between operating the interface in master mode and slave mode.
