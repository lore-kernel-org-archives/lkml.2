Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0FCOf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:35:59 -0400
Received: from www.tglx.de ([62.245.132.106]:58459 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397Ab0FCOfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:35:53 -0400
Date: Thu, 3 Jun 2010 16:35:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Bottomley <James.Bottomley@suse.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Gross, Mark" <mark.gross@intel.com>,
       Florian Mickler <florian@mickler.org>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, "tytso@mit.edu" <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <1275571471.5914.2.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.00.1006031602160.2933@localhost.localdomain>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>  <20100601135102.GA8098@srcf.ucam.org>  <1275426085.21962.967.camel@mulgrave.site> <201006020024.14220.rjw@sisk.pl>  <1275431816.21962.1108.camel@mulgrave.site>  <AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>
  <1275451342.21962.1777.camel@mulgrave.site>  <AANLkTilRcFZyYa-0HlaM-6IEZSyar3S9S_cCWSFax2Zo@mail.gmail.com>  <1275491111.2799.110.camel@mulgrave.site>  <20100602214748.7742e3ae@schatten.dmk.lab>  <1275511271.2799.516.camel@mulgrave.site> 
 <20100603010607.5baf82a6@schatten.dmk.lab>  <CA1BBBBC9359F04AA639128AC0D5D1E9692ABC92@orsmsx502.amr.corp.intel.com>  <20100603110312.48a508dc@lxorguk.ukuu.org.uk> <1275571471.5914.2.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, James Bottomley wrote:

> On Thu, 2010-06-03 at 11:03 +0100, Alan Cox wrote:
> > > [mtg: ] This has been a pain point for the PM_QOS implementation.  They change the constrain back and forth at the transaction level of the i2c driver.  The pm_qos code really wasn't made to deal with such hot path use, as each such change triggers a re-computation of what the aggregate qos request is.
> > 
> > That should be trivial in the usual case because 99% of the time you can
> > hot path
> > 
> > 	the QoS entry changing is the latest one
> > 	there have been no other changes
> > 	If it is valid I can use the cached previous aggregate I cunningly
> > 		saved in the top QoS entry when I computed the new one
> > 
> > (ie most of the time from the kernel side you have a QoS stack)
> 
> It's not just the list based computation: that's trivial to fix, as you
> say ... the other problem is the notifier chain, because that's blocking
> and could be long.  Could we invoke the notifier through a workqueue?
> It doesn't seem to have veto power, so it's pure notification, does it
> matter if the notice is delayed (as long as it's in order)?

It depends on the information type and for a lot of things we might
get away without notifiers. 

The only real issue is when you need to get other cores out of their
deep idle state to make a new constraint work. That's what we do with
the DMA latency notifier right now.

Thanks,

	tglx
