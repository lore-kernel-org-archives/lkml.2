Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0E1Mb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:31:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57708 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0E1Mb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:31:26 -0400
Date: Fri, 28 May 2010 13:31:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528123110.GA23930@srcf.ucam.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk> <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org> <20100527230806.4deb6de3@lxorguk.ukuu.org.uk> <20100527220949.GB10602@srcf.ucam.org> <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk> <AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com> <20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk> <AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com> <20100528132138.2d802d77@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528132138.2d802d77@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 01:21:38PM +0100, Alan Cox wrote:

> So I put my phone down
> 
> 	The UI manager gets told the phone is 'down'
> 	Ten seconds later it is still down
            <- wakeup event that should be delivered to untrusted app arrives here

At this point you may mark the downtrodden group as ignored between the 
untrusted app receiving the event and the untrusted app marking itself 
as important. To avoid this you need the UI manager to receive every 
wakeup event in order to change its scheduling decisions.

> If I push the button we get an IRQ
> We come out of power save
> The app gets poked

(The cgroup has to have some awareness of suspend/resume so that it can 
allow the untrusted apps to be scheduled again)

> The app may be unimportant but the IRQ means we have a new timeout of
>     some form to run down to idle

The timeout-based nature means that if the application doesn't get 
scheduled for some reason (say there's heavy swap pressure - not likely 
in the embedded world, but an issue on laptop-type devices) the event 
may not be handled before you get back to sleep. I accept that this 
isn't likely to be a problem in the real world, but it does make this 
mechanism less deterministic than a suspend block based one.

> If you are absolutely utterly paranoid about it you need the button
> driver to mark the task it wakes back as important rather than rely on
> time for response like everyone else. That specific bit is uggglly but
> worst case its just a google private patch to a few drivers. I understand
> why Android wants it. The narrower the gap between 'we are doing nothing,
> sit in lowest CPU on state' and 'we are off' the better the battery life
> and the more hittable the condition.

Not just the button driver. Every driver that generates wakeupa. This 
gets difficult when it comes to the network layer, for instance, when 
the network driver has very little idea how the packet it just received 
will be routed.

> Apart from that optional paranoia case my kernel now contains some
> trivial changes of generic value that have nothing to do with suspend
> blocking. Android has suspend blocking by choosing to use the generic
> features in its own specific way and we need almost no code writing ?

The problem is that you still have a race, and fixing that race requires 
every event that could generate a wakeup to be proxied out to the policy 
manager as well. That's a moderate additional overhead.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
