Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab1ASPLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:11:41 -0500
Received: from mail.openrapids.net ([64.15.138.104]:36894 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754152Ab1ASPLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:11:41 -0500
Date: Wed, 19 Jan 2011 10:11:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119151139.GB11022@Krystal>
References: <20110118201323.GA14930@Krystal> <1295382144.12215.123.camel@gandalf.stny.rr.com> <20110119050844.GA8776@Krystal> <20110118.223247.241909079.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118.223247.241909079.davem@davemloft.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:10:19 up 56 days, 20:13,  5 users,  load average: 0.13, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Date: Wed, 19 Jan 2011 00:08:45 -0500
> 
> > - No aligned() type attribute nor variable attribute. I get a crash on x86_64
> >   (NULL pointer exception when executing __trace_add_event_call, the 5th call).
> >   __alignof__(struct ftrace_event_call) is worth 8.
> 
> I think I figured it out.
> 
> It's the static vs. non-static thing, or some other crazyness wrt.
> how x86-64 implements it's alignment rules.
> 
> GCC on x86-64 uses a completely different policy for aligning local
> (ie. "static") data objects vs. globally visible ones, for one thing.
> It also has different alignment policies for objects that are part
> of an array vs. those which are not.
> 
> On both counts, we're lying to the compiler, so maybe it's sort of our
> fault.

Yep, we're in strong agreement here.

> 
> As far as GCC can see, the object is static and also not part of an
> array or any other C construct for which things like this could matter
> as long as the alignment it chooses meets the minimum alignment
> requirements of the ABI.
> 
> So it doesn't let us do this trick where we put the individual event
> markers into a special section, yet mark it __used and static, then
> later access them as if they were part of a globally visible array.
> 
> If you look these static objects, they are emitted with a leading
> ".align 32" directive.  This is what screws everything up.

Ah, yep, good way to identify the culprit.

> 
> When the linker sees this, it aligns the start of every individual
> "_ftrace_events" section, and that's where the "gaps" come from and
> the crashes.

OK (more to come in the following email response).

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
