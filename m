Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1HWABA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:01:00 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61383 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814Ab1HWAA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:00:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJPsUk55LIxD/2dsb2JhbABBqCF4gUABAQU6HCMQCAMOCi4UJQMhE70sDoY6BKQh
Date: Tue, 23 Aug 2011 10:00:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vmscan: fix initial shrinker size handling
Message-ID: <20110823000054.GW3162@dastard>
References: <20110822101721.19462.63082.stgit@zurg>
 <20110822232257.GT3162@dastard>
 <20110822163821.e746ab25.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822163821.e746ab25.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 04:38:21PM -0700, Andrew Morton wrote:
> On Tue, 23 Aug 2011 09:22:57 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Mon, Aug 22, 2011 at 02:17:21PM +0300, Konstantin Khlebnikov wrote:
> > > Shrinker function can returns -1, it means it cannot do anything without a risk of deadlock.
> > > For example prune_super() do this if it cannot grab superblock refrence, even if nr_to_scan=0.
> > > Currenly we interpret this like ULONG_MAX size shrinker, evaluate total_scan according this,
> > > and next time this shrinker can get really big pressure. Let's skip such shrinkers instead.
> > > 
> > > Also make total_scan signed, otherwise check (total_scan < 0) below never works.
> > 
> > I've got a patch set I am going to post out today that makes this
> > irrelevant.
> 
> Well, how serious is the bug?  If it's a non-issue then we can leave
> the fix until 3.1.  If it's a non-non-issue then we'd need a minimal
> patch to fix up 3.1 and 3.0.x.

I'm pretty sure it's a non-issue. I'm pretty sure all of the
shrinkers return a count >= 0 rather than -1 when passed nr_to_scan
== 0 (i.e.  they skip the GFP_NOFS checking), so getting a max_pass
of -1 isn't going to happen very often....

And with total_scan being unsigned, the negative check is followed
by a "if (total_scan > max_pass * 2)" check, which will catch
numbers that would have gone negative anyway because max_pass won't
be negative....

So, grotty code but I don't think there is even a problem that can
be tripped right now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
