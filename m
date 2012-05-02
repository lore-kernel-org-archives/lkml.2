Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2EBAVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 20:21:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41353 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2EBAVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 20:21:51 -0400
Date: Tue, 1 May 2012 17:20:27 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Glauber Costa <glommer@parallels.com>, kamezawa.hiroyu@jp.fujitsu.com,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v4] vmevent: Implement greater-than attribute state and
 one-shot mode
Message-ID: <20120502002026.GA3334@lizard>
References: <20120418083208.GA24904@lizard>
 <20120418083523.GB31556@lizard>
 <alpine.LFD.2.02.1204182259580.11868@tux.localdomain>
 <20120418224629.GA22150@lizard>
 <alpine.LFD.2.02.1204190841290.1704@tux.localdomain>
 <20120419162923.GA26630@lizard>
 <20120501131806.GA22249@lizard>
 <4FA04FD5.6010900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FA04FD5.6010900@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rik,

Thanks for looking into this!

On Tue, May 01, 2012 at 05:04:21PM -0400, Rik van Riel wrote:
> On 05/01/2012 09:18 AM, Anton Vorontsov wrote:
> >This patch implements a new event type, it will trigger whenever a
> >value becomes greater than user-specified threshold, it complements
> >the 'less-then' trigger type.
> >
> >Also, let's implement the one-shot mode for the events, when set,
> >userspace will only receive one notification per crossing the
> >boundaries.
> >
> >Now when both LT and GT are set on the same level, the event type
> >works as a cross event type: it triggers whenever a value crosses
> >the threshold from a lesser values side to a greater values side,
> >and vice versa.
> >
> >We use the event types in an userspace low-memory killer: we get a
> >notification when memory becomes low, so we start freeing memory by
> >killing unneeded processes, and we get notification when memory hits
> >the threshold from another side, so we know that we freed enough of
> >memory.
> 
> How are these vmevents supposed to work with cgroups?

Currently these are independent subsystems, if you have memcg enabled,
you can do almost anything* with the memory, as memg has all the needed
hooks in the mm/ subsystem (it is more like "memory management tracer"
nowadays :-).

But cgroups have its cost, both performance penalty and memory wastage.
For example, in the best case, memcg constantly consumes 0.5% of RAM to
track memory usage, this is 5 MB on a 1 GB "embedded" machine.  To some
people it feels just wrong to waste that memory for mere notifications.

Of course, this alone can be considered as a lame argument for making
another subsystem (instead of "fixing" the current one). But see below,
vmevent is just a convenient ABI.

> What do we do when a cgroup nears its limit, and there
> is no more swap space available?
> 
> What do we do when a cgroup nears its limit, and there
> is swap space available?

As of now, this is all orthogonal to vmevent. Vmevent doesn't know
about cgroups. If kernel has the memcg enabled, one should probably*
go with it (or better, with its ABI). At least for now.

> It would be nice to be able to share the same code for
> embedded, desktop and server workloads...

It would be great indeed, but so far I don't see much that
vmevent could share. Plus, sharing the code at this point is not
that interesting; it's mere 500 lines of code (comparing to
more than 10K lines for cgroups, and it's not including memcg_
hooks and logic that is spread all over mm/).

Today vmevent code is mostly an ABI implementation, there is
very little memory management logic (in contrast to the memcg).

Personally, I would rather consider sharing ABI at some point:
i.e. making a memcg backend for the vmevent. That would be pretty
cool. And once done, vmevent would be cgroups-aware (if memcg
enabled, of course; and if not, vmevent would still work, with
no memcg-related expenses).

* For low memory notifications, there are still some unresolved
  issues with memcg. Mainly, slab accounting for the root cgroup:
  currently developed slab accounting doesn't account kernel's
  internal memory consumption, plus it doesn't account slab memory
  for the root cgroup at all.

  A few days ago I asked[1] why memcg doesn't do all this, and
  whether it is a design decision or just an implementation detail
  (so that we have a chance to fix it).

  But so far there were no feedback. We'll see how things turn out.

  [1] http://lkml.org/lkml/2012/4/30/115


Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
