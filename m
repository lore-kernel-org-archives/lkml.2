Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308Ab0HGAnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:43:52 -0400
Received: from ns2.cypress.com ([157.95.67.5]:40173 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab0HGAns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:43:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] i2c: cyttsp i2c and spi touchscreen driver init submit
Date: Fri, 6 Aug 2010 17:39:32 -0700
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC09C4860C@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] i2c: cyttsp i2c and spi touchscreen driver init submit
Thread-Index: Acs04i5aDGJxUCOdRfWXuETVvW9VKgA5jeGQ
References: <kev@cypress.com> <1281031924-3032-1-git-send-email-kev@cypress.com> <4C5B22F8.1030204@codeaurora.org> <20100805210705.GA20063@core.coreip.homeip.net>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Trilok Soni" <tsoni@codeaurora.org>
Cc: "David Brown" <davidb@codeaurora.org>,
        "Fred" <fwk@ubuntu.linuxcertified.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Eric Miao" <eric.y.miao@gmail.com>, "Ben Dooks" <ben-linux@fluff.org>,
        "Simtec Linux Team" <linux@simtec.co.uk>,
        "Todd Fischer" <todd.fischer@ridgerun.com>,
        "Arnaud Patard" <arnaud.patard@rtp-net.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Henrik Rydberg" <rydberg@euromail.se>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Aug 2010 00:39:33.0006 (UTC) FILETIME=[00E77AE0:01CB35C9]
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Thursday, August 05, 2010 2:07 PM
> To: Trilok Soni
> Cc: Kevin McNeely; David Brown; Fred; Samuel Ortiz; Eric Miao; Ben
> Dooks; Simtec Linux Team; Todd Fischer; Arnaud Patard; Sascha Hauer;
> Henrik Rydberg; linux-input@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] i2c: cyttsp i2c and spi touchscreen driver init
> submit
> 
> On Fri, Aug 06, 2010 at 02:15:44AM +0530, Trilok Soni wrote:
> > > +
> > > +/*
>
***********************************************************************
> *
> > > + * The cyttsp_xy_worker function reads the XY coordinates and
> sends them to
> > > + * the input layer.  It is scheduled from the interrupt (or
> timer).
> > > + *
>
***********************************************************************
> **/
> > > +void handle_single_touch(struct cyttsp_xydata *xy, struct
> cyttsp_track_data *t,
> > > +			 struct cyttsp *ts)
> > > +{
> >
> > functions should be "static". I would leave a decision to Dmitry if
> he wants the driver
> > to support old single touch protocol hacked up with HAT_xx bits so
> that driver can support
> > two touches with the old single touch protocol itself.
> 
> The ABS_HAT* bits should go away. They were gross abuse even when we
> did
> not have MT protocol and shoudl not be used at all now that we do have
> it. I will be cleaning up older drivers (like Elantech) to get rid of
> them.

I will remove the ST code completely.

> 
> Multitouch devices shouls support either A or B MT protocol. SInce
this
> device seems to be supporting tracking in hardware it shoudl simply
> adhere to protocol B to limit kernel->userspace traffict and be done
> with it.
> 
> ...

I have responded to Henrik's review about protocol A and B.
I would like to keep protocol A for now and just change the default
to Protocol B?

> 
> > > +
> > > +/* schedulable worker entry for timer polling method */
> > > +void cyttsp_xy_worker_(struct work_struct *work)
> > > +{
> > > +	struct cyttsp *ts = container_of(work, struct cyttsp, work);
> > > +	cyttsp_xy_worker(ts);
> > > +}
> >
> > I would really prefer that you remove the polling method from this
> code as it will simplify
> > a code lot. We can delete the whole workqueue because as you will be
> using request_threaded_irq(...),
> > you will not need any workqueue.
> >
> 
> Seconded. Polling is hardly useful on real production setup as it will
> drain battery in no time.
> 

I will remove polling completely.

> > > +
> > > +static int cyttsp_i2c_init(void)
> > > +{
> >
> > Please add __init like
> >
> > static int __init cyttsp_i2c_init(void)
> >
> > > +	int retval;
> > > +	retval = i2c_add_driver(&cyttsp_i2c_driver);
> > > +	printk(KERN_INFO "%s: Cypress TrueTouch(R) Standard Product I2C
"
> > > +		"Touchscreen Driver (Built %s @ %s) returned %d\n",
> > > +		 __func__, __DATE__, __TIME__, retval);
> > > +
> 
> And lose printk as well. The boot is exremely noisy as it is...
> 
> 	return i2c_add_driver(&cyttsp_i2c_driver);
> 
> is all that is needed.

I will make this change.

Thank you for your review.
-kev

> 
> --
> Dmitry

---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

