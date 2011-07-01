Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1GAUII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 16:08:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:12178 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab1GAUIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 16:08:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,460,1304319600"; 
   d="scan'208";a="20675585"
Date: Fri, 1 Jul 2011 13:08:00 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <e.a.b.piel@tudelft.nl>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.0-rc5+ : khubd blocked
Message-ID: <20110701200800.GB17865@xanatos>
References: <yv9k2yk6fasx2kndcq3elqvq.1309537225091@email.android.com>
 <Pine.LNX.4.44L0.1107011317250.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1107011317250.1988-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 01:19:23PM -0400, Alan Stern wrote:
> On Fri, 1 Jul 2011, [ISO-8859-1] ?ric Piel wrote:
> 
> > Sorry, but from a quick look, it seems to not fix the bug.
> > 
> > I'll try further on Monday.
> 
> Do you get a similar message from the task watchdog?  The patch should 
> have caused usb_set_interface() to return early, without trying to 
> acquire the mutex that caused the problem before.

I've been able to reproduce this bug with linus/master.  When I apply
your patch (or at least change the code to match your patch, since I
don't have those top-level directories), I can successfully unplug and
replug in a hub with a keyboard and mouse attached to it, with no hangs.
So I'm not sure why it isn't working for Éric.

One further complication of the original patch is that when the xHCI
driver is unloaded, usb_disable_device is called for devices under the
USB 2.0 split rootub after the USB 3.0 roothub has been unregistered and
the xHCI host is halted.  The configure endpoint code doesn't actually
check if the hardware is running before submitting commands, so it takes
about 30 seconds for the command for each device to timeout.  So that
needs to be fixed as well.

Do you mind if I just take your patch and make a proper fix out of it?

Sarah Sharp
