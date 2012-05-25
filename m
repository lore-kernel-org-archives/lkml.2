Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab2EYBjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 21:39:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22063 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab2EYBjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 21:39:24 -0400
X-Authority-Analysis: v=2.0 cv=PqgRnnw3 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=irseqbIK9hsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=nAdh4h428hE8ZYXE7NAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337909963.13348.232.camel@gandalf.stny.rr.com>
Subject: Re: tracing ring_buffer_resize oops.
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Thu, 24 May 2012 21:39:23 -0400
In-Reply-To: <4FBEC9E6.8040301@linux.intel.com>
References: <20120524160146.GA6226@redhat.com>
	  <1337876398.13348.178.camel@gandalf.stny.rr.com>
	  <20120524172223.GA10689@redhat.com>
	 <1337902816.13348.224.camel@gandalf.stny.rr.com>
	 <4FBEC9E6.8040301@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 16:53 -0700, H. Peter Anvin wrote:

> Much more fundamentally, RIP should never leave the range [-2G, 0).
> What is happening here is almost certainly that we jump through
> something which isn't a function pointer.
> 
> The other thing worth noting is that the code segment is not the
> standard Linux code segment, not even close; it *also* doesn't look like
> the typical Xen code segment.  This makes be believe that we did an IRET
> with the stack pointer set to something other than a valid interrupt
> stack frame.

I was thinking the same. But not from an NMI. Seems it may be a
breakpoint IRET that is the issue. Could also be a nesting issue with
the stack, as breakpoints have a single stack as well.

I may modify the code a little to see if I can trigger it on a normal
config. Right now, I can only trigger it with an allmodconfig. That may
also be the issue. It may have added some debugging that causes
something to be traced (and breakpoint added) that isn't normally
traced.


>   Specifically, note that the value of R12 is the same
> value; R12 is a preserved register and may have been pushed onto the
> stack by something that wants to save it.

I don't see R12 as the same value:

RIP: <ffff88014630a000>
GS: ffff880148000000
R12: ffff880145cc0000

Close but not quite. Even R13 and R15 are close:

R13: ffff880148008eb8
R15: ffff88014780cb40

But this probably does show that the stack is screwed up and did a bad
iret.

-- Steve


