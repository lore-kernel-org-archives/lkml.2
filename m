Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031087Ab2I1TUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:20:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33176 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030614Ab2I1TUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:20:05 -0400
Date: Fri, 28 Sep 2012 15:20:14 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] uio: uio_pruss: port to AM33xx
Message-ID: <20120928192014.GH5641@beef>
References: <1348667071-12631-1-git-send-email-mporter@ti.com>
 <1348667071-12631-2-git-send-email-mporter@ti.com>
 <20120926211019.GB16674@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926211019.GB16674@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 02:10:19PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Sep 26, 2012 at 09:44:29AM -0400, Matt Porter wrote:
> > Add ifdefery hacks to only use SRAM on Davinci. This
> > needs to be cleaned up with a sane generic SRAM allocator
> > (like the DT based driver available that can't be used on
> > Davinci which is just starting DT conversion) before it
> > can go upstream.
> > 
> > Adds DT, pinctrl, and runtime PM support for use on
> > AM33xx.
> 
> Ick, that's really messy, no other way to do this in a "cleaner"
> fashion?

There is, I had to untangle some ugly history on the SRAM situation
first.

First, and what I found humorous is that this driver is completely
dead code in the tree...a driver to nowhere. It's not hooked up at all
for DA850, no platform devices, no clock support, and to top it off the
private SRAM API it's calling uses the ARM local SRAM that the PRU can't
even access it [1]. So it's completely broken and one possible course
of action is to just say tough luck to Davinci and remove all that SRAM
code. I happen to care a bit about DA850 as I have the AM180x variant
here...

I noticed that previous attempts at consolidating SRAM allocation failed
to achieve consensus [2] or in the case of when Jean added the phys
support to genalloc the associated mach-davinci/ support was never
picked up [3]. The patch in to enable L3 RAM support [1] depended
on the genalloc conversion and all appears to have been forgotten and
bitrotted since then.

I decided to go ahead and add a genalloc pool for the L3 RAM (shared
sram) on DA850 that PRU can use and strip out the private API. I'll
post v2 with that supports that supports both platforms cleanly.

-Matt

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2011-June/051609.html

[2] https://patchwork.kernel.org/patch/710741/

[3]
http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/057293.html

