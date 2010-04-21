Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0DUMhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:37:15 -0400
Received: from soto.provo.novell.com ([137.65.250.214]:53875 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0DUMhM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-GHaskins@novell.com:6:1>);
	Wed, 21 Apr 2010 08:37:12 -0400
Message-Id: <4BCEB92E0200005A00065162@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 21 Apr 2010 06:37:02 -0600
From: "Gregory Haskins" <GHaskins@novell.com>
To: <peterz@infradead.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <akpm@linux-foundation.org>,
       <jkacur@redhat.com>, <lgoncalv@redhat.com>, <williams@redhat.com>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH v3] lockdep: Make MAX_STACK_TRACE_ENTRIES
	 configurable.
References: <4BCEB92D0200005A0006515F@soto.provo.novell.com>
 <4BCEB92E0200005A00065162@soto.provo.novell.com>
In-Reply-To: <4BCEB92E0200005A00065162@soto.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for top post..mobile)

Ya, I totally see and understand your point.  "Fix the problem and not the symptom" and all.  That is probably the best idea.

The only thing I can say is I think debug and/or -rt kernels exacerbate the issue, and it seemed like a growing problem.  (E.g. Iirc over the years, people periodically submitting patches to -rt making it larger and larger, yet leading edge dev still tended to require carrying a custom patch making it larger still).

So any work that goes into quantifing the large (and growing) footprint of this structure is probably time well spent to at least understand why.  In the meantime, I would still personally endorse Johns approach as a stopgap.  Its a better solution than code patching, and the CONFIG can always go away when it no longer serves a purpose.  

That said, the bottom line is that the structure size will probably always be specific to a multitude of factors such as hardware and workload and perhaps cannot ever be truely "one size fits all".  Therefore, this might ultimately be best left as tunable...its all relative even if the overall efficiency of the subsystem is improved as part of this investigation.

My 2 cents ;)

Kind regards,
-Greg 
-----Original Message-----
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <GHaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc:  <linux-kernel@vger.kernel.org>
Cc:  <linux-rt-users@vger.kernel.org>

Sent: 4/21/2010 8:03:00 AM
Subject: Re: [PATCH v3] lockdep: Make MAX_STACK_TRACE_ENTRIES configurable.

On Wed, 2010-04-21 at 05:47 -0600, Gregory Haskins wrote:
> 
> I am not sure if Johns solution is the right/best one per se, but I can attest
> that I used to hit this problem _all_ the time and it was somewhat annoying
> to need to patch the kernel on all of my machines to fix it.  I realize that I
> perhaps do not represent the average user, but it was a pain-point for me.
> FWIW, John's patch would indeed make my life easier since I tend to share the
> .config between builds. 

Right, so all I'm wanting to know if its a symptom of some funny or an
actual depletion, in the latter case I think the best solution is to
simply increase the number. In the former case we should of course fix
the real issue instead of making it disappear.

So one case I remember is where some code managed to create 1k classes
where 1 would have sufficed, this resulted in at least 1k extra stack
traces to be stored, consuming vast amounts of stack_entries.

So please, if you can reproduce, look at where these entries are going,
lots of classes with the same name are a good hint that something is
fishy. Classes with more than 13 (4*nr_states + 1) stacks should also
never happen, etc..

Is this specific to -RT, or do we see it without as well? If so, what in
-RT grows this? Are we creating a class per rt_mutex spinlock or
something silly like that?

--
To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

