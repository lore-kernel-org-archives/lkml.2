Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965526Ab2JDIVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:21:04 -0400
Received: from smtp1.uu.se ([130.238.7.54]:34126 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab2JDIVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:21:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20589.18026.809848.345606@pilspetsen.it.uu.se>
Date: Thu, 4 Oct 2012 10:18:50 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ard Biesheuvel <ard.biesheuvel@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
In-Reply-To: <506C4F29.4090303@gmail.com>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20120820180037.GV4232@outflux.net>
	<CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
	<CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com>
	<CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com>
	<CAGXu5jLj6qm+Rv3v2pmJqfEmhZBkKJsMUe0aRqxSa=s=w4wbDw@mail.gmail.com>
	<20121002153841.a03ad73b.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1210021733580.1343@eggly.anvils>
	<506C4F29.4090303@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ard Biesheuvel writes:
 > This patch adds support for the PROT_FINAL flag to
 > the mmap() and mprotect() syscalls.
 > 
 > The PROT_FINAL flag indicates that the requested set
 > of protection bits should be final, i.e., it shall
 > not be allowed for a subsequent mprotect call to
 > set protection bits that were not set already.
 > 
 > This is mainly intended for the dynamic linker,
 > which sets up the address space on behalf of
 > dynamic binaries. By using this flag, it can
 > prevent exploited code from remapping read-only
 > executable code or data sections read-write.

I can see why you might think this is a good idea, but I don't
like it for several reasons:

- If .text is mapped non-writable and final, how would a debugger
  (or any ptrace-using monitor-like application) plant a large
  number of breakpoints in a target process? Breakpoint registers
  aren't enough because (a) they're few in number, and (b) not
  all CPUs have them.

- You're proposing to give one component (the dynamic linker/
  loader) absolute power to impose new policies on all
  applications. How would an application that _deliberately_
  does something the new policies don't allow tell the dynamic
  linker or kernel to get out of its way?

This clearly changes the de-facto ABIs, and as such I think
it needs much more detailed analysis than what you've done
here.

At the very least I think this change should be opt-in, but
that would require a kernel option or sysctl, or some config
file for the user-space dynamic linker/loader.
