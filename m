Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab1IMSix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:38:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab1IMSiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:38:52 -0400
Date: Tue, 13 Sep 2011 20:38:36 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vmscan: fix initial shrinker size handling
Message-ID: <20110913183836.GA25998@redhat.com>
References: <20110822101721.19462.63082.stgit@zurg>
 <20110822232257.GT3162@dastard>
 <20110822163821.e746ab25.akpm@linux-foundation.org>
 <20110823000054.GW3162@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823000054.GW3162@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 10:00:54AM +1000, Dave Chinner wrote:
> On Mon, Aug 22, 2011 at 04:38:21PM -0700, Andrew Morton wrote:
> > On Tue, 23 Aug 2011 09:22:57 +1000
> > Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > On Mon, Aug 22, 2011 at 02:17:21PM +0300, Konstantin Khlebnikov wrote:
> > > > Shrinker function can returns -1, it means it cannot do anything without a risk of deadlock.
> > > > For example prune_super() do this if it cannot grab superblock refrence, even if nr_to_scan=0.
> > > > Currenly we interpret this like ULONG_MAX size shrinker, evaluate total_scan according this,
> > > > and next time this shrinker can get really big pressure. Let's skip such shrinkers instead.
> > > > 
> > > > Also make total_scan signed, otherwise check (total_scan < 0) below never works.
> > > 
> > > I've got a patch set I am going to post out today that makes this
> > > irrelevant.
> > 
> > Well, how serious is the bug?  If it's a non-issue then we can leave
> > the fix until 3.1.  If it's a non-non-issue then we'd need a minimal
> > patch to fix up 3.1 and 3.0.x.
> 
> I'm pretty sure it's a non-issue. I'm pretty sure all of the
> shrinkers return a count >= 0 rather than -1 when passed nr_to_scan
> == 0 (i.e.  they skip the GFP_NOFS checking), so getting a max_pass
> of -1 isn't going to happen very often....

Except for the case which Konstantin laid out, grabbing the super
block reference.  How likely is that?  And why isn't once enough to
build up quite a high number?

> And with total_scan being unsigned, the negative check is followed
> by a "if (total_scan > max_pass * 2)" check, which will catch
> numbers that would have gone negative anyway because max_pass won't
> be negative....

                total_scan = nr;
                max_pass = do_shrinker_shrink(shrinker, shrink, 0);
                delta = (4 * nr_pages_scanned) / shrinker->seeks;
                delta *= max_pass;
                do_div(delta, lru_pages + 1);
                total_scan += delta;

max_pass, an unsigned long, is what the shrinker returned, so
ULONG_MAX.  ULONG_MAX * 2 is ULONG_MAX - 1, still pretty big?

Even for high values of delta (lots of pages scanned, few lru pages
left), it won't come nowhere near max_pass such that the product of
the two is a reasonable number again.
