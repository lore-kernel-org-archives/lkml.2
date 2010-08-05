Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760487Ab0HENjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 09:39:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38138 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760465Ab0HENjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 09:39:03 -0400
Date: Thu, 5 Aug 2010 14:38:11 +0100
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
Message-ID: <20100805133811.GA20565@srcf.ucam.org>
References: <20100803183447.0275c134@infradead.org> <20100804163216.GB24163@linux.vnet.ibm.com> <20100804163509.GA31523@srcf.ucam.org> <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm> <20100804185520.GA2417@srcf.ucam.org> <alpine.DEB.2.00.1008041207260.6545@asgard.lang.hm> <20100804192115.GA2946@srcf.ucam.org> <alpine.DEB.2.00.1008041222280.6545@asgard.lang.hm> <20100804195723.GA3553@srcf.ucam.org> <alpine.DEB.2.00.1008041508040.6545@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008041508040.6545@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 03:20:04PM -0700, david@lang.hm wrote:

> on the other hand, making an application avoid consuming inappropriate  
> background resources helps everywhere. an explicit "don't let the machine 
> sleep" only works if you are trusted by a system that implements this  
> flag.
>
> yes, it is painful to make the change, but the end result is better (and  
> there are more tools out there to figure things out)

Nobody's denying that it's better, but people are saying they want to 
design a platform that's capable of handling the software we have rather 
than the software we'd like to have.

> but if you have an application in the mid-level trust situation, go ahead 
> and have it talk to a 'keepalive' daemon that is in the 'trusted' set and 
> let the rest of the app run untrusted. As I noted elsewhere, the 
> keepalive daemon would need very little in the way of resources and can 
> implement much more complex policies than anyone is going to be willing 
> to put in the kernel.

That doesn't work. You'll race with wakeup events.

> similar to the current implementation, the arrival of a packet could be  
> counted as activity that keeps the system awake for a bit (your timeout)

How? You're either polling in order to know whether there's network 
activity, or you're having every network packet wake up the policy 
daemon, or you've got something that looks like the kernel side of 
wakelocks.

>> Cell networks typically have no background traffic, for obvious reasons.
>
> but don't most new smartphones also connect up to wifi networks? those 
> are FAR from quiet.

Wifi radio typically dwarfs your other power consumption anyway. The 
typical situation is one where you're not attached to a wifi network.

> I'm not suggesting running all events through some central server (unless 
> you count the kernel as that server),  I'm saying that the decision that  
> the system is idle and therefor can be stopped should be able to take 
> this infomation into account, and if there's a race here, it should be a 
> race that exists everywhere else, so there should be a general solution, 
> not something specific to one use-case. (and definantly not something 
> that requires all software to be modified and trusted to implement)

You're right. It's a race that exists everywhere else, and it's inherent 
unless you have some handshaking between userspace and the kernel when 
entering suspend. Which is what wakelocks provide. Nobody has proposed a 
solution that works without modifying existing code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
