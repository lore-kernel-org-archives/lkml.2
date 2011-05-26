Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab1EZUjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:39:40 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:50035 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab1EZUji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:39:38 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davej@redhat.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, eranian@google.com,
        penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, hpa@zytor.com,
        Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        pageexec@freemail.hu, Ingo Molnar <mingo@elte.hu>,
        Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <1306269105.21443.20.camel@dan>
References: <1306269105.21443.20.camel@dan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 16:39:27 -0400
Message-ID: <1306442367.2279.25.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 16:31 -0400, Dan Rosenberg wrote:
> This introduces CONFIG_RANDOMIZE_BASE, which randomizes the address at
> which the kernel is decompressed at boot as a security feature that
> deters exploit attempts relying on knowledge of the location of kernel
> internals.  The default values of the kptr_restrict and dmesg_restrict
> sysctls are set to (1) when this is enabled, since hiding kernel
> pointers is necessary to preserve the secrecy of the randomized base
> address.
> 
> This feature also uses a fixed mapping to move the IDT (if not already
> done as a fix for the F00F bug), to avoid exposing the location of
> kernel internals relative to the original IDT.  This has the additional
> security benefit of marking the new virtual address of the IDT
> read-only.
> 
> Entropy is generated using the RDRAND instruction if it is supported. If
> not, then RDTSC is used, if supported. If neither RDRAND nor RDTSC are
> supported, then no randomness is introduced. Support for the CPUID
> instruction is required to check for the availability of these two
> instructions.
> 
> Thanks to everyone who contributed helpful suggestions and feedback so
> far.
> 

I wanted to send out an update email that consolidated the feedback and
suggestions I've received so far:

1. I'm nearly finished a first draft of code to parse the BIOS E820
memory map to determine where it's safe to place the randomized kernel.
This code accounts for overlapping regions, as well as potential
conflicts in region types (free vs. reserved, etc.), in favor of
non-free types.  The end result is, I'll have a reasonable upper bound.

2. I'll parse the kernel command line for crashkernel arguments and
avoid placing a randomized kernel in any regions marked as reserved.  A
new command line argument for kdump might be a good idea as well
(discussion on-going).

3. I'll be introducing a new format specifier (perhaps %pk) that
unconditionally de-randomizes kernel pointers, and switch callers where
appropriate.

4. The perf call chains that rely on kernel pointers will account for
the randomization.

5. I'll be switching to per-cpu IDTs, basing my work on the following
patch:

http://marc.info/?l=linux-kernel&m=112767117501231&w=2

Any review or comments on the above patch would be helpful.  I'm
considering submitting this portion separately, as it may provide
performance and scalability benefits regardless of randomization.

6. As per H. Peter Anvin's suggestion, it seems there's some demand for
a way to opt-out at the boot-loader level, possibly via a command-line
option and boot protocol flag.

7. Still need to figure out exactly what's ok and what's not regarding
altering alignment and PHYSICAL_START.  It seems there's some consensus
on "don't do it", but perhaps it's ok to partially ignore the alignment
config at runtime in favor of hard-coded, known-safe, finer-grained
alternatives.

8. Other pieces of feedback, such as comment suggestions, changes to
kptr_restrict/dmesg_restrict defaults, etc. have been incorporated.

8. x86-64 will present its own set of challenges.  One thing at a time.

Thanks for all the feedback and guidance so far.  Let me know if
anything above is objectionable, or if you have any more suggestions.
There's lots to do, but I haven't given up yet. :)

Regards,
Dan

