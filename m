Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1FURIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:08:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19375 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1FURIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=qFDoBe4+HMXld8K9lDGbZfnJKU3+fndfKhaHUx3Oaeo2UHPYVS4Un4WBLoydP7Rfnt
         FBv2V7CXQMz8LT2DaCPw==
MIME-Version: 1.0
In-Reply-To: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
From: Paul Menage <menage@google.com>
Date: Tue, 21 Jun 2011 10:08:26 -0700
Message-ID: <BANLkTineKOcQDzMrCdmizOhUGz+cViTomA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] cgroups: Start a basic rlimit subsystem
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederick,

On Sun, Jun 19, 2011 at 4:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> This starts a basic rlimit cgroup subsystem with only the
> equivalent of RLIMIT_NPROC yet. This can be useful to limit
> the global effects of a local fork bomb for example (local
> in term of a cgroup).

My general thoughts on this are:

- do we really want an "rlimit" subsystem rather than grouping things
functionally? We definitely shouldn't just stuff things in here
because they happen to be controlled via setrlimit currently. Also,
some limits might fit more appropriately in other subsystems. (E.g.
max locked memory should be a memcg field, and real-time priority
should be in the cpu subsystem if it's not already subsumed by
existing functionality). Grouping "rlimit" things together in a single
subsystem reduces flexibility, since you can't then mount them on
separate hierarchies. (This is actually related to one of my regrets
about the original implementation of cgroups - the cpuset subsystem
should have been split into a "cpunode" subsystem and a "memnode"
subsystem, since the two parts of cpusets had no requirement to be
located together - they were only linked since before cgroups there
was no way to mount them separately).

A lot of the rlimit values are more for the benefit of the process (to
prevent runaways) rather than for resource isolation - data segment
size, file size, stack size, pending signals, virtual memory limits
fall into that category, i think - they're all resource usage that
falls under existing cgroup resource limits, such as
memory.limit_in_bytes.

Task count is a little blurry in this regard - the main resources that
you can consume with a fork bomb are CPU cycles and memory, both of
which are already isolated by existing subsystems, so arguably there
shouldn't be a need to control the number of tasks itself. But I'm
prepared to believe that there are still bits of the kernel that have
arbitrary machine-wide limits that can be hit simply by forking a
massive number of processes, even if they're not using much memory or
CPU cycles.

So for this case, I'd suggest that the best option is to have a
numtasks subsystem with "count" and "limit" files. Future rlimit
options can go in their own subsystems or be attached to existing
subsystems if that makes sense.

Paul
