Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab1EZVDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:03:41 -0400
Received: from relais.videotron.ca ([24.201.245.36]:48477 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1EZVDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:03:40 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_sdj8fG6qmHXatP4rxbgU1Q)"
Date: Thu, 26 May 2011 17:03:39 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
        ak@linux.intel.com
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when
 CONFIG_ALIGNMENT_TRAP
In-reply-to: <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
Message-id: <alpine.LFD.2.00.1105261650330.3207@xanadu.home>
References: <20110523111648.10474.78396.stgit@e102109-lin.cambridge.arm.com>
 <20110523132124.GI17672@n2100.arm.linux.org.uk>
 <1306229953.19557.14.camel@e102109-lin.cambridge.arm.com>
 <yw1xipt0p4i9.fsf@unicorn.mansr.com>
 <BANLkTi=xLE9gP5YOdr9dR0DfsY1Ymzxu+w@mail.gmail.com>
 <20110524171331.GA2941@arm.com>
 <20110525111405.GA12010@e102109-lin.cambridge.arm.com>
 <20110525124348.GA2340@arm.com> <yw1xaaeanbxe.fsf@unicorn.mansr.com>
 <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com>
 <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_sdj8fG6qmHXatP4rxbgU1Q)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

On Thu, 26 May 2011, Will Deacon wrote:

> This issue seems to be caused by passing -fconserve-stack to GCC. This
> was added in 8f7f5c9f ("kbuild: set -fconserve-stack option for gcc
> 4.5") and as you can see from the archive:
> 
> http://lkml.org/lkml/2009/9/20/39
> 
> it was thought to only have an impact on inlining decisions. Looking at
> the documentation for GCC 4.6:
> 
> -fconserve-stack
>           Attempt to minimize stack usage. The compiler will attempt to
> use less stack space, even if that makes the program slower. This option
> implies setting the ‘large-stack-frame’ parameter to 100 and the
> ‘large-stack-frame-growth’ parameter to 400.
> 
> So it sounds like we might not want to enable this blindly across all
> architectures. Indeed, on ARM, it encourages the compiler to pack
> variables on the stack which leads to the weird and wonderful alignment
> situation that has been encountered in this thread.
> 
> Can we remove -fconserve-stack from the top-level Makefile (or at least
> make it conditional by architecture)?

I think this is an orthogonal issue.

My opinion is that we should use -mno-unaligned-access by default on 
ARM.  The reason is that we've been expecting the compiler not to cause 
unaligned accesses for ages, and letting the compiler, for whatever 
reasons including things like -fconserve-stack, produce unaligned 
accesses behind our back is a change in behavior we might not always be 
prepared for.  Unaligned accesses in the kernel should be rare anyway, 
and allowing the compiler to generate them can be allowed for selected 
files when proven beneficial.

It is possible that -fconserve-stack is still valuable on ARM given that 
it is also used with -mno-unaligned-access for other things than 
structure packing on the stack, and therefore its merits can be debated 
independently from the alignment issue at hand.


Nicolas

--Boundary_(ID_sdj8fG6qmHXatP4rxbgU1Q)--
