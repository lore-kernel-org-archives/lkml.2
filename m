Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2JDKdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:33:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60346 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2JDKdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <20589.18026.809848.345606@pilspetsen.it.uu.se>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20120820180037.GV4232@outflux.net>
	<CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
	<CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com>
	<CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com>
	<CAGXu5jLj6qm+Rv3v2pmJqfEmhZBkKJsMUe0aRqxSa=s=w4wbDw@mail.gmail.com>
	<20121002153841.a03ad73b.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1210021733580.1343@eggly.anvils>
	<506C4F29.4090303@gmail.com>
	<20589.18026.809848.345606@pilspetsen.it.uu.se>
Date: Thu, 4 Oct 2012 12:33:38 +0200
Message-ID: <CAKFga-dzi6gkaMOF9t_fh1xVQLkht_RRAYk+L42Y1d3gzcGNkg@mail.gmail.com>
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
From: Ard Biesheuvel <ard.biesheuvel@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/4 Mikael Pettersson <mikpe@it.uu.se>:
> - If .text is mapped non-writable and final, how would a debugger
>   (or any ptrace-using monitor-like application) plant a large
>   number of breakpoints in a target process? Breakpoint registers
>   aren't enough because (a) they're few in number, and (b) not
>   all CPUs have them.
>

ptrace() doesn't care whether or not the process itself can write to
its .text segment.

> - You're proposing to give one component (the dynamic linker/
>   loader) absolute power to impose new policies on all
>   applications. How would an application that _deliberately_
>   does something the new policies don't allow tell the dynamic
>   linker or kernel to get out of its way?
>

You are debating cases in which the userland would choose not to use
the feature. That is exactly the point of this patch: the kernel
supplies the feature and it is up to the userland to use it when
desired. If not in the loader, perhaps processes running setuid
binaries or browser sandboxes could choose to call mprotect() to
finalize some of their existing mappings (their stack?) before handing
over to less trusted code or opening up to the network.

> This clearly changes the de-facto ABIs, and as such I think
> it needs much more detailed analysis than what you've done
> here.
>

Could we at least agree on the fundamental notion that the special
powers the loader has to modify .text and .rodata sections are hardly
ever needed by the programs themselves? In that sense, this is similar
to dropping root privileges when not required anymore, and that is
typically recognized as a sensible idea.

> At the very least I think this change should be opt-in, but
> that would require a kernel option or sysctl, or some config
> file for the user-space dynamic linker/loader.

As long as the kernel does not impose its use, I don't see a reason
for an interface into the kernel to deactivate it.
I would be interested in learning about example cases that have a
valid need to modify their own code and constant data, as
understanding those would greatly help in designing the ways userland
should be able to have control over this.

Regards,
Ard.
