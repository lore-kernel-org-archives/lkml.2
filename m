Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2EaLG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:06:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45856 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2EaLG5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:06:57 -0400
Message-ID: <1338462398.28384.52.camel@twins>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 13:06:38 +0200
In-Reply-To: <20120531020440.476352979@goodmis.org>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 21:28 -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> When the function tracer starts modifying the code via breakpoints
> it sets a variable (modifying_ftrace_code) to inform the breakpoint
> handler to call the ftrace int3 code.
> 
> But there's no synchronization between setting this code and the
> handler, thus it is possible for the handler to be called on another
> CPU before it sees the variable. This will cause a kernel crash as
> the int3 handler will not know what to do with it.
> 
> I originally added smp_mb()'s to force the visibility of the variable
> but H. Peter Anvin suggested that I just make it atomic.

Uhm,. maybe. atomic_{inc,dec}() implies a full memory barrier on x86,
but atomic_read() never has the smp_rmb() required.

Now smp_rmb() is mostly a nop on x86, except for CONFIG_X86_PPRO_FENCE.

So this should mostly work, but yuck.


Also, why does this stuff live in ftrace? I always thought you were
going to replace text_poke() so everybody that uses cross-modifying code
could profit?


