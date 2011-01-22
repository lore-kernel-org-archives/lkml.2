Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab1AVAEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:04:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54335
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754955Ab1AVAEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:04:35 -0500
Date: Fri, 21 Jan 2011 16:05:09 -0800 (PST)
Message-Id: <20110121.160509.146106348.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@elte.hu, richm@oldelvet.org.uk, ben@decadent.org.uk,
        sparclinux@vger.kernel.org
Subject: Re: [patch 2/3] tracing: fix sparc64 alignment crash with
 __u64_aligned/U64_ALIGN()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110121203642.884088920@efficios.com>
References: <20110121203630.725922272@efficios.com>
	<20110121203642.884088920@efficios.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Fri, 21 Jan 2011 15:36:32 -0500

> Problem description:
> 
> gcc happily align structures defined statically on 32-byte. Ftrace trace events
> and Tracepoints both statically define structures into sections (using the
> "section" attribute), to then assign these to symbols with the linker scripts to
> iterate the these sections as an array.
> 
> However, gcc uses different alignments for these structures when they are
> defined statically and when they are globally visible and/or in an array.
> Therefore iteration on these arrays sees "holes" of padding.
> 
> Use the __u64_aligned for type declarations and variable definitions to ensure
> that gcc:
> 
> a) iterates on the correctly aligned type. (type attribute)
> b) generates the definitions within the sections with the appropriate alignment.
>    (variable attribute)
> 
> The Ftrace code introduced the "aligned(4)" variable attribute in commit
> 1473e4417c79f12d91ef91a469699bfa911f510f to try to work around this problem that
> showed up on x86_64, but it causes unaligned accesses on sparc64, and is
> generally a bad idea on 64-bit if RCU pointers are contained within the
> structure. Moreover, it did not use the same attribute as type attribute, which
> could cause the iteration on the extern array structure not to match the
> variable definitions for some structure sizes.
> 
> We should also ensure proper alignment of each Ftrace section in
> include/asm-generic/vmlinux.lds.h.
> 
> Moving all STRUCT_ALIGN() for FTRACE_EVENTS() and TRACE_SYSCALLS() into the
> definitions, so the alignment is only done if these infrastructures are
> configured in. Use U64_ALIGN instead of STRUCT_ALIGN.
> 
> Also align TRACE_PRINTKS on U64_ALIGN to make sure the beginning of the section
> is aligned on pointer size.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Acked-by: David S. Miller <davem@davemloft.net>
