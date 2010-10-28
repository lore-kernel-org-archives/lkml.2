Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab0J1BUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 21:20:38 -0400
Received: from kroah.org ([198.145.64.141]:46999 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980Ab0J1BUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 21:20:35 -0400
Date: Wed, 27 Oct 2010 18:17:11 -0700
From: Greg KH <greg@kroah.com>
To: "Emilio G. Cota" <cota@braap.org>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 09/30] staging/vme: fill in struct device's .release,
	even if it's a NOOP
Message-ID: <20101028011711.GA29960@kroah.com>
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-10-git-send-email-cota@braap.org> <4CC804FF.9050908@ge.com> <20101027144642.GP10869@flamenco.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027144642.GP10869@flamenco.cs.columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 10:46:42AM -0400, Emilio G. Cota wrote:
> On Wed, Oct 27, 2010 at 11:54:55 +0100, Martyn Welch wrote:
> > On 26/10/10 02:10, Emilio G. Cota wrote:
> > > From: Emilio G. Cota <cota@braap.org>
> > > 
> > > Without it we get 32 warnings, one per device being released, when
> > > removing a bridge module.
> > > 
> > > After applying this patch, bridge modules can at last be removed
> > > without any apparent hiccup.
> > > 
> > > [Note: tested only on the tsi148, it's the only bridge I've got]
> > > 
> > 
> > I guess this is an artifact of the current lack of refcounting?
> 
> No, that's orthogonal to this. This has to do with the way the
> devices are allocated.
> 
> > This is definitely an issue, however I don't think masking it by adding
> > an empty function is the correct way to go.
> 
> We're not masking anything. The release method is there to free the
> struct it protects when its refcount goes to zero; however, in this
> case the struct wasn't allocated dynamically--the 32 devices are
> stored in struct vme_bridge in an array--and therefore there's
> nothing to do in .release, since struct vme_bridge is freed
> elsewhere.
> 
> While it's true that empty .release methods are usually frowned
> upon (as stated in Documentation/kobject.txt), due to the way
> things are done here it actually makes sense to have an
> empty .release.

FROWNED APON?

Heh, if you add one, as per the documentation there, I get to publicly
ridicule you for doing so.

So consider this your ridicule, if you ever are thinking you need to
create an empty release function, YOUR CODE IS WRONG!

Seriously, do you think I just add warnings in there for fun?  So that
you can work around them thinking you know better?

{sigh}

Your implementation is broken, never do this, if you create a kobject,
you HAVE TO FREE IT in the release function.

I would ask why you are even using a kobject in the first place (hint,
if you are writing a driver, or even a subsystem, you shouldn't be, use
'struct device' instead.)

So consider this a rejection of this patch and implementation :)

thanks,

greg k-h
