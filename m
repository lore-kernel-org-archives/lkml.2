Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab2KBOIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:08:47 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57501 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574Ab2KBOIo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Fri, 2 Nov 2012 10:08:44 -0400
Message-Id: <5093E22302000078000A611A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 14:09:23 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: <sqazi@google.com>, <peterz@infradead.org>, <tglx@linutronix.de>,
        <torvalds@linux-foundation.org>, <hpa@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [PATCH] x86: Don't clobber top of pt_regs in
 nested NMI
References: <20121002002919.27236.14388.stgit@dungbeetle.mtv.corp.google.com>
 <1351731872.4004.112.camel@gandalf.local.home>
 <5092D31C020000780008EB6B@nat28.tlf.novell.com>
 <1351864310.4004.130.camel@gandalf.local.home>
 <1351864429.4004.131.camel@gandalf.local.home>
In-Reply-To: <1351864429.4004.131.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.11.12 at 14:53, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-11-02 at 09:51 -0400, Steven Rostedt wrote:
>> On Thu, 2012-11-01 at 19:53 +0000, Jan Beulich wrote:
>> 
>> > There doesn't appear to be anything special about these adjustments, so I
>> > don't see what help would be required here - it ought to be the normal use
>> > of CFI_ADJUST_CFA_OFFSET that needs adding.
>> 
>> This change look fine to you?
>> 
>> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> index 52edf92..7ba5342 100644
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -1796,10 +1796,12 @@ repeat_nmi:
>>  
>>  	/* Make another copy, this one may be modified by nested NMIs */
>>  	addq $(10*8), %rsp
>> +	CFI_ADJUST_CFA_OFFSET -10*8
>>  	.rept 5
>>  	pushq_cfi -6*8(%rsp)
>>  	.endr
>>  	subq $(5*8), %rsp
>> +	CFI_ADJUST_CFA_OFFSET 5*8
>>  
>>  	CFI_DEF_CFA_OFFSET SS+8-RIP
>>  end_repeat_nmi:
>> 
> 
> Is that second one even needed? Or will the CFI_DEF_CFA_OFFSET SS+8-RIP
> fix it?

Yes it will (as long as no intervening instructions get added; that's
to say that I'd recommend removing the blank line to make clear
that instruction and annotation belong together).

Jan

