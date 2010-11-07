Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab0KGTfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 14:35:22 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56600 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab0KGTfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 14:35:21 -0500
Date: Sun, 7 Nov 2010 11:35:20 -0800
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Subject: [Security] proactive defense: using read-only memory
Message-ID: <20101107193520.GO5327@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While Dan Rosenberg is working to make things harder to locate potential
targets in the kernel through fixing kernel address leaks[1], I'd like
to approach a related proactive security measure: enforcing read-only
memory for things that would make good targets.

The proposal is simple: as much of the kernel should be read-only as
possible, most especially function pointers and other execution control
points, which are the easiest target to exploit when an arbitrary kernel
memory write becomes available[2] to an attacker. There has been past work
to "const"ify function pointer tables, and this should continue. However,
there are a few things that need further attention:

- Modules need to be correctly marked RO/NX. This patch exists[3], but is
  not in mainline. It needs to be in mainline.

- Pointers to function table also need to be marked read-only after
  they are set. An example of this is the security_ops table pointer. It
  gets set once at boot, and never changes again. These need to be handled
  so it isn't possible to just trivially reaim the entire security_ops
  table lookup somewhere else.

- Architectures besides just x86 need to be considered.

- Entry points to set_kernel_text_rw() and similar need to be blockable.
  Having these symbols available make kernel memory modification trivial;
  there needs to be a way to disable these features for people that want
  to harden their kernel further (though it obviously breaks things like
  ftrace, ksplice, etc, but that should be the admin's choice).

The PaX solution[4] to most of this is to rearrange the loader and memory
sections of the kernel to make use of .rodata fully. For function table
pointers (and other critical things like GDT) that are less commonly
changed, PaX uses a simple approach of just disabling write-protection
when changing variables. For example:

    pax_open_kernel();
    security_ops = &default_security_ops;
    pax_close_kernel();

And pax_(open|close)_kernel() are _inline_ functions so that
return-oriented-programming attacks cannot leave the system with
write-protection disabled:

static inline unsigned long native_pax_open_kernel(void)
{
   unsigned long cr0;

   preempt_disable();
   barrier();
   cr0 = read_cr0() ^ X86_CR0_WP;
   BUG_ON(unlikely(cr0 & X86_CR0_WP));
   write_cr0(cr0);
   return cr0 ^ X86_CR0_WP;
}

And finally, we'll need to go through and address the remaining missing
"const" needs. My intention is to try to get through all these kinds of
changes, but it is going to need the help and understanding of many
subsystem maintainers. Hardening the kernel against manipulation is a win
for everyone. I'd like to try to move this forward, but I'd really
appreciate getting help with it; this will only be successful if people are
on board with it.

Thanks,

-Kees

P.S. If anyone would like to help us try to get more pieces of PaX and
grsecurity into mainline, please choose a thing you'd like to drive
forward, sign up[5] for it, and get to working on it.


[1] http://marc.info/?l=linux-netdev&m=128907432600565&w=2
    http://marc.info/?t=128907683400002&r=1&w=2

[2] proactive security assumes there will be future kernel security
    vulnerabilities and seeks to harden the system against exploitation.
    For evidence of the steady stream of vulnerabilities, see:
    http://lwn.net/Articles/410606/

[3] http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=65187d24fa3ef60f691f847c792e8eaca7e19251

[4] http://grsecurity.net/test.php
    This feature is specifically "CONFIG_PAX_KERNEXEC".

[5] https://wiki.ubuntu.com/SecurityTeam/Roadmap/KernelHardening#Upstream%20Hardening

-- 
Kees Cook
Ubuntu Security Team
