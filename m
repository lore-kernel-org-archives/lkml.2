Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab1JFSLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab1JFSLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:11:18 -0400
Date: Thu, 6 Oct 2011 14:10:55 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org, rth@redhat.com
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
Message-ID: <20111006181055.GA2505@redhat.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
 <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
 <20111003150205.GB2462@redhat.com>
 <4E89E28C.7010700@goop.org>
 <20111004141011.GA2520@redhat.com>
 <4E8B3489.60902@zytor.com>
 <4E8CF348.4080405@goop.org>
 <4E8CF385.2080804@zytor.com>
 <4E8DEB19.1050509@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8DEB19.1050509@goop.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 10:53:29AM -0700, Jeremy Fitzhardinge wrote:
> On 10/05/2011 05:17 PM, H. Peter Anvin wrote:
> > On 10/05/2011 05:16 PM, Jeremy Fitzhardinge wrote:
> >> On 10/04/2011 09:30 AM, H. Peter Anvin wrote:
> >>> On 10/04/2011 07:10 AM, Jason Baron wrote:
> >>>> 1) The jmp +0, is a 'safe' no-op that I know is going to initially
> >>>> boot for all x86. I'm not sure if there is a 5-byte nop that works on
> >>>> all x86 variants - but by using jmp +0, we make it much easier to debug
> >>>> cases where we may be using broken no-ops.
> >>>>
> >>> There are *plenty*.  jmp+0 is about as pessimal as you can get.
> >> As an aside, do you know if a 2-byte unconditional jmp is any more
> >> efficient than 5-byte, aside from just being a smaller instruction and
> >> taking less icache?
> >>
> > I don't know for sure, no.  I probably depends on the CPU.
> 
> Looks like jmp2 is about 5% faster than jmp5 on Sandybridge with this
> benchmark.
> 
> But insignificant difference on Nehalem.
> 
>     J

It would be cool if we could make the total width 2-bytes, when
possible.  It might be possible by making the initial 'JUMP_LABEL_INITIAL_NOP'
as a 'jmp' to the 'l_yes' label. And then patching that with a no-op at boot
time or link time - letting the compiler pick the width. In that way we could
get the optimal width...

thanks,

-Jason


> #include <stdio.h>
> 
> struct {
> 	unsigned char flag;
> 	unsigned char val;
> } l;
> 
> #define JMP2	asm volatile ("jmp 1f; .byte 0x0f,0x1f,0x00; 1: ");
> #define JMPJMP2	JMP2 JMP2
> #define JMPJMPJMP2	JMPJMP2 JMPJMP2
> #define JMPJMPJMP2	JMPJMP2 JMPJMP2
> #define JMPJMPJMPJMP2	JMPJMPJMP2 JMPJMPJMP2
> #define JMPJMPJMPJMPJMP2	JMPJMPJMPJMP2 JMPJMPJMPJMP2
> #define JMPJMPJMPJMPJMPJMP2	JMPJMPJMPJMPJMP2 JMPJMPJMPJMPJMP2
> 
> int main(int argc, char **argv)
> {
> 	int i;
> 
> 	for (i = 0; i < 100000000; i++) {
> 		JMPJMPJMPJMPJMPJMP2;
> 		asm volatile("" : : : "memory");
> 	}
> 
> 	return 0;
> }

> #include <stdio.h>
> 
> struct {
> 	unsigned char flag;
> 	unsigned char val;
> } l;
> 
> #define JMP5	asm volatile (".byte 0xe9; .long 0");
> #define JMPJMP5	JMP5 JMP5
> #define JMPJMPJMP5	JMPJMP5 JMPJMP5
> #define JMPJMPJMP5	JMPJMP5 JMPJMP5
> #define JMPJMPJMPJMP5	JMPJMPJMP5 JMPJMPJMP5
> #define JMPJMPJMPJMPJMP5	JMPJMPJMPJMP5 JMPJMPJMPJMP5
> #define JMPJMPJMPJMPJMPJMP5	JMPJMPJMPJMPJMP5 JMPJMPJMPJMPJMP5
> 
> int main(int argc, char **argv)
> {
> 	int i;
> 
> 	for (i = 0; i < 100000000; i++) {
> 		JMPJMPJMPJMPJMPJMP5;
> 		asm volatile("" : : : "memory");
> 	}
> 
> 	return 0;
> }

