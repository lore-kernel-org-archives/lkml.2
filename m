Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0HCPpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:45:33 -0400
Received: from claw.goop.org ([74.207.240.146]:49974 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab0HCPp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:45:28 -0400
Message-ID: <4C583996.1090805@goop.org>
Date: Tue, 03 Aug 2010 08:45:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC 10/12] x86/pvticketlock: keep count of blocked cpus
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>	 <9d5625e61c7f35e72156e8cb881e55910b4fa5dc.1279328276.git.jeremy.fitzhardinge@citrix.com> <1280824360.1923.421.camel@laptop>
In-Reply-To: <1280824360.1923.421.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/03/2010 01:32 AM, Peter Zijlstra wrote:
> On Fri, 2010-07-16 at 18:03 -0700, Jeremy Fitzhardinge wrote:
>> @@ -26,6 +26,9 @@ typedef struct arch_spinlock {
>>                          __ticket_t head, tail;
>>                  } tickets;
>>          };
>> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
>> +       __ticket_t waiting;
>> +#endif
>>   } arch_spinlock_t;
> This bloats spinlock_t from u32 to u64 on most distro configs I think,
> since they'll have NR_CPUS=4096 or something large like that and
> probably also want to have this PARAVIRT_SPINLOCKS thing.

Yes, it is very unfortunate.  In principle I could make it work with a 
single bit: set it when a cpu blocks and will need kicking; clear it 
when the lock becomes uncontended again (since everything is FIFO, so if 
something blocks itself there's a good chance that everything afterwards 
will also decide to block).  But a bit takes as much space as a word 
(and it isn't obvious to me how to implement the "clearing when it 
becomes uncontended" part in a race-free way). (But see below for some 
handwaving)

I could store this out in a secondary structure, but it really needs to 
be efficient to access from the unlock fast-path (to determine whether 
it needs to do the slow-path kick), so something out of line isn't going 
to work.

Without the separate "waiting" counter, the previous code just checked 
to see if there was anyone else has a ticket on the lock.  This is too 
pessimistic, since it isn't all that uncommon to have someone else who 
has been waiting on the lock for a little while, but has not yet decided 
to block themselves, and it results in many spurious calls into the 
unlock slow path.

I was thinking of getting a bit in the ticket lock structure by stealing 
a counter bit: halve the supported number of cpus (128 for byte, 32k for 
word), add/sub 2, and use the LSB for the "needs kicking" flag.  And 
that actually gives us two bits to play with, which may be useful for 
dealing with the clearing race (perhaps can be done cleverly in the 
unlock itself, or something).  But I haven't thought this through in detail.

     J
