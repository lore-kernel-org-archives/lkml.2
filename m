Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0FSQWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 12:22:31 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33325 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab0FSQWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 12:22:30 -0400
Date: Sat, 19 Jun 2010 09:21:56 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Alexander Potashev <aspotashev@gmail.com>,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] x86: clear XD_DISABLED flag on Intel to regain
 NX
Message-ID: <20100619162156.GW24749@outflux.net>
References: <20100619055010.GR24749@outflux.net>
 <874ogzph4m.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874ogzph4m.fsf@basil.nowhere.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jun 19, 2010 at 10:21:29AM +0200, Andi Kleen wrote:
> Kees Cook <kees.cook@canonical.com> writes:
> 
> > This will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX cannot
> > be inappropriately controlled by the BIOS on Intel CPUs.  If NX actually
> > needs to be disabled, "noexec=off" can be used.
> 
> The patch still seems like a bad idea to me. What happens if 
> the NX bit is broken for some reason and the BIOS is right
> to disable it?

I would think this would be the exception; such broken systems should be
worked around when they are discovered.

> If there's some VM which doesn't ignore unknown MSR writes
> it could also break early, and at best you get an ugly
> message and at worst a crash.

That would be a bug in the VM, but since intel_early_init() already does
the MSR call, such a problem would already exist (and this patch wouldn't
make it worse).

> Do you have evidence for a lot of systems where NX is disabled
> this way without BIOS option? Really such information
> should be in the patch description.

All Dell systems shipping Ubuntu (and RedHat before then) until maybe
mid-2009 had XD_DISABLE set, and several bare boards with AMI BIOSes
have shipped with it too.  It is an unfortunately common scenario from
what I've seen.  Note that both have an option, but most users don't know
or care about it.  Since Linux handles NX fine, it should clear the bit.

> If you really need to apply it apply it in some place where
> exception handling is possible at least.

I think this needs to happen before the EFER gets set, which happens very
early.  If this can be moved somewhere else, I would be very happy to put
it there; I'd like to avoid any possible glitches (though clearing an MSR
bit seems safe, and using that MSR is already known to be safe).

-Kees

-- 
Kees Cook
Ubuntu Security Team
