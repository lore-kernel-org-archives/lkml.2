Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2AFMao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:30:44 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:38933 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2AFMam convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 6 Jan 2012 07:30:42 -0500
Message-Id: <4F06F7BA020000780006ACEB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jan 2012 12:31:38 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: fix memset() to support sizes of 4Gb and
 above
References: <4F05D992020000780006AA09@nat28.tlf.novell.com>
 <20120106110519.GA32673@elte.hu>
In-Reply-To: <20120106110519.GA32673@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.01.12 at 12:05, Ingo Molnar <mingo@elte.hu> wrote:

> * Jan Beulich <JBeulich@suse.com> wrote:
> 
>> While currently there doesn't appear to be any reachable 
>> in-tree case where such large memory blocks may be passed to 
>> memset() (alloc_bootmem() being the primary non-reachable one, 
>> as it gets called with suitably large sizes in FLATMEM 
>> configurations), we have recently hit the problem a second 
>> time in our Xen kernels. Rather than working around it a 
>> second time, prevent others from falling into the same trap by 
>> fixing this long standing limitation.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> Have you checked the before/after size of the hotpath?
> 
> The patch suggests that it got shorter by 3 instructions:
> 
>> -	movl %edx,%r8d
>> -	andl $7,%r8d
>> -	movl %edx,%ecx
>> -	shrl $3,%ecx
>> +	movq %rdx,%rcx
>> +	andl $7,%edx
>> +	shrq $3,%rcx
> 
> [...]
> 
>>  	movq %rdi,%r10
>> -	movq %rdx,%r11
>>  
> 
> [...]
> 
>> -	movl	%r11d,%ecx
>> -	andl	$7,%ecx
>> +	andl	$7,%edx
> 
> Is that quick impression correct? I have not tried building or 
> measuring it.

Yes, that's correct.

As the bodies of the individual flavors didn't change, I see no risk in
this change causing any performance degradation.

> Would be nice to add support for arch/x86/lib/memset_64.S as 
> well, and look at the before/after performance of it. In 
> userspace we can do a lot more accurate measurements of this 
> kind:

I'll see whether I can get this done, but I admit that I'm entirely
unfamiliar with this tool and its infrastructure. I hope doing this is
not going to be a requirement for acceptance of the patch.

Jan

