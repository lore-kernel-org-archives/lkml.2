Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750775Ab0CSEG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 00:06:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:54221 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab0CSEG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 00:06:56 -0400
Date: Thu, 18 Mar 2010 20:57:41 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, Larry.Finger@lwfinger.net,
       johannes@sipsolutions.net, linville@tuxdriver.com, mb@bu3sch.de,
       stable@kernel.org
Subject: Re: patch
	b43-workaround-circular-locking-in-hw-tkip-key-update-callback.patch
	added to 2.6.33-stable tree
Message-ID: <20100319035741.GC26626@suse.de>
References: <12689584343638@kroah.org> <201003190316.28515.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003190316.28515.s.L-H@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 03:16:22AM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Friday 19 March 2010, gregkh@suse.de wrote:
> > This is a note to let you know that we have just queued up the patch titled
> > 
> >     Subject: b43: Workaround circular locking in hw-tkip key update callback
> > 
> > to the 2.6.33-stable tree.  Its filename is
> [...]
> > From: Larry Finger <Larry.Finger@lwfinger.net>
> > Date: Wed, 10 Mar 2010 22:10:32 -0600
> > Subject: b43: Workaround circular locking in hw-tkip key update callback
> > To: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Michael Buesch <mb@bu3sch.de>
> > Message-ID: <4b986d38.aOKVIPS3U9/aYsOP%Larry.Finger@lwfinger.net>
> > 
> > From: Michael Buesch <mb@bu3sch.de>
> > 
> > commit 96869a39399269a776a94812e9fff3d38b47d838 upstream
> > 
> > The TKIP key update callback is called from the RX path, where the driver
> > mutex is already locked. This results in a circular locking bug.
> > Avoid this by removing the lock.
> >     
> > Johannes noted that there is a separate bug: The callback still breaks on SDIO
> > hardware, because SDIO hardware access needs to sleep, but we are not allowed
> > to sleep in the callback due to mac80211's RCU locking.
> [...]
> 
> This patch breaks compiling 2.6.33.1 + the current stable queue (and likely 
> queue-2.6.32 as well):
> 
>   CC [M]  drivers/net/wireless/b43/main.o
> drivers/net/wireless/b43/main.c: In function 'b43_op_update_tkip_key':
> drivers/net/wireless/b43/main.c:868: error: 'sta' undeclared (first use in this function)
> drivers/net/wireless/b43/main.c:868: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/b43/main.c:868: error: for each function it appears in.)
> 
> as it is based on the mac80211 API change of 
> 
> Gitweb:     http://git.kernel.org/linus/b3fbdcf49f940d0703c356441e0daf045e64e076
> Commit:     b3fbdcf49f940d0703c356441e0daf045e64e076
> Parent:     e4fca007b06165900d0e44e8d5e251376819bf5d
> Author:     Johannes Berg <johannes@sipsolutions.net>
> AuthorDate: Thu Jan 21 11:40:47 2010 +0100
> Committer:  John W. Linville <linville@tuxdriver.com>
> CommitDate: Fri Jan 22 16:08:55 2010 -0500
> 
>     mac80211: pass vif and station to update_tkip_key
>     
>     When a TKIP key is updated, we should pass the station
>     pointer instead of just the address, since drivers can
>     use that to store their own data. We also need to pass
>     the virtual interface pointer.
> 
> which also touches, besides the API mac80211 tkip handling, iwl-agn as well
> as b43.

Yeah, I backed it out right away and told the authors about it, but
didn't push the stable-queue changes out, sorry about that.

greg k-h
