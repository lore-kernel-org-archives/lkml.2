Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0IVUqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:46:07 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:40593 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597Ab0IVUqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:46:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABYFmkxGGN6i/2dsb2JhbACiLHLFf4MDCII2BI8w
Date: Wed, 22 Sep 2010 16:41:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, jbaron@redhat.com, rostedt@goodmis.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
Message-ID: <20100922204101.GA3012@Krystal>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <1285150102-5506-2-git-send-email-andi@firstfloor.org> <4C9A2AED.3050801@zytor.com> <20100922194331.GB28463@Krystal> <4C9A61AE.3080804@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4C9A61AE.3080804@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:31:11 up 168 days,  6:21,  6 users,  load average: 0.18, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 09/22/2010 12:43 PM, Mathieu Desnoyers wrote:
> > * H. Peter Anvin (hpa@zytor.com) wrote:
> >> On 09/22/2010 03:08 AM, Andi Kleen wrote:
> > 
> > That's a very interesting idea, which applies very well to exception
> > handlers, but tracepoints and static jumps suffer from the problem that
> > there are many possible instances of the same key.
> > 
> > Tracepoints use a lookup by tracepoint name. Static jumps use a lookup
> > by associated variable address (but this variable can be associated with
> > many instances, e.g. in the case of static inline functions, or just
> > when the same variable is used to control many instances of static
> > jumps).
> > 
> > But maybe we could find a way to do an initial sort phase, so the
> > perfect hash could point to the first entry corresponding to the looked
> > up key ?
> > 
> 
> In the case of multiple instances of the same key you want the perfect
> hash to point to the cluster of solutions -- a list.  Since this is by
> simply be an array.

Yep, and sorting the section seems like a very natural way to create
these arrays. So to summarize:

- We add a post-linking step to core image and module build in
  modpost.c.
- This step accesses exception tables, tracepoint and static jump
  sections.
  - Both tracepoint and static jump need to be sorted.
  - For each of the 3 sections, a perfect hash is computed (creation
    must have the property to always succeed). The perfect hash creation
    should only take into account the first entry of duplicate keys.
  - Each of these perfect hash would translate into C code that would
    need to be compiled in a post-link phase.
  - Then we can link the perfect hash objects with the rest of the code,
    filling in one symbol per considered section (function pointer to
    the perfect hash function) and setting function pointers in struct
    module for modules.

I'm mostly writing this down as food for thoughts, since my own
implementation time is currently focused on other things.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
