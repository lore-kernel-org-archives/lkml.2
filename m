Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab2K2S30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:29:26 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:37629 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab2K2S3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:29:24 -0500
Date: Thu, 29 Nov 2012 13:29:02 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>,
        David Laight <David.Laight@ACULAB.COM>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nathan@traverse.com.au
Subject: Re: [PATCH v2 3/3] pppoatm: protect against freeing of vcc
Message-ID: <20121129132902.04373f49@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <1354212708.21562.205.camel@shinybook.infradead.org>
References: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
	<1350926091-12642-3-git-send-email-krzysiek@podlesie.net>
	<1354036592.2534.6.camel@shinybook.infradead.org>
	<20121127173906.GA11390@shrek.podlesie.net>
	<1354039349.2534.11.camel@shinybook.infradead.org>
	<20121127135434.0728cd4f@thirdoffive.cmf.nrl.navy.mil>
	<AE90C24D6B3A694183C094C60CF0A2F6026B70C9@saturn3.aculab.com>
	<1354141115.21562.101.camel@shinybook.infradead.org>
	<20121129150945.GB16478@shrek.podlesie.net>
	<1354204077.21562.172.camel@shinybook.infradead.org>
	<20121129105934.3e0c3a04@thirdoffive.cmf.nrl.navy.mil>
	<1354206269.21562.189.camel@shinybook.infradead.org>
	<20121129121701.21ab7c0b@thirdoffive.cmf.nrl.navy.mil>
	<1354212708.21562.205.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 18:11:48 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> We do see the 'packet received for unknown VCC' complaint, after we
> reboot the host without resetting the card. And as shown in the commit I
> just referenced, we rely on the !ATM_VF_READY check in order to prevent
> a use-after-free when the tasklet is sending packets up a VCC that's
> just been closed.

well that behavior is just crap.  why is it delivering cells for a
vpi/vci pair that is not open?  regardless, i pointed out the behavior
of find_vcc() just in case you need to do some clean up on data that is
coming back while you are attempting to finish operations during your
driver's close() but this cleanup might not be happening since you
arent able to get a reference to the vcc so you can pop() the data or
whatever you might need to do.

> > again part of this is poor synchronization.  the detach protocol (i.e.
> > push of a NULL skb) should be flushing any pending transmits and
> > shutting down whatever in the protocol is doing any sending and
> > receiving.  however, i release this might be difficult to do since the
> > detach protocol is invoked in such a strange way.
> 
> You mean that (e.g.) pppoatm_push(vcc, NULL) should be waiting for any
> pending TX skb (that has already been passed off to the driver) to
> *complete*? How would it even do that?

i think the order of the vcc_destroy_socket() operations is a bit
wrong.  it should call detach protocol (i.e. push a NULL).  this should
cause the attached protocol to stop any future sends and receives, and
it CAN sleep in this context (and only this context -- generally
sending cannot sleep which is why this might seem confusing) to do
whatever it needs to do to wait for the attached protocol to clean up
queues, flush data etc.

then the driver close() should be called.  this takes care of cleaning
up any pending tx or rx that is in the hardware.  and of course,
close() can sleep since it will be in a interrutible context.

the pop() might be screwed up here though.  you might have skb's in the
driver that should be pop()'ed with the formerly attached protocol.

you could wait for pending tx's sent to the driver.  you know that your
attached protocol's pop() will be called.  keep count of the
outstanding transmit skb's.  you cant do this though if you close() the
vcc before you detach the protocol.

