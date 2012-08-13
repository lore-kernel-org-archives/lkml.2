Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2HMVzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:55:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61022 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2HMVzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:55:15 -0400
Date: Mon, 13 Aug 2012 14:55:11 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 08/12] block: Introduce new bio_split()
Message-ID: <20120813215511.GE9541@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-9-git-send-email-koverstreet@google.com>
 <20120808225839.GG6983@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808225839.GG6983@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 03:58:39PM -0700, Tejun Heo wrote:
> On Mon, Aug 06, 2012 at 03:08:37PM -0700, Kent Overstreet wrote:
> > + *
> > + * BIG FAT WARNING:
> > + *
> > + * If you're calling this from under generic_make_request() (i.e.
> > + * current->bio_list != NULL), you should mask out __GFP_WAIT and punt to
> > + * workqueue if the allocation fails. Otherwise, your code will probably
> > + * deadlock.
> 
> If the condition is detectable, WARN_ON_ONCE() please.

I know I said I liked this idea, but I changed my mind.

Sticking a WARN_ON_ONCE() there is saying that passing __GFP_WAIT from
under generic_make_request() is always wrong - it might as well be a
BUG_ON() except warn is better for the user.

If that's true, then an assertion is completely wrong because we can
just do the right thing instead - mask out __GFP_WAIT if
current->bio_list != NULL and document that it can fail in that
situation.

Which is what my original code did.

The alternative is accepting that there are situations where it is
technically possible to pass __GFP_WAIT from under
generic_make_request() without deadlocking and allow it, but my position
is still that that is far too subtle to expect that it'll be gotten
right (especially considering the ways that the code is wrong today
wrt deadlocks).

But honestly this is turning into bikeshedding. The current bio
splitting and merge_bvec_fn stuff is crap, and there are worse potential
deadlocks/bugs in the existing code than what we're arguing over here.
