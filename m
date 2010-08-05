Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296Ab0HENGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 09:06:37 -0400
Received: from mail.lang.hm ([64.81.33.126]:40643 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab0HENGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 09:06:34 -0400
Date: Thu, 5 Aug 2010 06:04:35 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Florian Mickler <florian@mickler.org>
cc: paulmck@linux.vnet.ibm.com,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, stern@rowland.harvard.edu, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100805075629.07d5d88d@schatten.dmk.lab>
Message-ID: <alpine.DEB.2.00.1008050556520.25170@asgard.lang.hm>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm> <20100804185520.GA2417@srcf.ucam.org> <201008042251.08266.rjw@sisk.pl> <20100804205654.GA4986@srcf.ucam.org> <alpine.DEB.2.00.1008041529530.6545@asgard.lang.hm>
 <AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com> <alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm> <20100804231003.GL24163@linux.vnet.ibm.com> <20100805073359.4cb791c0@schatten.dmk.lab> <20100805075629.07d5d88d@schatten.dmk.lab>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Florian Mickler wrote:

> On Thu, 5 Aug 2010 07:33:59 +0200
> Florian Mickler <florian@mickler.org> wrote:
>
>> On Wed, 4 Aug 2010 16:10:03 -0700
>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>
>>
>> No no. In the David-Lang-CGroup-Scheme[1](tm?) suspend-from-idle
>> is used. For idle decision a certain subset of tasks is ignored.
>>
>> Where suspend is prevented by the trusted
>> process in android-world taking a wakelock, here it would just prevent
>> the system from going idle by arming timers.
>>
>> This would be pretty equivalent to the suspend-blocker scheme and not
>> introduce new userspace api. But the downside is, as Arve pointed out,
>> that now one can not get full-idle-power-leverage while suspend
>> is blocked.
>>
>> [1] http://permalink.gmane.org/gmane.linux.kernel/1018452  and
>> following
>>
>>
>> Cheers,
>> Flo
>>
>
> There are a few downsides that got mentioned already in reponse..  I got
> a little lagged behind.
>
> There are upsides to this approach like not
> having a special purpose userspace api, conceptually integrating
> suspend into the idle mechanism ..

first off, a good summary of that I've been saying, thanks.

> Short summary of the cons that got mentioned:
>
>  -  applications need to resort to polling to keep the system
> 	out of idle (->  system will never be fully idle)

true, although the power difference between a system that is 
completelyidle (but with a wavelock held) and a system where one 
application is polling every 10 seconds or so is _really_ low.

>  -  the race between deciding to suspend and becoming active
> 	again is not handled

this one I will admit to not fully understanding, it sounds like there are 
opptions here, but I don't understand them or their trade-offs

>  -  no special statistics available

or no special statistics needed. Powertop is already avaible to analyse a 
system and report what processes are keeping it awake. Why would this not 
be enough?

>  -  the timers of the ignored applications will behave unexpected
> 	(as the monotonic clock is not stopped)... while applications
> 	have already to cope with network-loss, other side effects of
> 	suspend without monotonic clock stopped are to be expected...

I'm not sure this is true. there's nothing stopping the suspend (when it 
finally does happen) from stopping the monotonic clock. The core of my 
proposal is tweaking how we decide to suspend. Other than the possibility 
that we decide to suspend between timers (and set an alarm to wake up when 
a timer would go off) I'm not suggesting that the suspend itself change 
once it's finally triggered.

David Lang
