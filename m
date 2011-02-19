Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab1BSPku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 10:40:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43612 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552Ab1BSPkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 10:40:49 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 19 Feb 2011 21:10:23 +0530
Subject: RE: [PATCH 1/2] PRUSS UIO driver support
Thread-Topic: [PATCH 1/2] PRUSS UIO driver support
Thread-Index: AcvPjc0o74aSjXbWQBilWhoEN5SsfQAriEKg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024B83C108@dbde02.ent.ti.com>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>
 <201102181644.17634.arnd@arndb.de>
 <alpine.LFD.2.00.1102181713480.2701@localhost6.localdomain6>
 <201102181731.05644.arnd@arndb.de>
 <alpine.LFD.2.00.1102181802580.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102181802580.2701@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Friday, February 18, 2011 10:33 PM
> To: Arnd Bergmann
> Cc: linux-arm-kernel@lists.infradead.org; TK, Pratheesh Gangadhar;
> davinci-linux-open-source@linux.davincidsp.com; gregkh@suse.de;
> Chatterjee, Amit; Hans J. Koch; LKML
> Subject: Re: [PATCH 1/2] PRUSS UIO driver support
> 
> On Fri, 18 Feb 2011, Arnd Bergmann wrote:
> 
> > On Friday 18 February 2011, Thomas Gleixner wrote:
> > > On Fri, 18 Feb 2011, Arnd Bergmann wrote:
> > > > On Friday 18 February 2011, Pratheesh Gangadhar wrote:
> > > > > Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
> > > > > +static irqreturn_t pruss_handler(int irq, struct uio_info
> *dev_info)
> > > > > +{
> > > > > +   return IRQ_HANDLED;
> > > > > +}
> > > >
> > > > An empty interrupt handler is rather pointless. I guess you really
> > > > notify user space when the interrupt handler gets called, as this
> > > > is the main point of a UIO driver as far as I understand it.
> > >
> > > The UIO core code does this for you when the driver handler returns
> > > IRQ_HANDLED
> >
> > Ah, right.
> >
> > > but the empty handler raises a different questions:
> > >
> > > Is the interrupt edge triggerd or how do you avoid an irq storm here?
> > > Usually UIO drivers are requested to mask the interrupt in the device
> > > itself.
> >
> > If it's edge triggered, it should not advertise IRQF_SHARED, right?
> 
> Nope. And the handler needs a fat comment why this works.

For my understanding - if the interrupt is not shared and not level triggered - is this okay to have empty handler? In this specific case, these interrupt lines are internal to SOC and hooked to ARM INTC from PRUSS. PRUSS has another INTC to handle system events to PRUSS as well as to generate system events to host ARM. These generated events are used for IPC between user application and PRU firmware and for async notifications from PRU firmware to user space. I don't see a reason to make it shared as we have 8 lines available for use. As mentioned before ARM INTC interrupt processing logic converts interrupts to active high pulses.

I also looked at the interrupt handling in existing UIO drivers


static irqreturn_t my_uio_handler(int irq, struct uio_info *dev_info)
{
        if (no interrupt is enabled and no interrupt is active) /For shared interrupt handling
                return IRQ_NONE;

        disable interrupt; // For level triggered interrupts 
        return IRQ_HANDLED;
}

It's not clear how and where interrupts are re-enabled. Is this expected to be done from user space?

Uio_secos3.c has an irqcontrol function to enable/disable interrupts. Is this the recommended approach?

Thanks and Regards,
Pratheesh
