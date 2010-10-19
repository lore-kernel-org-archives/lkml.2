Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab0JSVjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:39:04 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:7018 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab0JSVjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:39:02 -0400
Message-ID: <4CBE0FEB.3070104@caviumnetworks.com>
Date: Tue, 19 Oct 2010 14:38:51 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
References: <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com> <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6> <20101019132236.GA19197@Krystal> <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6> <1287496495.16971.372.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6> <20101019142820.GA14520@Krystal> <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6> <4CBE0AC6.3040402@caviumnetworks.com> <20101019213225.GB2855@redhat.com>
In-Reply-To: <20101019213225.GB2855@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2010 21:39:17.0276 (UTC) FILETIME=[14CB8DC0:01CB6FD6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 02:32 PM, Jason Baron wrote:
> On Tue, Oct 19, 2010 at 02:16:54PM -0700, David Daney wrote:
>> On 10/19/2010 12:49 PM, Thomas Gleixner wrote:
>> [...]
>>> So that saves _TWO_ bytes of text and replaces:
>>>
>>> -  1e:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0(%rip)        # 25<test+0x25>
>>> -  25:	74 4d                	je     74<test+0x74>
>>> +  1e:	e9 00 00 00 00       	jmpq   23<test+0x23>
>>> +  23:	eb 4d                	jmp    72<test+0x72>
>>>
>>> So it trades a conditional vs. two jumps ? WTF ??
>>>
>>> I thought that jumplabel magic was supposed to get rid of the jump
>>> over the tracing code ? In fact it adds another jump. Whatfor ?
>>
>> The 'asm goto' construct in GCC-4.5 is deficient in this area.
>>
>> GCC assumes that all exit paths from an 'asm goto' are equally
>> likely, so the tracing (or dynamic printk etc.) code is assumed to
>> be hot and is emitted inline.  Since they are inline like this,
>> there are all these jumps around them and they pollute the I-Cache.
>>
>> I was looking at fixing it, but I think a true general purpose fix
>> would require enhancing GCC's grammar to allow specifying of the
>> 'likelyness' of each exit path from 'asm goto'.
>>
>> David Daney
>>
>
> right, the next step is adding support for hot/cold labels, so the
> tracing code will be annotaed with a 'cold' label. Thus, not adding the
> 'jmp' above on line '23', and in fact moving the tracing code
> out-of-line. Maybe I haven't been clear on this.
>

Ok, so is anybody working on doing that?  GCC-4.6 stage 1 (the time when 
a change like this could be merged) closes in 8 days.

It is unfortunate that we have this shiny new feature that can't really 
be used because the infrastructure is only half baked.

David Daney
