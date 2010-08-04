Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab0HDTR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:17:27 -0400
Received: from mail.lang.hm ([64.81.33.126]:58081 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306Ab0HDTR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:17:26 -0400
Date: Wed, 4 Aug 2010 12:15:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100804185520.GA2417@srcf.ucam.org>
Message-ID: <alpine.DEB.2.00.1008041207260.6545@asgard.lang.hm>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <20100731230101.7cc1d8c7@infradead.org> <20100801191228.GL2470@linux.vnet.ibm.com> <20100801154708.19817b75@infradead.org> <20100802011006.GS2470@linux.vnet.ibm.com> <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
 <20100803183447.0275c134@infradead.org> <20100804163216.GB24163@linux.vnet.ibm.com> <20100804163509.GA31523@srcf.ucam.org> <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm> <20100804185520.GA2417@srcf.ucam.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Matthew Garrett wrote:

> On Wed, Aug 04, 2010 at 11:30:44AM -0700, david@lang.hm wrote:
>> a couple days ago I made the suggestion to put non-privilaged tasks in a
>> cgroup so that the idle/suspend decision code could ignore acitivity
>> caused by this cgroup.
>>
>> in the second version wakeup events would be 'activity' that would be
>> counted and therefor the system would not be idle. As for the race with
>> suspending and new things happening, wouldn't that be handled the same
>> way that it is in a normal linux box?
>
> No! And that's precisely the issue. Android's existing behaviour could
> be entirely implemented in the form of binary that manually triggers
> suspend when (a) the screen is off and (b) no userspace applications
> have indicated that the system shouldn't sleep, except for the wakeup
> event race. Imagine the following:
>
> 1) The policy timeout is about to expire. No applications are holding
> wakelocks. The system will suspend providing nothing takes a wakelock.
> 2) A network packet arrives indicating an incoming SIP call
> 3) The VOIP application takes a wakelock and prevents the phone from
> suspending while the call is in progress
>
> What stops the system going to sleep between (2) and (3)? cgroups don't,
> because the voip app is an otherwise untrusted application that you've
> just told the scheduler to ignore.

Even in the current implementation (wakelocks), Since the VOIP application 
isn't allowed to take a wakelock, wouldn't the system go to sleep 
immediatly anyway, even if the application gets the packet and starts the 
call? What would ever raise the wakelock to keep the phone from sleeping 
in the middle of the call?

as I said last night in an e-mail to Arve

> it's possible that I'm making false assumptions about how quickly you 
> want to go into full suspend mode.
>
> if a user is doing nothing that would warrent wakelocks, but has an 
> unprivilaged application running (a dancing cows game), and is doing 
> nothing other than occasionally hitting a button, how short is the 
> timeout that you would set that would have the system go into suspend? 
> (i.e. how frequently must the user do something to keep the system 
> awake)
>
> or let's use a better example, the user has an unprivilaged book-reader 
> application, how quickly must they change pages to prevent the system 
> from suspending?
>
> I'm figuring that these times are in the 1-5 minute range.
>
> therefor the timeout period I am mentioning above could easily be one 
> wakeup every 40-50 seconds. that is not going to kill your idle power.
>
> is my assumption about the length of the timeout incorrect?

David Lang
