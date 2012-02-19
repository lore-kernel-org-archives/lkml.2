Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2BSO6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 09:58:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3461 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2BSO5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 09:57:34 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=v34b3tIZfGoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=mT6bdWXa1rcZQBXxhtoA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329663451.25686.21.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Test saved %rip in NMI to
 determine nested NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sun, 19 Feb 2012 09:57:31 -0500
In-Reply-To: <20120219125601.GD25900@elte.hu>
References: <1329617173.1561.5.camel@acer.local.home>
	 <20120219125601.GD25900@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-19 at 13:56 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > I found that it is possible for userspace to prevent an NMI 
> > from triggering while it is running by setting its stack 
> > pointer to that of the NMI stack. This tricks the NMI nested 
> > algorithm in thinking that the NMI is nested. The easy 
> > solution to this is to test the %rip to make sure that the NMI 
> > happened in kernel mode before testing for nesting.
> 
> Ouch...

Note, it does not seem to cause any destruction, but screw up profiling.
It doesn't change how timer interrupts, or any other interrupts work.
I'm not sure what problems this can cause on a security level. But it
needs to be fixed regardless.

> 
> > I've tested a program that exhibits the missing NMIs and this 
> > patch corrects that behavior.
> 
> Does it need a -stable tag?

The nesting code was introduced in 3.3 so this does not affect any major
released version of Linux.


> Does this do the right thing for the vDSO as well? It is in 
> negative addresses:
> 
> ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
> 

Hmm, I thought about this as well, Can that code run with a bad stack?
It would require a process to call this code using the NMI stack
pointer, and things like push and pop would cause the code to crash
immediately with a SEGFAULT.

I could add more checks in the nested NMI path, as that is the slow path
because nested NMIs are extremely rare.

-- Steve


