Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613Ab0HDTVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:21:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51816 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab0HDTVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:21:37 -0400
Date: Wed, 4 Aug 2010 20:21:15 +0100
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
Message-ID: <20100804192115.GA2946@srcf.ucam.org>
References: <20100801191228.GL2470@linux.vnet.ibm.com> <20100801154708.19817b75@infradead.org> <20100802011006.GS2470@linux.vnet.ibm.com> <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com> <20100803183447.0275c134@infradead.org> <20100804163216.GB24163@linux.vnet.ibm.com> <20100804163509.GA31523@srcf.ucam.org> <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm> <20100804185520.GA2417@srcf.ucam.org> <alpine.DEB.2.00.1008041207260.6545@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008041207260.6545@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 12:15:59PM -0700, david@lang.hm wrote:
> On Wed, 4 Aug 2010, Matthew Garrett wrote:
>> No! And that's precisely the issue. Android's existing behaviour could
>> be entirely implemented in the form of binary that manually triggers
>> suspend when (a) the screen is off and (b) no userspace applications
>> have indicated that the system shouldn't sleep, except for the wakeup
>> event race. Imagine the following:
>>
>> 1) The policy timeout is about to expire. No applications are holding
>> wakelocks. The system will suspend providing nothing takes a wakelock.
>> 2) A network packet arrives indicating an incoming SIP call
>> 3) The VOIP application takes a wakelock and prevents the phone from
>> suspending while the call is in progress
>>
>> What stops the system going to sleep between (2) and (3)? cgroups don't,
>> because the voip app is an otherwise untrusted application that you've
>> just told the scheduler to ignore.
>
> Even in the current implementation (wakelocks), Since the VOIP 
> application isn't allowed to take a wakelock, wouldn't the system go to 
> sleep immediatly anyway, even if the application gets the packet and 
> starts the call? What would ever raise the wakelock to keep the phone 
> from sleeping in the middle of the call?

There's two parts of that. The first is that the voip application is 
allowed to take a wakelock - but that doesn't mean that you trust it the 
rest of the time.The second is that the incoming network packet causes 
the kernel to take a wakelock that will be released once userspace has 
processed the network packet. This ensures that at least one wakelock is 
held for the entire relevant period of time.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
