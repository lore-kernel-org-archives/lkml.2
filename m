Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab2JPRf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:35:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:13297 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab2JPRfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:35:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,595,1344236400"; 
   d="scan'208";a="228144600"
Date: Tue, 16 Oct 2012 10:35:24 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michael Spang <spang@google.com>, linux-usb@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Michael Spang <spang@chromium.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, greno@verizon.net,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: USB keyboard backlight powering down.
Message-ID: <20121016173524.GG5378@xanatos>
References: <20121016152023.GA25506@redhat.com>
 <CAC5F_1=tiGUtWOsOQ17vEYqVxuoVuoEH_nmEZ3BoL0dsgXJn3w@mail.gmail.com>
 <20121016165436.GA5140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016165436.GA5140@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 09:54:36AM -0700, Greg Kroah-Hartman wrote:
> On Tue, Oct 16, 2012 at 12:45:56PM -0400, Michael Spang wrote:
> > On Tue, Oct 16, 2012 at 11:20 AM, Dave Jones <davej@redhat.com> wrote:
> > > Gerry (CC'd) reported a bug to us that since 3.6.1, his illuminated
> > > Logitech USB keyboard doesn't light up until he hits a key, and then
> > > it immediately powers back off, defeating the purpose of having an
> > > illumated keyboard.
> > >
> > > Looking over the 3.6.1 changelog, I see this change, which sounds
> > > like it might be responsible ?
> > >
> > > commit ee537508bdc0c00b96ac497f3d82a68f820e6182
> > > Author: Michael Spang <spang@chromium.org>
> > > Date:   Fri Sep 14 13:05:49 2012 -0400
> > >
> > >     Increase XHCI suspend timeout to 16ms
> > 
> > I don't think this is related to your problem, as this patch is in
> > suspend/resume code. It just allows the controller more time to halt.
> 
> Yeah, that looks odd.
> 
> But, (adding linux-usb@vger), I think we enabled some "put the device to
> sleep if it is idle" logic for all devices, which is what is looking
> like is happening here.  The keyboard is being told to go to sleep in
> order to save power.
> 
> We are saving more power, but it looks like the user wants to disable
> it, which makes sense for this device.
> 
> So, do we do this from within the kernel with a blacklist, or rely on
> the user knowing how to poke the proper sysfs file to turn the keyboard
> back on?

This was the udev bug I was referring to, which I think is causing the
keyboard to have auto-suspend enabled:

https://bugzilla.redhat.com/show_bug.cgi?id=825284

udev shouldn't be enabling auto-suspend of USB hids by default, since
many of them don't send a wakeup to come out of suspend when they
should.  For example, most USB mice only send a wakeup even when they
are clicked, not when they are moved.  That causes the user to sit
there, frustrated, as they move their mouse and wonder why their screen
doesn't unblank.  Other keyboards also lose keystrokes, which means if
you pause to compose your thoughts, the first couple letters you type
gets dropped.

Sarah Sharp
