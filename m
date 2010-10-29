Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab0J2VWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 17:22:39 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:43033 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932982Ab0J2VWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 17:22:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKvWykxGGOIS/2dsb2JhbAChUHLADoVIBA
Date: Fri, 29 Oct 2010 16:42:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        David Daney <ddaney@caviumnetworks.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>, rth@redhat.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, dsd@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
Message-ID: <20101029204233.GA28585@Krystal>
References: <20101028201112.GA4792@redhat.com> <20101029063450.GE29463@elte.hu> <1288354687.18238.433.camel@gandalf.stny.rr.com> <20101029122230.GA25663@elte.hu> <1288356418.18238.454.camel@gandalf.stny.rr.com> <20101029133524.GA23916@Krystal> <1288369108.29632.1.camel@gandalf.stny.rr.com> <4CCB01D1.2050004@caviumnetworks.com> <1288373582.29632.3.camel@gandalf.stny.rr.com> <4CCB2B7B.6020002@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4CCB2B7B.6020002@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:29:21 up 205 days,  6:19,  3 users,  load average: 0.15, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 10/29/2010 10:33 AM, Steven Rostedt wrote:
> >>
> >> Should this knowledge be builtin to the jump label enabling calculus?
> > 
> > No, because we can't trust versions. We never know what home grown gcc a
> > kernel developer is using (and what has been backported or not). Thus
> > the only option is to have a builtin test we can do at compile time to
> > determine if the bug exists or not and decide then.
> > 
> > Note, I'm currently running my last set of patches through ktest. When
> > it finishes (presumably with no issues), I'll post a pull request.
> > 
> 
> I disagree with that assessment.
> 
> We know that if version >= 4.5.2 the problem has been fixed, and that
> for earlier versions we can't know if it's there, so just disable it for
> gcc < 4.5.2.  The fix might have been backported, but it's not a big
> deal if the users of backported compilers don't see the full benefit --
> it's only a problem during a limited time window anyway.

I agree with HPA here. Moreover, we have no hard guarantee that the
automated assembly inspection proposed won't be breaked in the future
caused by changes in gcc. Compiling and running a user-level runtime
test at kernel build time does not work with cross-compilers, and
matching the exact options used for kernel builds might be hard.

I would tend to argue that the added longer-term maintainance burden of
adding such a test is far worse than leaving gcc < 4.5.2 users without
static jump patching, especially given that we have a fallback.

For now, we know that x86_64 works, but the standard setup for x86_32
kernel is broken. What do we do if testing shows that some other
architecture has similar issues ? Add more work-arounds ? At this early
stage, I would simply bump the gcc version dependency forward for all
architectures. Later on, after things have settled and as more and more
architectures are supported, we could deal with arch-specific breakages
on a per-architecture basis.

If this was a showstopper feature, my position would be different. But
the fact that we have been able to wait for gcc to integrate asm gotos
while adding tracepoints shows that it's not crucial in the short term.
We still have to be careful when adding new tracepoints anyway as long
as gcc < 4.5 is still widely used.

Thanks,

Mathieu

> 
> Admittedly it would be nice to have a header file or even a
> configuration file where the gcc version is tested and workarounds are
> centralized; then the backporters could put their own overrides in there.
> 
> 	-hpa

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
