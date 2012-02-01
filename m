Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab2BAWNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:13:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab2BAWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:13:12 -0500
Date: Wed, 1 Feb 2012 14:13:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ramon de C Valle <rcvalle@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] New PT_GNU_COMPAT segment header extension
Message-Id: <20120201141311.05b873ab.akpm@linux-foundation.org>
In-Reply-To: <f298f914-2239-44e4-8aa1-a51282e7fac0@zmail15.collab.prod.int.phx2.redhat.com>
References: <ae010933-d93f-4858-97c7-d5aeb3dd73bc@zmail15.collab.prod.int.phx2.redhat.com>
	<f298f914-2239-44e4-8aa1-a51282e7fac0@zmail15.collab.prod.int.phx2.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jan 2012 06:54:19 -0500 (EST)
Ramon de C Valle <rcvalle@redhat.com> wrote:

> Hi,
> 
> These patches introduces the PT_GNU_COMPAT segment header to indicate the
> kernel whether an ELF binary or a shared library needs to have all readable
> virtual memory mappings also executable (i.e. READ_IMPLIES_EXEC personality)
> and if necessary, it allows more compatibility modes to be implemented in
> the future.
> 
> Currently, an binary that needs only executable stack have unnecessarily all
> readable virtual memory mappings also executable. This is because the kernel
> does not know if the PF_X flag set in the PT_GNU_STACK segment header of the
> binary indicates it needs only stack executable or all readable virtual
> memory mappings also executable. Consequently, the kernel sets the
> READ_IMPLIES_EXEC personality upon loading any binary with the PT_GNU_STACK
> segment header and the PF_X flag set.
> 
> Furthermore, if the PT_GNU_STACK segment header with the PT_X flag is set in
> any of the shared libraries a binary is linked, the kernel does not know if
> the PF_X flag set in the PT_GNU_STACK segment header of the shared library
> indicates it needs only stack executable or all readable virtual memory
> mappings also executable either. Consequently, GCC sets the PT_GNU_STACK
> segment header with the PF_X flag set upon compiling any binary linked to a
> shared library with the PT_GNU_STACK segment header and the PF_X flag set.
> 
> This can result in applications unnoticeably having not only the stack, but
> also all readable virtual memory mappings also executable. These patches
> returns the original meaning and purpose of the PT_GNU_STACK segment header.
> 
> >From the security standpoint, these binaries will rely upon lesser security
> extensions, such as heap consistency checking and others. Thus, improving
> the security of binaries that needs only the stack executable.
> 
> These patches does not affect the current binaries that have the
> PT_GNU_STACK segment header, neither legacy binaries that most likely does
> not have this segment header either. For the existing binaries that
> necessarily need to have all readable virtual memory mappings also
> executable, the PT_GNU_STACK segment header can be easily converted to a
> PT_GNU_COMPAT segment header without recompilation.
> 
> The following are important details about the changes made to the linker:
> 
>  * The PT_GNU_STACK and PT_GNU_COMPAT segment headers are mutually
>    exclusive.
>  * The PT_GNU_STACK segment header has precedence over the PT_GNU_COMPAT
>    segment header.
>  * The PT_GNU_COMPAT segment header IS NOT created by default.
>  * The PT_GNU_STACK segment header IS ALWAYS created by default--which is
>    the original behaviour of the linker.
> 
> These patches are completely non-intrusive. Over the time, once this
> compatibility mode is no longer needed, they can be removed with no
> subsequent effect.
> 

<I have been poked>

I saw the patch but it's one of those ones which looks tricky/risky,
and is in an area with which I'm not sufficiently familiar.  I used to
ask Roland McGrath to help out with this sort of thing, but he
dematerialised a while back.  Perhaps Linus can give it some thought? 
I'd suggest a resend: you've added useful info in later emails so there
would be benefit to bringing it all together in one place.

A couple of minor things:

- The patch will need a Signed-off-by:, as described in
  Documentation/SubmittingPatches.

- The term "compat" has a well-understood meaning in the kernel: it
  refers to the support of 32-bit executables under 64-bit kernels. 
  Adding an unrelated PT_GNU_COMPAT muddies this.  Can you think up a
  different term?


