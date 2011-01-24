Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1AXUe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:34:59 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59650 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1AXUe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:34:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T5PjwW8Po1CAAF7HNnkxgGy0+6fdbUw8DstblrSWwNTtp80HjCZKN9/hBa1BETlzuL
         oCYq8EE7vINYA0KCc1g6qKU9X/htfEtR4WhrYbT5qvRDWRugXJ3bRr8fmptfRmKoxvPM
         xqwC45CAF9pdYj8LFISGR43AQNX5qhhrAp75I=
Date: Mon, 24 Jan 2011 21:34:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: tardyp@gmail.com, jean.pihet@newoldbits.com, acme@ghostprotocols.net,
        linux-perf-users@vger.kernel.org, mathieu.desnoyers@efficios.com,
        linux-trace-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Perf ABI versioning
Message-ID: <20110124203449.GC2318@nowhere>
References: <201101241704.01021.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101241704.01021.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding LKML and more tracing people in Cc)

On Mon, Jan 24, 2011 at 05:04:00PM +0100, Thomas Renninger wrote:
> Hi,
> 
> as I recently cleaned up the power events with
> some format/abi adjustings...
> 
> I realized that it was rather easy to adjust
> the stuff in drivers/tools/perf, because there
> are some nice facilities to query which events
> are available.
> 
> I looked at pytimechart, there it's not that nice
> and convenient would be some kind of version number.
> 
> pytimechart can parse traces which are simply copied
> away from /sys/kernel/debug/trace and to check for
> available events and their format, one would have to
> do a separate, ugly to implement, iteration of parsing.
> 
> Would it make sense to introduce a trace
> ABI version number?
> It would be enough to increase it by one every time
> any event (don't know about other perf facilities) is
> added, removed or modified.
> Ideally the modifications are tracked with a short
> description in a file like Documentation/trace/format.changes
> 
> Untested, but the patch at the end should simply add
> a version number on top of
> /sys/kernel/debug/trace file
> 
> While this should be enough for the kernel, perf record
> would need to include it into it's binary perf.data format
> as well?
> 
> Then userspace apps could easily test whether supported
> events would be included at all, whether only a subset of
> supported events were made available and which format they have.
> 
> Does this make sense?

This may be generally useful to help dealing with tracepoint ABI
changes.

But instead of a global tracing ABI number, I would rather suggest
one number per tracepoint subsystem (sched, power, etc...).

Ideally it would be per event, but sometimes those events tend to be
renamed or a whole tracepoint subsystem refactored (see workqueue
lately). Hence it might be better per subsystem.

Now these numbers can be increased in the case of new fields added,
fields removed, fields renamed, new tracepoints, removed tracepoints,
renamed tracepoints.

But I think we shouldn't do that for pure ascii format changes, because
we created the format to avoid fixing that on the rock. I know that
would help Pytimechart, and it's a precious tool that I wish we can help
the development. But we shouldn't encourage the pattern match way of
parsing events, instead of using the format file.

Also, tracking the changes in the Documentation is going to be a
nightmare. I suggest developers who want to dig into details of
an ABI change to check the code or the format themselves.

And BTW we can probably provide more granularity in the versioning
with a major number for ABI changes that may break tools (field or
tracepoint removal, rename, etc...) and a minor number for changes
that probably won't break tools but could bring them more informations:
new tracepoint fields, new tracepoints, etc... so we can tell the tools
about that.

Hm?
