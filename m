Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2HIGMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:12:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51195 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab2HIGMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:12:13 -0400
Date: Thu, 9 Aug 2012 02:12:14 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 05/12] block: Kill bi_destructor
Message-ID: <20120809061214.GA9128@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-6-git-send-email-koverstreet@google.com>
 <20120808222223.GD6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809002154.GE7262@moria.home.lan>
 <20120809060517.GB2845@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809060517.GB2845@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 11:05:17PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 08, 2012 at 05:21:54PM -0700, Kent Overstreet wrote:
> > > What's wrong with good ol' NULL?
> > 
> > If it's NULL, we can't distinguish between bios where that field wasn't
> > set (i.e. bios that were statically allocated somewhere) from bios that
> > were allocated by bio_kmalloc().
> > 
> > It's just there to make debugging easier - if bi_cnt goes to 0 on a bio
> > where it shouldn't we'll catch it at the BUG_ON() in bio_free() instead
> > of kfreeing a bad pointer.
> 
> I fail to see how that improves anything.  slab will complain clearly
> if it gets passed in a pointer to static area.  The benefit is
> imaginery.  If there's no bioset, it's NULL.  Let's please keep things
> usual.

But if it's a pointer to heap allocated memory, but the bio was embedded
in another struct? I've seen a fair number of instances of that (md, off
the top of my head).

If you're sure that in a normal config the slab allocator is going to
complain right away and not corrupt itself, fine. But I've been bitten
way too hard by bugs that could've been caught right away by a simple
assert and instead I had to spend hours backtracking, and the block
layer is _rife_ with that kind of thing.
