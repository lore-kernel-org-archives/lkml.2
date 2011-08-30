Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1H3GI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 02:08:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:7643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab1H3GI2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 02:08:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=L6/N/iaMX9+SRP+/dtZQ6f8qcxzgv47lnAYPUrC7ywpVEAnf5pDMiAS50uhXHuQvg
	WxBpuAuZvNaYeU51eu7xQ==
MIME-Version: 1.0
In-Reply-To: <20110829075731.GA32114@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<1306909519-7286-3-git-send-email-hannes@cmpxchg.org>
	<CALWz4iwChnacF061L9vWo7nEA7qaXNJrK=+jsEe9xBtvEBD9MA@mail.gmail.com>
	<20110811210914.GB31229@cmpxchg.org>
	<CALWz4iwJfyWRineMy+W02YBvS0Y=Pv1y8Rb=8i5R=vUCfrO+iQ@mail.gmail.com>
	<CALWz4iwRXBheXFND5zq3ze2PJDkeoxYHD1zOsTyzOe3XqY5apA@mail.gmail.com>
	<20110829075731.GA32114@cmpxchg.org>
Date: Mon, 29 Aug 2011 23:08:16 -0700
Message-ID: <CALWz4iw4ojn7GUJgWDV9wqGeXf-Oy0uDx0yJUhJpkuP5tffMwA@mail.gmail.com>
Subject: Re: [patch 2/8] mm: memcg-aware global reclaim
From: Ying Han <yinghan@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 12:57 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Mon, Aug 29, 2011 at 12:22:02AM -0700, Ying Han wrote:
> > fix hierarchy_walk() to hold a reference to first mem_cgroup
> >
> > The first mem_cgroup returned from hierarchy_walk() is used to
> > terminate a round-trip. However there is no reference hold on
> > that which the first could be removed during the walking. The
> > patch including the following change:
> >
> > 1. hold a reference on the first mem_cgroup during the walk.
> > 2. rename the variable "root" to "target", which we found using
> > "root" is confusing in this content with root_mem_cgroup. better
> > naming is welcomed.
>
> Thanks for the report.
>
> This was actually not the only case that could lead to overlong (not
> necessarily endless) looping.
>
> With several scanning threads, a single thread may not encounter its
> first cgroup again for a long time, as the other threads would visit
> it.

Yes, that makes sense. And I think i found a issue on my patch which
it leaks reference count on the mem (first) which I can not do "rmdir"
after some memory pressure tests. So, please ignore the patch for now.

>
> I changed this to use scan generations.  Restarting the scan from id 0
> starts the next scan generation.  The iteration function returns NULL
> if the generation changed since a loop was started.
>
> This way, iterators can reliably detect whether they should call it
> quits without any requirements for previously encountered memcgs.

Ok, so if I have multiple threads hitting pressure under the same zone
and same memcg hierarchy tree, they all contribute to the single
iteration loop. And all the reclaimers will terminate if they together
made a full iteration under the hierarchy?

If so, i will look at your patch and no need for the fix i posted
early on. Meanwhile, I would be interested to look at some performance
data since the later one should save some cpu cycles going through
more memcgs than after the change.

Thanks

--Ying
