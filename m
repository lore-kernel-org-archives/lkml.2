Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0JEOxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 10:53:11 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:26972
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab0JEOxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 10:53:10 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz1432N98dNzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L9TNYK-02-771-02
X-M-MSG: 
Date: Tue, 5 Oct 2010 16:51:55 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: <robert.richter@amd.com>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 0/3] Basic support for LWP
Message-ID: <20101005145155.GD173@escobedo.osrc.amd.com>
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>
 <alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_b=2E_M=FCnchen=3B_Ges?=
	=?iso-8859-1?Q?ch=E4ftsf=FChrer=3A_Andrew_Bowd=2C_Alberto_Bozzo=3B_Sitz?=
	=?iso-8859-1?Q?=3A_Dornach=2C_Gemeinde_Aschheim=2C_Landkreis_M=FCnchen=3B?=
	=?iso-8859-1?Q?_Registergericht_M=FCnchen=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding Robert ]

On Mon, Oct 04, 2010 at 06:13:46PM -0400, Thomas Gleixner wrote:
> > LWP (Light-Weight Profiling) is a new profiling mechanism that allows
> > user mode processes to gather performance data about themselves with
> > very low overhead. The specification can be found here:
> >         http://developer.amd.com/cpu/LWP/Pages/default.aspx
> 
> All I can see there is marketing blurb. The spec pdf does not tell me
> either how the end result of your patches will look like.

Well, you should get a basic understanding of how LWP works from the
spec. I'm pretty sure there is more than that blurb in there.

What I sent _is_ the end result. Supporting LWP in the task switching
code is the only thing necessary to use the LWP instructions in user
space. And that is also what I'd like to get some comments on.

> > This code adds basic support for LWP to the context switch code, which
> > is the minimum needed to use LWP. Support for other LWP features like
> > interrupts will be added later.
> 
> Oh no. We are not going to merge that and give you a card blanche to
> come up with another profiling/performance monitoring facility which
> is completely disconnected to everything else.

I think you got something wrong here, probably because I wasn't clear
enough :)

What I sent was just the basic kernel support, which means
saving/restoring the LWP state in task switches. Technically no other
kernel changes are necessary to use LWP in user space programs. No
kernel framework of any kind is necessary to use LWP. Additionally,
Robert is checking whether and how LWP support could be integrated
into perf. This of course depends on having basic LWP task switching
support in the kernel.

> Please provide either the full patch of this facility or at least a
> reasonable explanation how it will look like when your code is
> ready. What's the user space interface, how does it hook into perf,
> etc ...

The basic principle of LWP is that a user program reserves some memory
for a LWP control block and a ring buffer, writes the ring buffer
address and some setup bits into the control block, and executes the
LLWPCB instruction to load the control block into the CPU. While the
program runs it can periodically read the samples from the ring buffer
and do something useful with them. The program being profiled needs to
include support for LWP to do that. In case you can't or don't want to
modify the program being profiled, a small LWP library would have to
be written that would have to be LD_PRELOADed. I don't really know
what it will look like in the end and how it will be integrated into
perf. The tool/library developers will probably know best how to make
use of LWP.

The point is that LWP is supposed to be controlled and used from user
space without any kernel interaction, provided that the kernel
saves/restores the LWP context. That's also how I tested it, using a
small test program that just uses the LWP instructions.

Technically LWP is quite similar to the FPU, it even uses the same
facilities for OS support. Just like FPU support, the kernel doesn't
have to care at all about what user space is going to do with it. It
just has to make sure state is saved and restored when necessary.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

