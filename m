Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2BJDDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 22:03:44 -0500
Received: from mail2.shareable.org ([80.68.89.115]:49953 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab2BJDDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 22:03:43 -0500
Date: Fri, 10 Feb 2012 03:02:51 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Andrew Vagin <avagin@gmail.com>, Pedro Alves <palves@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120210030251.GA9349@jl-vm1.vm.bytemark.co.uk>
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org>
 <20120203162519.GB805@google.com>
 <4F2C0F13.70709@parallels.com>
 <20120203165132.GA5636@redhat.com>
 <4F31848A.9070406@redhat.com>
 <4F327B99.7020602@gmail.com>
 <20120208181222.GA12787@host2.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208181222.GA12787@host2.jankratochvil.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kratochvil wrote:
> On Wed, 08 Feb 2012 14:41:45 +0100, Andrew Vagin wrote:
> > I want to say, that when you have trouble with child_tid_address,
> > you may want to get it.
> > If the code is your, you may get it via prctl, but if it's not, what
> > will you do?
> 
> GDB does PTRACE_ARCH_PRCTL (amd64-linux-nat.c) - without inserting any code
> into the debuggee.  How it can be simplified more?

That's x86-64 only, (although bizarrely it looks like 32-bit tasks can
use it too, if running on a 64-bit kernel).

Whereas child_tid_address is for all architectures.

We've already got a whole syscall, get_robust_list(), which fetches
that address from a remote process if you have ptrace permission, and
you don't even need to be ptracing it!  get_robust_list() is quite
large, and most of it is permission checks.  How often is that useful?

I don't see why getting the child_tid_address should be a big deal.

On the other hand, lots of little bits of info would be handy to a
ptracer sometimes, such as the current signal mask and prctl settings.

Maybe what's needed is a generic PTRACE_PRCTL, allowed to call a
subset of prctl() functions from outside, or maybe even all of them.

Then add child_tid_address as a prctl.

( Then again maybe just skip the messing around that everyone does with
"parasite" code, and go straight for PTRACE_CALL_SYSCALL.  It'd save a
lot of bother :-) )

All the best,
-- Jamie
