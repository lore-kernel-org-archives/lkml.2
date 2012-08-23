Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2HWCO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:14:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48534 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab2HWCOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:14:52 -0400
Message-ID: <503591F9.7050506@zytor.com>
Date: Wed, 22 Aug 2012 19:14:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, JBeulich@suse.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 74/74] lto, workaround: Mark do_futex noinline to prevent
 clobbering ebp
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-75-git-send-email-andi@firstfloor.org> <503576AB.5030208@zytor.com>
In-Reply-To: <503576AB.5030208@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 05:17 PM, H. Peter Anvin wrote:
> On 08/18/2012 07:57 PM, Andi Kleen wrote:
>> From: Andi Kleen <ak@linux.intel.com>
>>
>> On a 32bit build gcc 4.7 with LTO decides to clobber the 6th argument on the
>> stack.  Unfortunately this corrupts the user EBP and leads to later crashes.
>> For now mark do_futex noinline to prevent this.
>>
>> I wish there was a generic way to handle this. Seems like a ticking time
>> bomb problem.
>>
>
> There is a generic way to handle this.  This is actually a bug in Linux
> that has been known for at least 15 years and which we keep hacking around.
>
> The right thing to do is to change head_32.S to not violate the i386
> ABI.  Arguments pushed (by value) on the stack are property of the
> callee, that is, they are volatile, so the hack of making them do double
> duty as both being saved and passed as arguments is just plain bogus.
> The problem is that it works "just well enough" that people (including
> myself) keep hacking around it with hacks like this, with assembly
> macros, and whatnot instead of fixing the root cause.
>
> 	-hpa
>

Just a clarification (Andi knows this, I'm sure, but others might not): 
this wasn't done the way it is for no reason; back when Linus originally 
wrote the code, i386 passed *all* arguments on the stack, and we still 
do that for "asmlinkage" functions on i386.  Since gcc back then rarely 
if ever mucked with the stack arguments, it made sense to make them 
"double duty."  Fixing this really should entail changing the invocation 
of system calls on i386 to use the regparm convention, which means we 
only need to push three arguments twice, rather than six.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

