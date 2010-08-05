Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607Ab0HEOfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:35:32 -0400
Received: from mail.lang.hm ([64.81.33.126]:45770 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756867Ab0HEOfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:35:30 -0400
Date: Thu, 5 Aug 2010 07:34:55 -0700 (PDT)
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
In-Reply-To: <20100805133811.GA20565@srcf.ucam.org>
Message-ID: <alpine.DEB.2.00.1008050724110.25170@asgard.lang.hm>
References: <20100803183447.0275c134@infradead.org> <20100804163216.GB24163@linux.vnet.ibm.com> <20100804163509.GA31523@srcf.ucam.org> <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm> <20100804185520.GA2417@srcf.ucam.org> <alpine.DEB.2.00.1008041207260.6545@asgard.lang.hm>
 <20100804192115.GA2946@srcf.ucam.org> <alpine.DEB.2.00.1008041222280.6545@asgard.lang.hm> <20100804195723.GA3553@srcf.ucam.org> <alpine.DEB.2.00.1008041508040.6545@asgard.lang.hm> <20100805133811.GA20565@srcf.ucam.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Matthew Garrett wrote:

> On Wed, Aug 04, 2010 at 03:20:04PM -0700, david@lang.hm wrote:
>
>> similar to the current implementation, the arrival of a packet could be
>> counted as activity that keeps the system awake for a bit (your timeout)
>
> How? You're either polling in order to know whether there's network
> activity, or you're having every network packet wake up the policy
> daemon, or you've got something that looks like the kernel side of
> wakelocks.

infrequent polling (on the order of seconds or 10s of seconds) is not a 
very significant impact on your power

>>> Cell networks typically have no background traffic, for obvious reasons.
>>
>> but don't most new smartphones also connect up to wifi networks? those
>> are FAR from quiet.
>
> Wifi radio typically dwarfs your other power consumption anyway. The
> typical situation is one where you're not attached to a wifi network.

on some devices (my kindle for example) the cell network dwarfs my other 
power consumption today.

>> I'm not suggesting running all events through some central server (unless
>> you count the kernel as that server),  I'm saying that the decision that
>> the system is idle and therefor can be stopped should be able to take
>> this infomation into account, and if there's a race here, it should be a
>> race that exists everywhere else, so there should be a general solution,
>> not something specific to one use-case. (and definantly not something
>> that requires all software to be modified and trusted to implement)
>
> You're right. It's a race that exists everywhere else, and it's inherent
> unless you have some handshaking between userspace and the kernel when
> entering suspend. Which is what wakelocks provide. Nobody has proposed a
> solution that works without modifying existing code.

I think the issue is confusion between the different purposes of the 
wakelock.

as you say, I don't think anyone is opposed to the kernel being modified 
to eliminate this race. The disagreement is far more about the interface 
to userspace and userspace use of wakelocks.

the kernel implementation of this doesn't have to set a single flag, and 
it doesn't have to notify userspace directly. The kernel already produces 
many stats today and it may be appropriate for the kernel to produce some 
more.

for example, if you want to abort the suspend because there is network 
activity, you can check the packet count of your network interface, decide 
to go to sleep, setup the network interface to raise a 'wake me up' 
interrupt (because you have decided in a userspace policy that you want 
this), and then check to see if the packet count has changed. If it has, 
abort the suspend, if not continue the suspend and once you are suspended 
if the 'wake me up' interrupt is set you will wake back up.

there are probably cleaner/better ways of doing this than the simple logic 
that I'm listing, but why wouldn't the simple logic provide the correct 
result?

David Lang
