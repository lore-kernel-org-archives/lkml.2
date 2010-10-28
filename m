Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761128Ab0J1SV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:21:29 -0400
Received: from kroah.org ([198.145.64.141]:46287 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760922Ab0J1SVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:21:24 -0400
Date: Thu, 28 Oct 2010 10:56:15 -0700
From: Greg KH <greg@kroah.com>
To: "Emilio G. Cota" <cota@braap.org>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 09/30] staging/vme: fill in struct device's .release,
 even if it's a NOOP
Message-ID: <20101028175615.GA2367@kroah.com>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
 <1288055476-19438-10-git-send-email-cota@braap.org>
 <4CC804FF.9050908@ge.com>
 <20101027144642.GP10869@flamenco.cs.columbia.edu>
 <20101028011711.GA29960@kroah.com>
 <20101028060710.GB10720@flamenco.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101028060710.GB10720@flamenco.cs.columbia.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 02:07:10AM -0400, Emilio G. Cota wrote:
> On Wed, Oct 27, 2010 at 18:17:11 -0700, Greg KH wrote:
> > On Wed, Oct 27, 2010 at 10:46:42AM -0400, Emilio G. Cota wrote:
> > > On Wed, Oct 27, 2010 at 11:54:55 +0100, Martyn Welch wrote:
> > > > I guess this is an artifact of the current lack of refcounting?
> > > 
> > > No, that's orthogonal to this. This has to do with the way the
> > > devices are allocated.
> > > 
> > > > This is definitely an issue, however I don't think masking it by adding
> > > > an empty function is the correct way to go.
> > > 
> > > We're not masking anything. The release method is there to free the
> > > struct it protects when its refcount goes to zero; however, in this
> > > case the struct wasn't allocated dynamically--the 32 devices are
> > > stored in struct vme_bridge in an array--and therefore there's
> > > nothing to do in .release, since struct vme_bridge is freed
> > > elsewhere.
> > > 
> > > While it's true that empty .release methods are usually frowned
> > > upon (as stated in Documentation/kobject.txt), due to the way
> > > things are done here it actually makes sense to have an
> > > empty .release.
> > 
> > FROWNED APON?
> > 
> > Heh, if you add one, as per the documentation there, I get to publicly
> > ridicule you for doing so.
> > 
> > So consider this your ridicule, if you ever are thinking you need to
> > create an empty release function, YOUR CODE IS WRONG!
> > 
> > Seriously, do you think I just add warnings in there for fun?  So that
> > you can work around them thinking you know better?
> > 
> > {sigh}
> > 
> > Your implementation is broken, never do this, if you create a kobject,
> > you HAVE TO FREE IT in the release function.
> > 
> > I would ask why you are even using a kobject in the first place (hint,
> > if you are writing a driver, or even a subsystem, you shouldn't be, use
> > 'struct device' instead.)
> 
> 
> kobject?
> 
> We were talking about a struct device's .release, not about a struct
> kobject's .release.
> 
> The warning comes from the kobject embedded in struct device, not
> from a kobject per se. In fact, let me make it clearer:
> 
> 		NO KOBJECT IS DIRECTLY OPERATED ON.

Ok, thanks, I wasn't paying attention.

Empty device release functions are also incorrect and shouldn't even be
part of a patch series.

> Fact: Anything other than freeing struct device in .release is
> a bug. So the warning is very well placed there, no question
> about it.

Agreed.

> Example: when a VME bridge is removed, then all devices are
> mercilessly freed, even if their refcounts aren't 0 because
> drivers are controlling them. This is a BUG, and both Martin
> and I knew it.

Ok, then patches are gladly accepted to fix it.

> Fact: Right now VME drivers MUST be removed before VME
> bridges are removed. We all agree on that this is broken--

Yup, it's broken, please don't require that.

> bridges shouldn't be allowed to be removed if there are
> drivers controlling any of their devices. Patch 27
> addresses this among other things.

Not true, a bridge should be able to be removed, just that the devices
will then be deleted as well.  See USB bus drivers for examples of how
to do this properly.

thanks,

greg k-h
