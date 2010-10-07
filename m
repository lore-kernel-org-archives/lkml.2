Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582Ab0JGO6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:58:19 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:44101
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760184Ab0JGO6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:58:18 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dN9371Pzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9XDKQ-01-RYY-02
X-M-MSG: 
Date: Thu, 7 Oct 2010 16:58:02 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Brian Gerst <brgerst@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 3/3] Save/restore LWP state in context switches.
Message-ID: <20101007145802.GD17424@escobedo.osrc.amd.com>
References: <20101005182739.GE173@escobedo.osrc.amd.com>
 <1286303429-415145-4-git-send-email-hans.rosenfeld@amd.com>
 <AANLkTinBsut0Csubh1N85jkydH7wCp3YniASE-vyf7MP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTinBsut0Csubh1N85jkydH7wCp3YniASE-vyf7MP@mail.gmail.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach
 b. Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 07:12:11AM -0400, Brian Gerst wrote:
> On Tue, Oct 5, 2010 at 2:30 PM, Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> > LWP (Light-Weight Profiling) is a new per-thread profiling mechanism
> > that can be enabled by any thread at any time if the OS claims to
> > support it (by setting a bit in XCR0). A threads LWP state
> > (configuration & unsaved collected data) is supposed to be saved and
> > restored with xsave and xrstor by the OS.
> >
> > Unfortunately, LWP does not support any kind of lazy switching, nor does
> > it use the TS bit in CR0. Since any thread can enable LWP at any time
> > without the kernel knowing, the context switch code is supposed to
> > save/restore LWP context unconditionally. This would require a valid
> > xsave state area for all threads, whether or not they use any FPU or LWP
> > functionality. It would also make the already complex lazy switching
> > code more complicated.
> >
> > To avoid this memory overhead, especially for systems not supporting
> > LWP, and also to avoid more intrusive changes to the code that handles
> > FPU state, this patch handles LWP separately from the FPU. Only if a
> > system supports LWP, the context switch code checks whether LWP has been
> > used by the thread that is being taken off the CPU by reading the
> > LWP_CBADDR MSR, which is nonzero if LWP has been used by the thread.
> > Only in that case the LWP state is saved to the common xsave area in the
> > threads FPU context. This means, of course, that an FPU context has to
> > be allocated and initialized when a thread first uses LWP before using
> > the FPU.
> >
> > Similarly, restoring the LWP state is only done when an FPU context
> > exists and the LWP bit in the xstate header is set.
> >
> > To make things a little more complicated, xsave and xrstor _do_ use the
> > TS bit and trap when it is set. To avoid unwanted traps, the TS bit has
> > to be cleared before and restored after doing xsave or xrstor for LWP.
> >
> > Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
> 
> I would prefer to see the xsave code refactored so that you would only
> need one xsave/xrstor call per context switch.  We are currently
> treating xsave as an extension to the FPU state.  But it would be
> better to treat FPU as a subset of the extended state.  That way more
> state can be added without touching the FPU code..

IIRC Robert did some changes to the xsave stuff to make it more
independent from the FPU stuff. The first of my patches also goes into
that direction, but thats not the main point of it. The main point is
to remove useless or duplicated code and make it easier to understand :)

I have spent some more time meditating about that code and thinking
about using only one xsave/xrstor call per context switch. It is
possible, but it would at least require pre-allocating the xsave state
area for each thread.

The xsave part would be fairly simple, the FPU state is saved non-lazy
anyway if it has been used. Xsave would probably save the state more
often than necessary as it can't know whether the state really changed
since the last time it was saved. This could be avoided by checking
this before doing xsave, and then do xsave only for the parts that
really need saving (like LWP).

Xrstor would need more work because of lazy FPU switching. You would
always have to check whether you want to preload the FPU state or not,
and do xrstor for all or only the necessary states.

In any case one would have to care about CR0.TS when doing all that.

So, as far as I understand it, to get this simpler and cleaner, at
least the preallocation of xsave or fpu state buffers is necessary.
To really clean it up, dropping lazy switching would probably help.
But I'm certainly not proposing to do that :)


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

