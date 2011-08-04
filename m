Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1HDQfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:35:18 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:42049 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1HDQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:35:15 -0400
Date: Thu, 4 Aug 2011 12:34:51 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Manohar Vanga <manohar.vanga@cern.ch>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110804163451.GA18422@flamenco.cs.columbia.edu>
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch>
 <4E39555C.30507@ge.com>
 <20110803140630.GA29460@becoht-mvanga>
 <20110803152317.GA21903@flamenco.cs.columbia.edu>
 <4E3A4904.3040007@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3A4904.3040007@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 08:23:48 +0100, Martyn Welch wrote:
> On 03/08/11 16:23, Emilio G. Cota wrote:
> > On Wed, Aug 03, 2011 at 16:06:30 +0200, Manohar Vanga wrote:
> >>> Can we not do this inside vme_master_request, vme_slave_request, etc?
> >>> I.e. Add reference count when resources are given out.
> >>> This would then be done in the vme_*_free routines.
> >>
> >> I agree this would be much better. I will change this and resend :)
> > 
> > To me it seems better to keep this as is, to be
> > used by .probe and .release methods, in the same way
> > usb_get_dev() and usb_put_dev() are used by usb drivers.
> 
> The description of the functions in usb.c suggests, to me at least, that these
> functions are the equivalent to the vme_*_request functions in the vme code.
> Being called when a function binds to an interface and when it is finished
> with it.

Which functions? usb_get_dev and usb_put_dev? These _only_
in/de-crement the refcounts. They're called by .probe and
.release methods of usb drivers. The "resources" or "services"
the callers acquire from the usb bridge is orthogonal.

The point is to separate incrementing the refcounts from other
functionality. We have currently five "request" functions:
vme_{master,slave,dma,irq,lm}_request. The average driver
would call two or three of these for each device. This would
result in a fairly large refcount for the bridge, that would
tell us nothing about how many users (devices) are hanging in
there--"yeah, we have lots" is not good enough.

So no, usb_get_dev and usb_put_dev are not equivalent to our
vme_*_request functions. The get/put functions only operate
on the refcounts, to mark the dependency of a struct device
on another device (the bridge) so that the parent cannot
be removed. This is the way things are done in other much
more mature subsystems, I don't see why we should do it
differently.

		Emilio
