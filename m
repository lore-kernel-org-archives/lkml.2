Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab1HKQps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 12:45:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:18790 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab1HKQpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 12:45:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="37576730"
Date: Thu, 11 Aug 2011 09:45:39 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Florian Mickler <florian@mickler.org>,
        Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, pedrib@gmail.com,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
Message-ID: <20110811164539.GB5884@xanatos>
References: <Pine.LNX.4.44L0.1108101025250.1917-100000@iolanthe.rowland.org>
 <4E42A4AE.4020008@gmail.com>
 <20110810231552.GA7194@xanatos>
 <CACTFLAP9eRG6TVtFsNGO+oDu0U0gOUth-_TzLeW2yGb6Jxn2tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACTFLAP9eRG6TVtFsNGO+oDu0U0gOUth-_TzLeW2yGb6Jxn2tA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 02:57:41AM +0200, Daniel Mack wrote:
> On Thu, Aug 11, 2011 at 1:15 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> > On Wed, Aug 10, 2011 at 05:33:02PM +0200, Daniel Mack wrote:
> >> On 08/10/2011 04:32 PM, Alan Stern wrote:
> >> >Looking at the driver's current code, it appears that your patch
> >> >does not fix the bug properly.  Using discontiguous regions in the
> >> >transfer buffer is perfectly okay.  The real problem is later on,
> >> >where you do:
> >> >
> >> >if (send_it) { out->number_of_packets = FRAMES_PER_URB;
> >> >
> >> >This should be
> >> >
> >> >out->number_of_packets = outframe;
> >> >
> >> >The way it is now, the USB stack will try to use data from all the
> >> >frame descriptors, and the last few will be stale because the loop
> >> >doesn't set them.
> >>
> >> That's actually true, even though it doesn't seem to cause any trouble.
> >> I tested everything here of course, and the output URBs return back from
> >> the USB stack with their length fields zeroed out, which then
> >> causes the stack to send packets with zero-length fields at the end.
> >
> > Actually, it causes system hangs when the driver is loaded on a device
> > attached to a USB 3.0 port, as Alan Stern pointed out:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=40702
> 
> Yes, I've noticed this.
> 
> > Please don't submit zero-length transfers.  The xHCI driver just isn't
> > able to handle it.  Arguably, it probably should have just rejected your
> > URB when it found a zero length buffer, so I'll probably be submitting a
> > patch to fix that.
> 
> According to the spec, sending zero-length frames should be fine, no?
> Is there any particular reason why XCHI can't handle this while EHCI
> can? And does my patch fix the driver for XHCI?

Ok, yes, you're correct that the xHCI spec allows the transfer length to
be set to zero.  In the case where the frame buffer is zero-length, is
the buffer pointer still valid?  It's not clear from the spec whether it
needs to be.

Sarah Sharp
