Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1EPTUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:20:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab1EPTUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:20:17 -0400
Date: Mon, 16 May 2011 15:19:51 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110516191951.GI31888@redhat.com>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
 <20110513124523.GM13984@redhat.com>
 <20110513130011.GA6474@elte.hu>
 <BANLkTi=Z_3MZVs2CQyk82NfvZj-KdSw5kw@mail.gmail.com>
 <20110513152033.GB3854@elte.hu>
 <20110513160029.GD31888@redhat.com>
 <20110516112934.GE19837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516112934.GE19837@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 01:29:34PM +0200, Ingo Molnar wrote:
> > Interesting.  Question though, what do you mean by 'event filtering'.  Is 
> > that different then setting 'unknown_nmi_panic' panic on the commandline or 
> > procfs?
> > 
> > Or are you suggesting something like registering another callback on the 
> > die_chain that looks for DIE_NMIUNKNOWN as the event, swallows them and 
> > implements the policy?  That way only on HEST related platforms would 
> > register them while others would keep the default of 'Dazed and confused' 
> > messages?
> 
> The idea is that "event filters", which are an existing upstream feature and 
> which can be used in rather flexible ways:
> 
>   http://lkml.org/lkml/2011/4/27/660
> 
> Could be used to trigger non-standard policy action as well - such as to panic 
> the box.
> 
> This would replace various very limited /debugfs and /sys event filtering hacks 
> (and hardcoded policies) such as arch/x86/kernel/cpu/mcheck/mce-severity.c, and 
> it would allow nonstandard behavior like 'panic the box on unknown NMIs' as 
> well.
> 
> This could be set by the RAS daemon, and it could be propagated to the kernel 
> boot line as well, where event filter syntax would look like this:
> 
>   events=nmi::unknown"if (reason == 0) panic();"

Wow. ok.  I believe that is the most complicated kernel boot param I have
ever seen. :-)  Powerful, no doubt.

So this would sorta be a meta-notifier?  I guess you are saying platforms
that implement something like HEST could setup an event like that to
trigger the behaviour they want on a per-platform basis?

My only argument against it would be sorta of what Ying complains about is
that you start to lose track of who is hooked into the NMI.  It is one
thing to search for all the users in the die_notifier to track down who is
swallowing NMIs.  But to look for event users,  is going to be harder.
Unless the events processing has a switch to turn on logging? :-)

Cheers,
Don


> 
> (Where the 'reason' field of the NMI event is the current legacy 'reason' value 
> there.)
> 
> The filter code would have to be modified to be able to recognize the panic() 
> bit, but that's desirable anyway and it is a one-time effort.
> 
> This:
> 
>   events=nmi::unknown:"if (reason == 0) ignore();"
> 
> would be a possible outcome as well, on certain boxes - to skip certain events.
> 
> Thanks,
> 
> 	Ingo
