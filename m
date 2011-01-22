Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1AVRPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 12:15:52 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57544 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751487Ab1AVRPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 12:15:51 -0500
Date: Sat, 22 Jan 2011 12:15:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@elte.hu, richm@oldelvet.org.uk, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, stable <stable@kernel.org>
Subject: Re: [patch 2/3] tracing: fix sparc64 alignment crash with
	__u64_aligned/U64_ALIGN()
Message-ID: <20110122171549.GB31308@Krystal>
References: <20110121203630.725922272@efficios.com> <20110121203642.884088920@efficios.com> <20110121.160509.146106348.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121.160509.146106348.davem@davemloft.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:11:38 up 59 days, 22:14,  5 users,  load average: 0.13, 0.10,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Date: Fri, 21 Jan 2011 15:36:32 -0500
> 
> > Problem description:
> > 
> > gcc happily align structures defined statically on 32-byte. Ftrace trace events
> > and Tracepoints both statically define structures into sections (using the
> > "section" attribute), to then assign these to symbols with the linker scripts to
> > iterate the these sections as an array.
> > 
> > However, gcc uses different alignments for these structures when they are
> > defined statically and when they are globally visible and/or in an array.
> > Therefore iteration on these arrays sees "holes" of padding.
> > 
> > Use the __u64_aligned for type declarations and variable definitions to ensure
> > that gcc:
> > 
> > a) iterates on the correctly aligned type. (type attribute)
> > b) generates the definitions within the sections with the appropriate alignment.
> >    (variable attribute)
> > 
> > The Ftrace code introduced the "aligned(4)" variable attribute in commit
> > 1473e4417c79f12d91ef91a469699bfa911f510f to try to work around this problem that
> > showed up on x86_64, but it causes unaligned accesses on sparc64, and is
> > generally a bad idea on 64-bit if RCU pointers are contained within the
> > structure. Moreover, it did not use the same attribute as type attribute, which
> > could cause the iteration on the extern array structure not to match the
> > variable definitions for some structure sizes.
> > 
> > We should also ensure proper alignment of each Ftrace section in
> > include/asm-generic/vmlinux.lds.h.
> > 
> > Moving all STRUCT_ALIGN() for FTRACE_EVENTS() and TRACE_SYSCALLS() into the
> > definitions, so the alignment is only done if these infrastructures are
> > configured in. Use U64_ALIGN instead of STRUCT_ALIGN.
> > 
> > Also align TRACE_PRINTKS on U64_ALIGN to make sure the beginning of the section
> > is aligned on pointer size.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks! This patch, just like 1/3, should also go into -stable, for both .36 and
.37.

As I'm thinking, the following patch (for Tracepoints) should only go into the
-tip tree, as it does not fix a problem -- it merely reduces the data footprint
of the tracepoints structures. I'm therefore not forwarding patch 3/3 for
inclusion into -stable.

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
