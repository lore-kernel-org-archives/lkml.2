Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab1AVAEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:04:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54324
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754816Ab1AVAE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:04:29 -0500
Date: Fri, 21 Jan 2011 16:05:03 -0800 (PST)
Message-Id: <20110121.160503.233879710.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@elte.hu, richm@oldelvet.org.uk, ben@decadent.org.uk,
        sparclinux@vger.kernel.org
Subject: Re: [patch 1/3] introduce __u64_aligned and U64_ALIGN() for
 structure alignment in custom sections (v3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110121203642.725191236@efficios.com>
References: <20110121203630.725922272@efficios.com>
	<20110121203642.725191236@efficios.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Fri, 21 Jan 2011 15:36:31 -0500

> Problem description:
> 
> gcc happily align on 32-byte structures defined statically. Ftrace trace events
> and Tracepoints both statically define structures into custom sections (using
> the "section" attribute), to then assign these to symbols with the linker
> scripts to iterate the these sections as an array.
> 
> However, gcc uses different alignments for these structures when they are
> defined statically than when they are globally visible and/or in an array.
> Therefore iteration on these arrays sees "holes" of padding. gcc is within its
> rights to increase the alignment of the statically defined structures because,
> normally, there should be no other accesses to them than in the local object. We
> are actually iterating on the generated structures as if they were an array
> without letting gcc knowing anything about it.
> 
> This patch introduces __u64_aligned to force gcc to use the u64 type and
> variable alignment, up-aligning or down-aligning the target type if necessary.
> The memory accesses to the target structure are efficient (does not require
> bytewise memory accesses) and the atomic pointer update guarantees required by
> RCU are kept. u64 is considered as the largest type that can generate a trap for
> unaligned accesses (u64 on sparc32 needs to be aligned on 64-bit).
> 
> This alignment should be used for both structure definitions and declarations
> (as *both* the type and variable attribute) when using the "section"
> attribute to generate arrays of structures. Given that gcc only uses the type
> attribute "aligned" as a lower-bound for alignment, the structures should not
> contain types which require alignment larger than that of u64. The "aligned"
> variable attribute, on the other hand, forces gcc to use exactly the specified
> alignment.
> 
> Also introduce the linker script U64_ALIGN() macro for specification of custom
> section alignment that matches that of __u64_aligned.
> 
> Changelog since v2:
> - Drop the "packed" type attribute, because it causes gcc to drop the padding
>   between consecutive "int" and "pointer"/"long" fields, which leads to
>   unaligned accesses on sparc64.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Acked-by: David S. Miller <davem@davemloft.net>
