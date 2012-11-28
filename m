Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2K1JW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:22:57 -0500
Received: from mx0.aculab.com ([213.249.233.131]:46581 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751670Ab2K1JWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:22:54 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 3/3] pppoatm: protect against freeing of vcc
Date: Wed, 28 Nov 2012 09:21:37 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B70C9@saturn3.aculab.com>
In-Reply-To: <20121127135434.0728cd4f@thirdoffive.cmf.nrl.navy.mil>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 3/3] pppoatm: protect against freeing of vcc
Thread-Index: Ac3M0I9PRiYxdUQZRLK4R2Nqf+WpVwAeFMSw
References: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net><1350926091-12642-3-git-send-email-krzysiek@podlesie.net><1354036592.2534.6.camel@shinybook.infradead.org><20121127173906.GA11390@shrek.podlesie.net><1354039349.2534.11.camel@shinybook.infradead.org> <20121127135434.0728cd4f@thirdoffive.cmf.nrl.navy.mil>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "chas williams - CONTRACTOR" <chas@cmf.nrl.navy.mil>,
        "David Woodhouse" <dwmw2@infradead.org>
Cc: "Krzysztof Mazur" <krzysiek@podlesie.net>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nathan@traverse.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 27 Nov 2012 18:02:29 +0000
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > In solos-pci at least, the ops->close() function doesn't flush all
> > pending skbs for this vcc before returning. So can be a tasklet
> > somewhere which has loaded the address of the vcc->pop function from one
> > of them, and is going to call it in some unspecified amount of time.
> >
> > Should we make the device's ->close function wait for all TX and RX skbs
> > for this vcc to complete?
> 
> the driver's close routine should wait for any of the pending tx and rx
> to complete.  take a look at the he.c in driver/atm

I'm not sure that sleeping for long periods in close() is always a
good idea. If the process is event driven it will be unable to
handle events on other fd until the close completes.
This may be known not to be true in this case, but is more generally
a problem.
In this case the close should probably (IMHO at least) only sleep
while pending tx and rx are aborted/discarded.

Even when it might make sense to sleep in close until tx drains
there needs to be a finite timeout before it become abortive.

	David



