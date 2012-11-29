Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab2K2BbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:31:13 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37511 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab2K2BbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:31:12 -0500
Date: Wed, 28 Nov 2012 17:27:51 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [RFC] Add mempressure cgroup
Message-ID: <20121129012751.GA20525@lizard>
References: <20121128102908.GA15415@lizard>
 <20121128151432.3e29d830.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121128151432.3e29d830.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 03:14:32PM -0800, Andrew Morton wrote:
[...]
> Compare this with the shrink_slab() shrinkers.  With these, the VM can
> query and then control the clients.  If something goes wrong or is out
> of balance, it's the VM's problem to solve.
> 
> So I'm thinking that a better design would be one which puts the kernel
> VM in control of userspace scanning and freeing.  Presumably with a
> query-and-control interface similar to the slab shrinkers.

Thanks for the ideas, Andrew.

Query-and-control scheme looks very attractive, and that's actually
resembles my "balance" level idea, when userland tells the kernel how much
reclaimable memory it has. Except the your scheme works in the reverse
direction, i.e. the kernel becomes in charge.

But there is one, rather major issue: we're crossing kernel-userspace
boundary. And with the scheme we'll have to cross the boundary four times:
query / reply-available / control / reply-shrunk / (and repeat if
necessary, every SHRINK_BATCH pages). Plus, it has to be done somewhat
synchronously (all the four stages), and/or we have to make a "userspace
shrinker" thread working in parallel with the normal shrinker, and here,
I'm afraid, we'll see more strange interactions. :)

But there is a good news: for these kind of fine-grained control we have a
better interface, where we don't have to communicate [very often] w/ the
kernel. These are "volatile ranges", where userland itself marks chunks of
data as "I might need it, but I won't cry if you recycle it; but when I
access it next time, let me know if you actually recycled it". Yes,
userland no longer able to decide which exact page it permits to recycle,
but we don't have use-cases when we actually care that much. And if we do,
we'd rather introduce volatile LRUs with different priorities, or
something alike.

So, we really don't need the full-fledged userland shrinker, since we can
just let the in-kernel shrinker do its job. If we work with the
bytes/pages granularity it is just easier (and more efficient in terms of
communication) to do the volatile ranges.

For the pressure notifications use-cases, we don't even know bytes/pages
information: "activity managers" are separate processes looking after
overall system performance.

So, we're not trying to make userland too smart, quite the contrary: we
realized that for this interface we don't want to mess with the bytes and
pages, and that's why we cut this stuff down to only three levels. Before
this, we were actually trying to count bytes, we did not like it and we
ran away screaming.

OTOH, your scheme makes volatile ranges unneeded, since a thread might
register a shrinker hook and free stuff by itself. But again, I believe
this involves more communication with the kernel.

Thanks,
Anton.
