Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab2JSRgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:36:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60945 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab2JSRgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:36:54 -0400
Date: Fri, 19 Oct 2012 10:36:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: weird use-after-free bug in module_put
Message-ID: <20121019173639.GD2152@core.coreip.homeip.net>
References: <20121019144351.GA1532@redhat.com>
 <20121019153452.GB1532@redhat.com>
 <20121019163318.GA2152@core.coreip.homeip.net>
 <20121019170951.GM2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019170951.GM2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 06:09:51PM +0100, Al Viro wrote:
> On Fri, Oct 19, 2012 at 09:33:18AM -0700, Dmitry Torokhov wrote:
> 
> > We are now removing instance of character device corresponding to input
> > device when input device disappears.
> > 
> > Ah, I know... cdev is embedded in evdev, but lives longer.. I do want to
> > keep cdev embedded as it allows me to easily get to evdev in
> > evdev_open(), but I need to be able to add and then drop reference to
> > evdev from cdev's ->release() method. This means I need to override it.
> > 
> > Or I could have cdev separately allocated, but then I'd like to have a
> > void pointer in "struct cdev" so I could get from it back to
> > corresponding evdev.
> 
> Your real problem is that you have two kobjects embedded into the same
> thing.  It can work, but you need to make the secondary (one that does
> *not* free in its ->release()) pin the primary.  Sigh...  Device model
> sucks, film at 11...

Right, but "cdev" is currently "sealed": it does not allow specifying a
custom release function from which I could unpin primary (evdev). You
are the author/owner of cdev code, so that is why I was asking for
your opinion as to what is the best way to proceed:

1. Allocate cdev separately and add void * to struct cdev so that it is
   easy to get to corresponding structure on evdev_open.

2. Keep cdev embedded in evdev but export cdev's cleanup method and
   have evdev override ->release with its own version that calls
   cdev_default_release() and then unpins evdev stucture.

3. Add struct device *parent to struct cdev and have it pin and unpin it
   for us (if it is set up).

Thanks.

-- 
Dmitry
