Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1EVSpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 14:45:38 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:55017 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1EVSpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 14:45:32 -0400
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, kees.cook@canonical.com,
        davem@davemloft.net, eranian@google.com, torvalds@linux-foundation.org,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com
In-Reply-To: <20110520131108.GA17699@elte.hu>
References: <1305292059.1949.0.camel@dan> <1305293345.1949.22.camel@dan>
	 <20110516153527.GC21107@elte.hu> <1305852966.3005.19.camel@dan>
	 <20110520120750.GJ14745@elte.hu> <1305896093.3005.24.camel@dan>
	 <20110520131108.GA17699@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 14:45:22 -0400
Message-ID: <1306089922.1806.27.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 15:11 +0200, Ingo Molnar wrote:
> * Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> 
> > On Fri, 2011-05-20 at 14:07 +0200, Ingo Molnar wrote:
> > > * Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> > > 
> > > > I was able to boot a relocatable kernel with the decompression location at a 
> > > > hard-coded offset without too much trouble.  Everything seems to work fine.
> > > 
> > > Nice!
> > > 

A progress update, and a number of questions.

The randomization itself is working fine with the following hack in
arch/x86/boot/compressed/head_32.S:

#ifdef CONFIG_RELOCATABLE
	movl	%ebp, %ebx
#ifdef CONFIG_RANDOMIZE_BASE
	rdtsc
	shll	$0x8, %eax
	andl	$0x3ffffff, %eax
	addl	%eax, %ebx
#endif
	movl	BP_kernel_alignment(%esi), %eax
	decl	%eax
	addl	%eax, %ebx
	notl	%eax
	andl	%eax
#endif

That brings me to my first two questions:

1. Is it ok to assume the existence of rdtsc?  If not, what are other
ways of gathering entropy early in the boot process?  If this is the
approach that's going to be taken, system uptime potentially becomes
useful for attackers.  Any thoughts on how to address this?

2. The current default physical alignment is 16mb as a result of this
patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ceefccc93932b920a8ec6f35f596db05202a12fe

Having 16mb alignment greatly restricts the amount of usable entropy for
randomization.  It seems an alternate solution to the problem the above
patch addresses is reverting back to 1mb alignment (or 2/4 mb if that
has performance benefits) and enforcing a 16mb minimum physical start
for relocatable kernels by bumping it up in the boot code if necessary.
Would this be possible?  I'd like to avoid requiring distros to touch
CONFIG_PHYSICAL_ALIGN (and risk breaking things) in order to have more
useful randomization.

A few more questions arose during my efforts:

3. The current hack I'm using to determine the offset to reverse apply
to symbol output looks something like this:

unsigned long kptr_adjust = ((unsigned long)_text &
~(CONFIG_PHYSICAL_ALIGN-1)) - (PAGE_OFFSET + CONFIG_PHYSICAL_START);

Is it safe to assume that kernel .text is the first thing in a
decompressed kernel image?  If not, any other suggestions?  It seemed
easier to compute this in the decompressed kernel at runtime rather than
try to figure out a way to pass the actual decompression address from
the boot stage to the main kernel.

4. What kind of behavior do people want with %pK and kptr_restrict?  If
possible, I'd like to find a way that perf users can have the benefits
of this feature and still have usable symbol support.  However, module
symbols are a bit tricky, since they're not being relocated with the
rest of the kernel, and it doesn't seem meaningful to reverse-apply the
same offset in module symbol output.  Perhaps a separate format
specifier should be introduced to differentiate symbols that need to be
offset?

Basically, we've got kernel .text symbols, module symbols, and dynamic
kernel pointers, and I'm not sure with what granularity people are
interested in hiding them.  It seems perf at least wants more than "all
or nothing".

5. I'd like some more opinions on moving the IDT.  So far, the two
options are using a fixed mapping similar to the F00F bug fix, and
allocating it percpu at runtime.

Looking forward to feedback, criticism, disgust, etc.

Regards,
Dan

