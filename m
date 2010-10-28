Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0J1GHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 02:07:21 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:33643 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0J1GHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 02:07:19 -0400
Date: Thu, 28 Oct 2010 02:07:10 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 09/30] staging/vme: fill in struct device's .release,
 even if it's a NOOP
Message-ID: <20101028060710.GB10720@flamenco.cs.columbia.edu>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
 <1288055476-19438-10-git-send-email-cota@braap.org>
 <4CC804FF.9050908@ge.com>
 <20101027144642.GP10869@flamenco.cs.columbia.edu>
 <20101028011711.GA29960@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101028011711.GA29960@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 18:17:11 -0700, Greg KH wrote:
> On Wed, Oct 27, 2010 at 10:46:42AM -0400, Emilio G. Cota wrote:
> > On Wed, Oct 27, 2010 at 11:54:55 +0100, Martyn Welch wrote:
> > > I guess this is an artifact of the current lack of refcounting?
> > 
> > No, that's orthogonal to this. This has to do with the way the
> > devices are allocated.
> > 
> > > This is definitely an issue, however I don't think masking it by adding
> > > an empty function is the correct way to go.
> > 
> > We're not masking anything. The release method is there to free the
> > struct it protects when its refcount goes to zero; however, in this
> > case the struct wasn't allocated dynamically--the 32 devices are
> > stored in struct vme_bridge in an array--and therefore there's
> > nothing to do in .release, since struct vme_bridge is freed
> > elsewhere.
> > 
> > While it's true that empty .release methods are usually frowned
> > upon (as stated in Documentation/kobject.txt), due to the way
> > things are done here it actually makes sense to have an
> > empty .release.
> 
> FROWNED APON?
> 
> Heh, if you add one, as per the documentation there, I get to publicly
> ridicule you for doing so.
> 
> So consider this your ridicule, if you ever are thinking you need to
> create an empty release function, YOUR CODE IS WRONG!
> 
> Seriously, do you think I just add warnings in there for fun?  So that
> you can work around them thinking you know better?
> 
> {sigh}
> 
> Your implementation is broken, never do this, if you create a kobject,
> you HAVE TO FREE IT in the release function.
> 
> I would ask why you are even using a kobject in the first place (hint,
> if you are writing a driver, or even a subsystem, you shouldn't be, use
> 'struct device' instead.)


kobject?

We were talking about a struct device's .release, not about a struct
kobject's .release.

The warning comes from the kobject embedded in struct device, not
from a kobject per se. In fact, let me make it clearer:

		NO KOBJECT IS DIRECTLY OPERATED ON.

proof:
$ find staging/vme -name '*.[ch]' | xargs grep -F 'kobj'
brings no results.



In the current implementation, there's no need to do anything(*) in
struct device's .release, because struct device is, as I said
in my message, freed somewhere else.

(*) Of course this is a bug, but it's a known bug, see below.

All struct device's are freed when struct vme_bridge is freed, and
before that happens, device_unregister() is called for each of the
devices:

@@ void vme_unregister_bridge(struct vme_bridge *bridge)
...
        for (i = 0; i < VME_SLOTS_MAX; i++) {
                dev = &bridge->dev[i];
                device_unregister(dev);
        }

device_unregister(), as you know, calls device_free() which
then calls kobj_del(), deleting the kobject embedded in struct
device. This call to kobj_del() from device_free() is the one
that throws the warning.

> So consider this a rejection of this patch and implementation :)

I don't like the implementation either, and that's why I sent
another patch that fixes this and some other problems--
see patch 27.

Fact: Anything other than freeing struct device in .release is
a bug. So the warning is very well placed there, no question
about it.
Example: when a VME bridge is removed, then all devices are
mercilessly freed, even if their refcounts aren't 0 because
drivers are controlling them. This is a BUG, and both Martin
and I knew it.

Fact: Right now VME drivers MUST be removed before VME
bridges are removed. We all agree on that this is broken--
bridges shouldn't be allowed to be removed if there are
drivers controlling any of their devices. Patch 27
addresses this among other things.

Why did I sent this patch? With it and with some other patches
I wanted to point out some flaws of the current implementation.
However after your email I think sending patch 27 directly
would have been a wiser option--although now we all probably
understand the code a little bit better.

So please let's focus on the important stuff, which is patch
27.

		Emilio, Ridiculous In Chief

