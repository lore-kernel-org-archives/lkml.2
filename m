Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2CLNQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:16:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2CLNQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:16:45 -0400
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=t3ItOyjDxu0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=07d9gI8wAAAA:8 a=77YXAFGNYuIo_B8YtMkA:9 a=EHNl2bILt28oZ-1vjfgA:7 a=PUjeQqilurYA:10 a=E0bBuYeeou6kinzm:21 a=M_foyR2UBCb-6U10:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331558201.25686.629.camel@gandalf.stny.rr.com>
Subject: Re: recent x86-64 nested NMI adjustments
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Date: Mon, 12 Mar 2012 09:16:41 -0400
In-Reply-To: <4F5DF5C30200007800077A5B@nat28.tlf.novell.com>
References: <4F5DF5C30200007800077A5B@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 12:10 +0000, Jan Beulich wrote:
> Hi Steven,
> 
> the explanation of 45d5a1683c04be28abdf5c04c27b1417e0374486
> seems bogus to me: When arriving from user mode, %rsp won't point
> to the user stack anymore, as it gets switched away from during the
> processing of the exception (the more that the IDT entry specifies a
> separate stack anyway, which even guarantees this for kernel mode
> entries).

No it is real, and I had a test program that exploited it. I'm not
worried about the current %rsp, I'm worried about what %rsp is saved on
the stack. Two things are used to check if the incoming NMI is nested or
not.

1) if the on-stack "in-nmi" variable is set

2) if the saved %rsp is pointing to the NMI stack.

Note, #2 looks at the *saved* %rsp. Which is the %rsp at the time the
NMI triggered. The second check is used to handle the case that a nested
NMI came in after the previous NMI cleared the on-stack "in-nmi"
variable, but before it calls the iret.

There are few cases that the stack can change in the NMI so the variable
is also used.

There's a really good article on LWN about this :-)

https://lwn.net/Articles/484932/ 

 (subscription required, but you should have one)

That said, I added a printk into the boot up to show me where the NMI
stacks were located. Then I wrote a program that would pin itself to a
CPU and change its stack pointer to point into the NMI stack of that CPU
and then go into an infinite loop. I ran perf on this code and it became
"invisible" to perf. That is, every time the NMI came in while this code
was running, it incorrectly considered itself a nested NMI and returned,
never recording the presence of this program.

After adding this patch, perf shows the task spending 99.9% of the time
in this loop. Thus this is a real bug.


> 
> Further, a38449ef596b345e13a8f9b7d5cd9fedb8fcf921 makes the
> (presumably superfluous) compare a 4-byte one, while the
> documentation isn't really stating that selectors get pushed zero-
> extended. Hence, if not reverting the first change altogether, I'd
> minimally recommend converting the compare to a 2-byte one.

I'll let H. Peter answer this one, he's the Intel representative here.


-- Steve


