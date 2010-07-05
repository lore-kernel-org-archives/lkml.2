Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab0GEXMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 19:12:46 -0400
Received: from claw.goop.org ([74.207.240.146]:45275 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453Ab0GEXMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 19:12:45 -0400
Message-ID: <4C3266EB.9010200@goop.org>
Date: Mon, 05 Jul 2010 16:12:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jan Beulich <JBeulich@novell.com>, "mingo@elte.hu" <mingo@elte.hu>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Ky Srinivasan <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks -	 Xen
  implementation
References: <4C2A200F02000078000089E4@vpn.id2.novell.com> <4C2B1769.5090107@goop.org> <4C2B47190200007800008CB7@vpn.id2.novell.com> <4C2B4564.7030203@goop.org> <4C2BC1AB.9050500@zytor.com>
In-Reply-To: <4C2BC1AB.9050500@zytor.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 03:14 PM, H. Peter Anvin wrote:
> On 06/30/2010 06:23 AM, Jeremy Fitzhardinge wrote:
>   
>> pvops is a superset of alternative instruction patching, and are really
>> designed to serve different purposes.  There are some areas in which
>> there's some overlap, but otherwise they are distinct.  In particular,
>> alternative instructions are really only useful if you can express the
>> patch in terms of the presence or absence of a particular cpu feature. 
>> It can't do multi-way choice, and it can't do anything other than insert
>> literal instructions.  pvops patching can do multi-way, and has a
>> higher-level view of each patch site which allows it to do things like
>> generate appropraite save/restores, make inline vs call decisions, nop
>> out nop callsites, etc.
>>
>>     
> A lot of this -- in particular the multiway -- is a defect in the
> alternatives implementation and should have been addressed as such.

The pvops and asm alternatives have different design goals.  Asm
alternatives is all about replacing particular instructions with
different ones depending on the properties of the CPU.  pvops is about
inserting an ops vector in front of various OS-level interfaces to allow
alternate implementations; the patching part was a later optimisation
sprinkled on top to reduce the abstraction overhead.  The fact that
there's some similarity in mechanism is the result of convergence rather
than a desire to reinvent.

>   One
> of the biggest problems with pvops as it currently stands is that it is
> monolithic; in general we have this class of problems (static selection)
> in a *lot* more places than we're dealing with right now, and as such,
> generalizing *something* -- be it pvops or alternatives -- would be useful.
>   

Yes.  The module system might also be a candidate for making more
general (by allowing the kernel to have unbound references, and the
module system can be used to create a runtime binding).  Modules are
already arch neutral (the arch-specific bits), which is an improvement
over alternatives or pvops, but it has no notion of patching anything
beyond linker relocs (but aside from very hot-path pvops such as
interrupt enable/disable, instruction patching isn't used all that much).

> gcc 4.5 also includes a very powerful facility called "asm goto", which
> I have already used to implement static_cpu_has().  Again, that
> particular construct (unlike "asm goto" itself) doesn't support multiway.
>   

What does the fallback for older compilers look like?

    J
