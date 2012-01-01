Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab2AAQRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 11:17:55 -0500
Received: from netrider.rowland.org ([192.131.102.5]:45144 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750925Ab2AAQRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 11:17:53 -0500
Date: Sun, 1 Jan 2012 11:17:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
In-Reply-To: <201201011322.34483.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1201011105200.4534-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jan 2012, Oliver Neukum wrote:

> Am Sonntag, 1. Januar 2012, 03:21:45 schrieb Alan Stern:
> > On Sat, 31 Dec 2011, Oliver Neukum wrote:
> 
> > > We are definitely going through do_unbind_rebind(). But I don't think
> > > it matters why we got there. We seem to be calling probe() too early.
> > > And we need to guarantee that a driver can request firmware in probe()
> > > 
> > > So something has changed in the resume code path further up.
> > 
> > For at least a year and a half, it has been true that rebinding takes
> 
> Yes, so I don't understand why we haven't been hitting this issue
> all that time.

Perhaps if Matthew compared logs from an old and a new system with 
appropriate debugging options configured, something might show up.

> > place during the complete phase of system resume.  Clearly that is too 
> > early to load firmware.  When do you think we should do it instead?
> 
> I think we ought to delay until right after user space is unfrozen.
> The devices are gone anyway, so we lose nothing but have the ability
> to call helpers.

That's true.  But doing it will be a nuisance.  The nice thing about 
the current situation is that the driver core automatically iterates 
over all interfaces.

> > And how should we keep track of which interfaces need rebinding?
> 
> I guess this calls for a brute force approach. We can kick khubd and have
> it walk all busses checking for  needs_binding.

Ugh.  At a minimum, let's use a different process, not khubd.

As Linus pointed out, the real problem here is the firmware loader.  
The way it is now, a driver can't always depend on the data being
available, even during a normal boot.  It ought to use an asynchronous
approach; then none of these problems would arise.

Alan Stern

