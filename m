Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab0HDT5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:57:54 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51697 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab0HDT5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:57:52 -0400
Date: Wed, 4 Aug 2010 20:57:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804195723.GA3553@srcf.ucam.org>
References: <20100802011006.GS2470@linux.vnet.ibm.com> <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com> <20100803183447.0275c134@infradead.org> <20100804163216.GB24163@linux.vnet.ibm.com> <20100804163509.GA31523@srcf.ucam.org> <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm> <20100804185520.GA2417@srcf.ucam.org> <alpine.DEB.2.00.1008041207260.6545@asgard.lang.hm> <20100804192115.GA2946@srcf.ucam.org> <alpine.DEB.2.00.1008041222280.6545@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008041222280.6545@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 12:29:36PM -0700, david@lang.hm wrote:

> why would you trust it to take a wakelock, but not trust it the rest of  
> the time?

Because I trust that when the application author says "I explicitly need 
the machine to stay awake" that they mean it, whereas I don't trust the 
application author to write an application that avoids consuming 
background CPU. The distinction is pretty important.

> in my proposal I'm saying that if you would trust the application to take 
> a wakelock, you instead trust it to be sane in the rest of it's power  
> activity (avoiding polling, etc) and so you consider it for sleep  
> decisions.

When we say "trust", we're not using the same meaning as we do with 
security. Yes, it's possible that an application that can block suspend 
will do so at inopportune times. But given that blocking suspend is an 
explicit act it's much more likely that the developer will only use it 
in reasonable ways, while it's still entirely plausible that the 
application will generate unnecessary wakeups. Pretending otherwise is 
unrealistic. I recently had to fix the fact that the kernel IPMI layer 
would generate a constant 1000 wakeups a second even if it had an 
interrupt-driven controller or was entirely idle.

>> The second is that the incoming network packet causes
>> the kernel to take a wakelock that will be released once userspace has
>> processed the network packet. This ensures that at least one wakelock is
>> held for the entire relevant period of time.
>
> how do you determine that userspace has processed the network packet so  
> that the kernel can release the wakelock (or is this one of the cases  
> where there is a timer related to the wakelock)

The current implementation uses a timer, but Rafael's implementation 
should allow userspace to explicitly acknowledge it.

> two things here,
>
> on the dirty networks that I see as common, refusing to sleep if network  
> packets are arriving will mean that you never go to sleep.

Cell networks typically have no background traffic, for obvious reasons.

> secondly, nothing stops the code doing the idle/suspend decision from  
> considering network activity. I would be surprised if there weren't  
> already options to support this today.

If you proxy every potential wakeup event through some central server 
then this becomes much easier, but it's also a performance hit. The 
alternative is that you poll for network activity, but that's a power 
hit.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
