Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1C1IyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:54:21 -0400
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:34484 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746Ab1C1IyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:54:19 -0400
Date: Mon, 28 Mar 2011 11:54:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, gregkh@suse.de, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5 v5] usb:gadget: Add SuperSpeed support to the
 Gadget Framework
Message-ID: <20110328085412.GJ2251@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1300867498-20997-1-git-send-email-tlinder@codeaurora.org>
 <20110325134101.GM2609@legolas.emea.dhcp.ti.com>
 <000501cbed24$8efd1f70$acf75e50$@org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501cbed24$8efd1f70$acf75e50$@org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 10:45:54AM +0200, Tanya Brokhman wrote:
> Hi
> 
> > 
> > On Wed, Mar 23, 2011 at 10:04:57AM +0200, Tatyana Brokhman wrote:
> > > This patch adds the SuperSpeed functionality to the gadget framework.
> > > In order not to force all the gadget drivers to supply SuperSpeed
> > > descriptors when operating in SuperSpeed mode the following approach
> > was
> > > taken:
> > > If we're operating in SuperSpeed mode and the gadget driver didn't
> > supply
> > > SuperSpeed descriptors, the composite layer will automatically create
> > > SuperSpeed descriptors with default values.
> > > Support for new SuperSpeed BOS descriptor was added.
> > > Support for SET_FEATURE and GET_STATUS requests in SuperSpeed mode
> > was
> > > added.
> > 
> > IMHO, this patch tries to do too much in one huge patch. It needs major
> > splitting.
> > 
> > Also, I don't get why you decided to go the path of letting composite.c
> > generate the super speed descriptors instead of expecting gadget
> > drivers
> > to pass those should they support super speed.
> > 
> > I would like the other way much better: first, it's what we already do
> > for full/low speed and high speed. Second, we can easily see the
> > descriptors by opening the gadget driver's code.
> > 
> 
> Our goal was to provide a generic solution that will enable existing gadget
> drivers to operate in SS mode with minimum changes to their code. If a
> certain gadget driver wishes to operate in SS mode and the values in the
> descriptors are important to it, this FD should define its own SS
> descriptors as already done for HS/LS and those (SS) descriptors will be
> chosen. 

and then we have two paths for achieving the same thing. And most
likely, what'll happen is that you're gonna one or two uses of the
composite.c layer for generating the descriptors and all the others will
prefer to provide their own descriptors.

I mean, depending on the function driver, we're gonna different
requirements WRT bandwidth, endpoints, etc. So, since you're gonna
little use of the generic solution, it's better not to have it. It won't
benefit many users.

> Please note that a gadget driver can also choose not to have SS descriptors
> generated for it all, even if it didn't provide any of its own and thus
> choosing not to operate in SS mode.

that's not what we want with the Linux gadget drivers. We want them to
be example (and productable) implementations working on all speeds. It's
like that because we want to, both, showcase the framework while also
letting those drivers be configurable enough so manufacturers can simply
re-use them.

Check nokia.c, that's a good example of a manufacturer re-using the open
source function drivers to provide a vendor specific solution :-)

> If you look at our implementation of the UAS gadget driver you'll see that
> we define the SS descriptors just as is done for HS/LS and those descriptors
> are chosen in enumeration.

then again, why do you need this Generic Solution ?

> I believe that in the future all gadget drivers will define their own SS
> descriptors with values that are suitable for that gadget driver and the
> create_ss_descriptors() will become obsolete. As I've already mentioned this
> is just a way to allow all the existing drivers to operate in SS mode with
> minimum changes to their code. So this patch doesn't contradict your
> approach, just extends it. 

but that's not a good approach. You're adding bloat which will be
removed soon. Problem is that once it's there, we will have to support
it for a long long time as we won't know if there are any out of tree
gadget drivers depending on that, forcing us on publising of
Documentation/feature-removal-schedule.txt that we will remove that
layer in e.g. 4 major revisions. So, IMHO, better not to add it.

> > There are a few more comments below, but this patch needs major, major
> > splitting.
> 
> I'll address your comments and split it up in the next version. I would like
> to give Greg and others a chance to comment as well before uploading another
> version.

Sure, makes sense :-)

-- 
balbi
