Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0FNUVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:21:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47943 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab0FNUVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:21:14 -0400
Date: Mon, 14 Jun 2010 22:21:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nils Carlson <nils.carlson@ludd.ltu.se>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100614202109.GD369@basil.fritz.box>
References: <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com> <20100518191802.GG25224@aftab> <m1k4r0c0y7.fsf@fess.ebiederm.org> <20100518222832.GJ22675@basil.fritz.box> <m1wrv0zo9q.fsf@fess.ebiederm.org> <20100519064619.GA30320@aftab> <20100519070919.GA9618@elte.hu> <50689ECC-A371-4923-BEBE-1A5A7E5B9D3B@ludd.ltu.se> <20100614114906.GG17092@basil.fritz.box> <9D5E19B6-5313-43B4-9C3D-493C8C226E8D@ludd.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9D5E19B6-5313-43B4-9C3D-493C8C226E8D@ludd.ltu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 09:47:33PM +0200, Nils Carlson wrote:
>> Also the biggest problem is still that EDAC doesn't
>> give you any silk screen labels, so unless you
>> have motherboard schemantics the layout it presents
>> is fairly useless -- you still don't know which DIMM
>> to exchange. So in theory EDAC looks great, but in practice ...
>>
> I do have motherboard schematics, or rather, we build our own
> boards. But the point is valid, a lot of people don't make their own

Just supply correct DMI tables then?

> hardware. On the other hand, the people who do use this part of
> EDAC perhaps aren't your typical home computer users?

Most users do not build their own boards and do not have
schemantics. And that's not home computer users.

Anyways I think important is that by default you get something
useful (including silk screen labels) without doing 
any special configuration steps.

Right now DMI is the only sane option for this that I can see.
EDAC doesn't do it because it has no silk screen labels.

And yes if someone is a power user they could still override
that. Just by default it has to do something reasonable.

>
> This is true, and this is the way things are going on
> our end as well. I guess that would mean
> So you wouldn't go to the EDAC sysfs directory
> to find everything to do with the same piece of hardware
> anymore, but would have to go the n different
> directories looking for all the pieces? I don't really
> like that...

Let me try to understand that.

You want to inject errors on a random computer you don't
know anything about? Do you do that frequently? Why
are you doing this? 

Obviously there needs to be a way to identify to what
hardware an error injector belongs.

>
>> Anyways the old EDAC drivers for this are not going
>> away, you can still use them. The interesting
>> question though is how to properly define the interface
>> for new hardware.
>
> But all new hardware will look the way the hardware
> designers want it to, so our interface will be a moving
> target? Maybe it's time to let hardware makers provide

You can define relatively abstract interfaces.

It's just that EDAC is not it. They may not be perfect
future proof (after all who knows how memories of quantum
computers or whatever will look like), but hopefully
at least reasonably forward looking.

e.g. for memory layout imho a reasonable way
is to just define it as

DIMM  (if you need below that look at a log) 
 \-------- silk screen label (most important attribute!)
 |
abstract path. This can be an arbitary string. e.g. MC0/Ch1/DIMM0
 |             Or MC0/BOB0/Ch1/DIMM3
 |             Parsers don't need to know any details about it.
 |
socket

You can event represent that as a flat data structure,
no need to really map the abstract path to directories
(that just makes parsers difficult to write -- most sysfs
parsers traditionally have trouble with varying directories)



> a board specification with device tree and memory
> layout? (Pure speculation)

That's DMI on x86! 

Well it's not perfect, but also not too bad.


> There is a use-case. A lot has to do with how different patrol
> scrub rates work, some just go through memory at a constant
> speed (MB/s), others vary according to load. The thing is,
> different applications want their memory scrubbed within
> different time frames, and as the amount of memory on boards

What's the theory behind varying scrub rates? 
I would be interested in more details.

> Patrol scrubbing is normally used because it discovers errors
> faster in seldom accessed memory allowing a DIMM with
> too many errors to be replaced faster. Some applications

Yes, but why do you want to vary the rate?
Normally it should just depend on memory size and expected
error rate (that is the more memory the faster you scrub) 

> like to use demand scrubbing as well, and some consider
> it to increase memory latency too much.

That sounds odd -- if you have so many errors that you worry
about that you have other problems definitely? 
Is this based on some benchmarking?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
