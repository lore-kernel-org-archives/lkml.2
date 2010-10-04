Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0JDWXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:23:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51409 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab0JDWXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:23:23 -0400
Message-ID: <4CAA53A2.6070703@zytor.com>
Date: Mon, 04 Oct 2010 15:22:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, Daniel Drake <dsd@laptop.org>,
        Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        Borislav Petkov <bp@alien8.de>
Subject: Re: Dynamic nop selection breaks boot on Geode LX
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>	 <20101004154633.GA2900@redhat.com>  <4CAA4C7D.8040006@zytor.com> <1286230518.6750.76.camel@gandalf.stny.rr.com>
In-Reply-To: <1286230518.6750.76.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 03:15 PM, Steven Rostedt wrote:
>>
>> We tried exactly this type of dynamic selection before, and it doesn't
>> work on broken virtualizers; in particular Microsoft VirtualPC can pass
>> the exception test and yet fail later.
> 
> So the code is broken because of broken virtualizers??
> 

Yup.  Fun, isn't it?  :(  Unfortunately, broken virtualizers appear as
broken CPUs to us.  We used to do the #UD probe for NOPL, but it didn't
work.

>>
>> The end result is very simple: you can always use NOPL on 64 bits, you
>> can never use NOPL on 32 bits.
>>
>> 66 66 66 66 90 will always *work* (as in, it will never fail) but it's
>> pretty slow on older CPUs which took a hit on handle prefixes -- but it
>> might still be faster than a jump on those.  Thus, in your code the JMP
>> case will never be reached anyway.
> 
> The jmp was there because of paranoia, and I never expected it to be
> reached.
> 
>>
>> There isn't, of course, a classic 5-byte sequence, although the sequence:
>>
>> 	2E 8D 75 26 00
>>
>> ... should work (leal %ds:0(,%esi,1),%esi).  However, 66 ... 90 is
>> likely to work better on modern processors (although I haven't measured it.)
> 
> The point is, this nop will be at _every_ function call (it replaces the
> mcount call). Not just scattered throughout the kernel. It is imperative
> that we have the best nop available.
> 
> So what would you recommend?
> 

NOPL is special, because it's the only NOP sequence that isn't actually
*supported* on all processors (and we have found that we can't even use
it on 32 bits, even though the vast majority of all real-life 32-bit
processors do support it.)

Borislav is just checking to see if we can just use NOPL unconditionally
on 64 bits; as far as 32 bits is concerned the only option for picking
what is "best" is probably to benchmark some set of sequences on the set
of processors we care about.  However, I suspect that on any modern
processors either 66 66 66 66 90 or 2E 8D 75 26 00 will work equally well.

With a bit of benchmarking I think we could adopt the policy of using
NOPL on 64 bits and one of the above sequences on 32 bits.

	-hpa


