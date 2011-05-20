Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934649Ab1ETSOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:14:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933693Ab1ETSOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:14:35 -0400
MIME-Version: 1.0
In-Reply-To: <1305913261.20623.12.camel@dan>
References: <1305292059.1949.0.camel@dan> <1305293345.1949.22.camel@dan>
 <20110516153527.GC21107@elte.hu> <1305852966.3005.19.camel@dan>
 <20110520120750.GJ14745@elte.hu> <1305896093.3005.24.camel@dan>
 <20110520131108.GA17699@elte.hu> <1305913261.20623.12.camel@dan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 May 2011 11:14:09 -0700
Message-ID: <BANLkTinCnqrzMyoSzS04fCAqks1bd9Y8=g@mail.gmail.com>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, adobriyan@gmail.com, penberg@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 10:41 AM, Dan Rosenberg
<drosenberg@vsecurity.com> wrote:
>
> Also, I'd still welcome suggestions on generating entropy so early in
> the boot process as to randomize the location at which the kernel is
> decompressed.

The fundamental problem with the whole kernel address randomization is
sadly totally unrelated to any of the small details.

There's a *big* detail that makes it hard: there's only a few bits of
randomness we can add to the address. The kernel base address ends up
having various fundamental limitations (cacheline alignment for the
code, and we have several segments that require page alignment), so
you really can't realistically do more than something like 8-12 bits
of address randomization.

Which means that once you have a vmlinux image (say, because it's a
standard distro kernel), you only need to try your exploit a few
hundred times. That can be done quickly enough that no MIS person will
ever have time to react to the attack.

Sure, it will likely leave some hints around (oopses etc), but still..

> On a related note, would there be obstacles to marking the IDT as
> read-only?

We do that for the F00F bug workaround. But while the linear address
is read-only, the IDT can still be accessed read-write through the
physical address through the normal 1:1 mapping.

Regardless, the virtual mapping trick (independently of whether it's
read-only or not) can be used to avoid exposing the *actual* address
of the IDT of the kernel, and would hide the kernel load address
details. However, it does make traps slightly slower, if they cannot
use the 1:1 mapping with large pages for the IDT access and thus cause
more TLB pressure. Of course, in many situations we probably end up
not having large pages for the kernel anyway, so..

As a result, we do that F00F bug workaround _only_ if we're actually
running on a CPU with the FOOF bug.

                   Linus
