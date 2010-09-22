Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab0IVTne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:43:34 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:36269 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767Ab0IVTnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:43:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOb4mUxGGN6i/2dsb2JhbACiK3LFYYVBBI8w
Date: Wed, 22 Sep 2010 15:43:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, jbaron@redhat.com, rostedt@goodmis.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
Message-ID: <20100922194331.GB28463@Krystal>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <1285150102-5506-2-git-send-email-andi@firstfloor.org> <4C9A2AED.3050801@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4C9A2AED.3050801@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:29:02 up 168 days,  5:19,  5 users,  load average: 0.61, 0.32,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 09/22/2010 03:08 AM, Andi Kleen wrote:
>>
>> I believe it's also much cleaner than before.
>>
>> I did some performance tests comparing the hash implementation
>> with the binary search. This was with a moderate config x86-64
>> kernel with 68 modules loaded and about 480 trace points active
>> in several modules and 1340 dynamic debug statements.
>>
>
> Now, the ideal data structure for this stuff is something called a  
> minimal perfect hash.  This is something that would have to be generated  
> (for each module and for the monolithic kernel) at compile time --  
> presumably in modpost -- because the static generation of them is fairly  
> complex.
>
> That would provide extremely simple handling in the kernel (just do some  
> shifts and a table lookup and you have your answer) and if combined with  
> an AVL or red-black tree holding the module addresses it would give  
> extremely fast address-to-metadata lookup, not just for this but also  
> for things like exception handling.
>
> I have used MPH's in other projects and pitched them to Linus at one  
> point for exception handling.  What is clear, though, is that we should  
> do the same thing for exceptions, trace points, and any other similar  
> things that depend on exact PC.

That's a very interesting idea, which applies very well to exception
handlers, but tracepoints and static jumps suffer from the problem that
there are many possible instances of the same key.

Tracepoints use a lookup by tracepoint name. Static jumps use a lookup
by associated variable address (but this variable can be associated with
many instances, e.g. in the case of static inline functions, or just
when the same variable is used to control many instances of static
jumps).

But maybe we could find a way to do an initial sort phase, so the
perfect hash could point to the first entry corresponding to the looked
up key ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
