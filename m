Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1AVRLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 12:11:39 -0500
Received: from mail.openrapids.net ([64.15.138.104]:49079 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750967Ab1AVRLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 12:11:37 -0500
Date: Sat, 22 Jan 2011 12:11:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@elte.hu, richm@oldelvet.org.uk, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, stable <stable@kernel.org>
Subject: Re: [patch 1/3] introduce __u64_aligned and U64_ALIGN() for
	structure alignment in custom sections (v3)
Message-ID: <20110122171134.GA31308@Krystal>
References: <20110121203630.725922272@efficios.com> <20110121203642.725191236@efficios.com> <20110121.160503.233879710.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121.160503.233879710.davem@davemloft.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:08:32 up 59 days, 22:11,  5 users,  load average: 0.10, 0.09,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Date: Fri, 21 Jan 2011 15:36:31 -0500
> 
> > Problem description:
> > 
> > gcc happily align on 32-byte structures defined statically. Ftrace trace events
> > and Tracepoints both statically define structures into custom sections (using
> > the "section" attribute), to then assign these to symbols with the linker
> > scripts to iterate the these sections as an array.
> > 
> > However, gcc uses different alignments for these structures when they are
> > defined statically than when they are globally visible and/or in an array.
> > Therefore iteration on these arrays sees "holes" of padding. gcc is within its
> > rights to increase the alignment of the statically defined structures because,
> > normally, there should be no other accesses to them than in the local object. We
> > are actually iterating on the generated structures as if they were an array
> > without letting gcc knowing anything about it.
> > 
> > This patch introduces __u64_aligned to force gcc to use the u64 type and
> > variable alignment, up-aligning or down-aligning the target type if necessary.
> > The memory accesses to the target structure are efficient (does not require
> > bytewise memory accesses) and the atomic pointer update guarantees required by
> > RCU are kept. u64 is considered as the largest type that can generate a trap for
> > unaligned accesses (u64 on sparc32 needs to be aligned on 64-bit).
> > 
> > This alignment should be used for both structure definitions and declarations
> > (as *both* the type and variable attribute) when using the "section"
> > attribute to generate arrays of structures. Given that gcc only uses the type
> > attribute "aligned" as a lower-bound for alignment, the structures should not
> > contain types which require alignment larger than that of u64. The "aligned"
> > variable attribute, on the other hand, forces gcc to use exactly the specified
> > alignment.
> > 
> > Also introduce the linker script U64_ALIGN() macro for specification of custom
> > section alignment that matches that of __u64_aligned.
> > 
> > Changelog since v2:
> > - Drop the "packed" type attribute, because it causes gcc to drop the padding
> >   between consecutive "int" and "pointer"/"long" fields, which leads to
> >   unaligned accesses on sparc64.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks David,

After these patches get merged -- I would recommend going through the tracing
tree -- they'll have to go to -stable too. I'm therefore forwarding this to
stable@kernel.org (the same should be done for the two other patches in this
series).

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
