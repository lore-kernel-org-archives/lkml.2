Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab1DLOj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:39:56 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:44713 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab1DLOjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:39:53 -0400
Date: Tue, 12 Apr 2011 16:39:49 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@c4eb
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs: cannot create duplicate filename
In-Reply-To: <20110411175628.GA24301@suse.de>
Message-ID: <alpine.LFD.2.02.1104121637450.2239@c4eb>
References: <alpine.LFD.2.02.1104111556280.1938@c4eb> <20110411141309.GA8924@suse.de> <alpine.LFD.2.02.1104111622490.1938@c4eb> <20110411144956.GA16610@suse.de> <alpine.LFD.2.02.1104111658560.1770@c4eb> <20110411151947.GA17913@suse.de>
 <alpine.LFD.2.02.1104111943590.2036@c4eb> <20110411175628.GA24301@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Apr 2011, Greg KH wrote:

> On Mon, Apr 11, 2011 at 07:50:34PM +0200, Sebastian Ott wrote:
> > 
> > 
> > On Mon, 11 Apr 2011, Greg KH wrote:
> > 
> > > On Mon, Apr 11, 2011 at 05:05:08PM +0200, Sebastian Ott wrote:
> > > > 
> > > > 
> > > > On Mon, 11 Apr 2011, Greg KH wrote:
> > > > 
> > > > > On Mon, Apr 11, 2011 at 04:33:03PM +0200, Sebastian Ott wrote:
> > > > > > On Mon, 11 Apr 2011, Greg KH wrote:
> > > > > > 
> > > > > > > On Mon, Apr 11, 2011 at 04:04:08PM +0200, Sebastian Ott wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > i've seen this warning which looks to be caused by a race between device_add
> > > > > > > > and driver_register
> > > > > > > > 
> > > > > > > > [   80.893594] sysfs: cannot create duplicate filename '/bus/ccw/drivers/qeth/0.0.b57d'
> > > > > > > 
> > > > > > > Isn't the problem here the fact that you are creating 2 directories of
> > > > > > > the same name?
> > > > > > I'm sure this isn't the case here. The bus code just calls device_add and
> > > > > > at the same time on a different thread a module is loaded which registers
> > > > > > a driver at the bus.
> > > > > > 
> > > > > > I was able to reproduce this with a module which creates a dummy bus
> > > > > > and registers drivers and devices on this bus on 2 different workqueues.
> > > > > 
> > > > > That makes sense, as no bus should be doing this on multiple "threads".
> > > > > What real-life bus does this today?
> > > > A bus that will recognize and register a lot of devices, after the first
> > > > uevent is presented to userspace, a module will be loaded registering a
> > > > driver from a different thread. I don't think thats uncommon.
> > > 
> > > But again, what kernel code today does this?  I think they all have
> > > locks to keep this from happening, right?
> > I couldn't find a bus who protects device_register against driver_register
> > and I don't think this is something which should be handled by every
> > individual bus but from within the driver core.
> 
> How did you cause the oops in this original message?  What type of bus
> was it on?  And did your patch solve the issue?

I've seen this warning on a system which had a lot of devices attached.
Those devices also responded _very_ slow. So it took some time to
register all these deivces (qeth) on the bus (ccw). During this time
the qeth module got loaded and registered the qeth driver.

Since i've never seen this warning and those devices normally don't
take so much time to respond I wrote the beforementioned module to
reproduce the race and make sure that this is no driver issue.

With this module the warning could be triggered after a few cycles.
With the patch applied, I did not see the warning again even after
> 10.000 cycles.

regards,
Sebastian
