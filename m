Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1BJAjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 19:39:44 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55218 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab1BJAjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 19:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FbJFMRoNMRtsI6fZUIK0Aix0gv5E4gKKyngQELREYUWXLg1KalLe5LM+0Y3wL+3Ojn
         0Yom1Nm7/bFpne1IB8jziVhQDA8J10S3fP4Tnyw/JgDVQx9gjnhanzP3et1bJLYn2LsO
         hNLDAjXt11XH4oHJP0ixfFtbHG1wxVbVvoJB4=
Date: Wed, 9 Feb 2011 16:39:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Message-ID: <20110210003935.GA6034@core.coreip.homeip.net>
References: <1297208267-27087-1-git-send-email-iws@ovro.caltech.edu>
 <1297208267-27087-2-git-send-email-iws@ovro.caltech.edu>
 <20110209083325.GA7256@core.coreip.homeip.net>
 <20110209173532.GB21766@ovro.caltech.edu>
 <20110209182740.GC23867@core.coreip.homeip.net>
 <20110209233544.GA5303@ovro.caltech.edu>
 <20110209234231.GA5707@core.coreip.homeip.net>
 <20110210001055.GB5303@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210001055.GB5303@ovro.caltech.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 04:10:55PM -0800, Ira W. Snyder wrote:
> On Wed, Feb 09, 2011 at 03:42:31PM -0800, Dmitry Torokhov wrote:
> > On Wed, Feb 09, 2011 at 03:35:45PM -0800, Ira W. Snyder wrote:
> > > On Wed, Feb 09, 2011 at 10:27:40AM -0800, Dmitry Torokhov wrote:
> > > 
> > > [ snip stuff I've already fixed in the next version ]
> > > 
> > > > > 
> > > > > The requirement is that the device stay open during reconfiguration.
> > > > > This provides for that. Readers just block for as long as the device is
> > > > > not producing data.
> > > > 
> > > > OK, you still need to make sure you do not touch free/used buffer while
> > > > device is disabled. Also, you need to kick readers if you unbind the
> > > > driver, so maybe a new flag priv->exists should be introduced and
> > > > checked.
> > > > 
> > > 
> > > I don't understand what you mean by "kick readers if you unbind the
> > > driver". The kernel automatically increases the refcount on a module
> > > when a process is using the module. This shows up in the "Used by"
> > > column of lsmod's output.
> > > 
> > > The kernel will not let you rmmod a module with a non-zero refcount. You
> > > cannot get into the situation where you have rmmod'ed the module and a
> > > reader is still blocking in read()/poll().
> > 
> > However you can still unbind the driver from the device by writing into
> > driver's sysfs 'unbind' attribute.
> > 
> > See drivers/base/bus.c::driver_unbind().
> > 
> 
> I was completely unaware of that "feature". I hunch that many drivers
> are incapable of dealing with an unbind while they are still open.

Hmm, maybe older drivers... Anythig hotpluggable (USB, PCI, etc) should
be in a better shape because they expect to be yanked at any time.

> 
> Matter of fact, I don't see how this can EVER be safe. The driver core
> automatically calls the data_of_remove() routine while there are still
> blocked readers. This kfree()s the private data structure, which
> contains the suggested priv->exists flag. What happens if the memory
> allocator re-allocates that memory to a different driver before the
> reader process is woken up to check the priv->exists flag?
> 
> The only way to solve this is to count the number of open()s and
> close()s, and block the unbind until all users have close()d the device.
> 

Yes, you can kick readers and wait, or you can refcount that private
structure and have readers grab a reference when they open your device
and drop it in their fops->release() method. Your remove() should also
drop reference instead of doing kfree() outright.

Thanks.

-- 
Dmitry
