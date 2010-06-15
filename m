Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0FOHJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:09:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab0FOHJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:09:42 -0400
Message-ID: <4C1726C4.8050300@redhat.com>
Date: Tue, 15 Jun 2010 10:07:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: balbir@linux.vnet.ibm.com, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>	 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>	 <4C10B3AF.7020908@redhat.com> <20100610142512.GB5191@balbir.in.ibm.com>	 <1276214852.6437.1427.camel@nimitz>	 <20100611045600.GE5191@balbir.in.ibm.com> <4C15E3C8.20407@redhat.com>	 <20100614084810.GT5191@balbir.in.ibm.com> <4C16233C.1040108@redhat.com>	 <20100614125010.GU5191@balbir.in.ibm.com> <4C162846.7030303@redhat.com>	 <1276529596.6437.7216.camel@nimitz> <4C164E63.2020204@redhat.com>	 <1276530932.6437.7259.camel@nimitz>  <4C1659F8.3090300@redhat.com> <1276538293.6437.7528.camel@nimitz>
In-Reply-To: <1276538293.6437.7528.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 08:58 PM, Dave Hansen wrote:
> On Mon, 2010-06-14 at 19:34 +0300, Avi Kivity wrote:
>    
>>> Again, this is useless when ballooning is being used.  But, I'm thinking
>>> of a more general mechanism to force the system to both have MemFree
>>> _and_ be acting as if it is under memory pressure.
>>>
>>>        
>> If there is no memory pressure on the host, there is no reason for the
>> guest to pretend it is under pressure.
>>      
> I can think of quite a few places where this would be beneficial.
>
> Ballooning is dangerous.  I've OOMed quite a few guests by
> over-ballooning them.  Anything that's voluntary like this is safer than
> things imposed by the host, although you do trade of effectiveness.
>    

That's a bug that needs to be fixed.  Eventually the host will come 
under pressure and will balloon the guest.  If that kills the guest, the 
ballooning is not effective as a host memory management technique.

Trying to defer ballooning by voluntarily dropping cache is simply 
trying to defer being bitten by the bug.

> If all the guests do this, then it leaves that much more free memory on
> the host, which can be used flexibly for extra host page cache, new
> guests, etc...

If the host detects lots of pagecache misses it can balloon guests 
down.  If pagecache is quiet, why change anything?

If the host wants to start new guests, it can balloon guests down.  If 
no new guests are wanted, why change anything?

etc...

> A system in this state where everyone is proactively
> keeping their footprints down is more likely to be able to handle load
> spikes.

That is true.  But from the guest's point of view, voluntarily giving up 
memory means dropping the guest's cushion vs load spikes.

> Reclaim is an expensive, costly activity, and this ensures that
> we don't have to do that when we're busy doing other things like
> handling load spikes.

The guest doesn't want to reclaim memory from the host when it's under a 
load spike either.

> This was one of the concepts behind CMM2: reduce
> the overhead during peak periods.
>    

Ah, but CMM2 actually reduced work being done by sharing information 
between guest and host.

> It's also handy for planning.  Guests exhibiting this behavior will
> _act_ as if they're under pressure.  That's a good thing to approximate
> how a guest will act when it _is_ under pressure.
>    

If a guest acts as if it is under pressure, then it will be slower and 
consume more cpu.  Bad for both guest and host.

>> If there is memory pressure on
>> the host, it should share the pain among its guests by applying the
>> balloon.  So I don't think voluntarily dropping cache is a good direction.
>>      
> I think we're trying to consider things slightly outside of ballooning
> at this point.  If ballooning was the end-all solution, I'm fairly sure
> Balbir wouldn't be looking at this stuff.  Just trying to keep options
> open. :)
>    

I see this as an extension to ballooning - perhaps I'm missing the big 
picture.  I would dearly love to have CMM2 where decisions are made on a 
per-page basis instead of using heuristics.

-- 
error compiling committee.c: too many arguments to function

