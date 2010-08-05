Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342Ab0HEU1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:27:41 -0400
Received: from mail.lang.hm ([64.81.33.126]:38856 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934317Ab0HEU1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:27:34 -0400
Date: Thu, 5 Aug 2010 13:26:18 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: kevin granade <kevin.granade@gmail.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008051312220.23543@asgard.lang.hm>
References: <AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com> <alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm> <AANLkTingom2AKfMu0EbfdfLiMnHo+buy1e4=PBENf3Vi@mail.gmail.com> <alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm>
 <20100804233013.GN24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm> <20100805001716.GO24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm> <20100805004802.GP24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm> <20100805151211.GA10080@linux.vnet.ibm.com> <alpine.DEB.2.00.1008050832010.25170@asgard.lang.hm> <AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, kevin granade wrote:

> On Thu, Aug 5, 2010 at 10:46 AM,  <david@lang.hm> wrote:
>> On Thu, 5 Aug 2010, Paul E. McKenney wrote:
>>
>>> On Wed, Aug 04, 2010 at 10:18:40PM -0700, david@lang.hm wrote:
>>>>
>>>> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
>>>>>
>>>>> On Wed, Aug 04, 2010 at 05:25:53PM -0700, david@lang.hm wrote:
>>>>>>
>>>>>> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
>>>
>>> [ . . . ]
>>>
>> however, in the case of Android I think the timeouts have to end up being
>> _much_ longer. Otherwise you have the problem of loading an untrusted book
>> reader app on the device and the device suspends while you are reading the
>> page.
>>
>> currently Android works around this by having a wakelock held whenever the
>> display is on. This seems backwards to me, the display should be on because
>> the system is not suspended, not the system is prevented from suspending
>> because the display is on.
>>
>> Rather than having the display be on causing a wavelock to be held (with the
>> code that is controls the display having a timeout for how long it leaves
>> the display on), I would invert this and have the timeout be based on system
>> activity, and when it decides the system is not active, turn off the display
>> (along with other things as it suspends)
>
> IIRC, this was a major point of their (Android's) power management
> policy.  User input of any kind would reset the "display active"
> timeout, which is the primary thing keeping random untrusted
> user-facing programs from being suspended while in use.  They seemed
> to consider this to be a special case in their policy, but from the
> kernel's point of view it is just another suspend blocker being held.
>
> I'm not sure this is the best use case to look at though, because
> since it is user-facing, the timeout durations are on a different
> scale than the ones they are really worried about.  I think another
> category of use case that they are worried about is:
>
> (in suspend) -> wakeup due to network -> process network activity -> suspend
>
> or an example that has been mentioned previously:
>
> (in suspend) -> wakeup due to alarm for audio processing -> process
> batch of audio -> suspend

when you suspend the audio will shut off, so it's sleep ->wake -> sleep, 
not suspend

> In both of these cases, the display may never power on (phone might
> beep to indicate txt message or email, audio just keeps playing), so
> the magnitude of the "timeout" for suspending again should be very
> small.  Specifically, they don't want there to be a timeout at all, so
> as little time as possible time is spent out of suspend in addition to
> the time required to handle the event that caused wakeup.

it really depnds on the frequency of the wakeups.

if you get a network packet once every 5 min and need to wake to process 
it, staying awake for 20 seconds after finishing procesing is FAR more 
significant than if you get a network packet once every hour. It's not 
just the factor of 20 that simple math would indicate because the time in 
suspend eats power as well.

I don't know real numbers, so these are made up for this example

if suspend (with the cell live to receive packets) is 10ma average current 
and full power is 500ma average current

packets every 5 min with .1 sec wake time will eat ~13maH per hour

packets every 5 min with 10 second wake time will eat ~37maH per hour

packets every hour with .1 sec wake time will eat ~10maH per hour

packets every hour with 10 sec wake time will eat ~11maH per hour

so if you have frequent wakeups, staying awake 100 times as long will cut 
your battery life to 1/3 what it was before.

if your wakeups are rare, it's about a 10% hit to stay awake 100 times as 
long.

there is a lot of room for tuning the timeouts here.

David Lang
