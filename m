Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab2HOWTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:19:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49779 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2HOWTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:19:40 -0400
Date: Wed, 15 Aug 2012 15:19:36 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 05/12] block: Kill bi_destructor
Message-ID: <20120815221936.GC2758@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-6-git-send-email-koverstreet@google.com>
 <20120808222223.GD6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809002154.GE7262@moria.home.lan>
 <20120809060517.GB2845@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809061214.GA9128@dhcp-172-18-216-138.mtv.corp.google.com>
 <CAOS58YOHZmNWezg0uDhDeKP1dAt8fmmcLjmzKGShrw6PCpCFpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YOHZmNWezg0uDhDeKP1dAt8fmmcLjmzKGShrw6PCpCFpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 11:34:09PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 8, 2012 at 11:12 PM, Kent Overstreet <koverstreet@google.com> wrote:
> > But if it's a pointer to heap allocated memory, but the bio was embedded
> > in another struct? I've seen a fair number of instances of that (md, off
> > the top of my head).
> >
> > If you're sure that in a normal config the slab allocator is going to
> > complain right away and not corrupt itself, fine. But I've been bitten
> > way too hard by bugs that could've been caught right away by a simple
> > assert and instead I had to spend hours backtracking, and the block
> > layer is _rife_ with that kind of thing.
> 
> Let's let slab debug code deal with that.  I really don't see much
> benefit in doing this.  The said kind of bugs aren't particularly
> difficult to track down.

The only difference would be changing
#define BIO_KMALLOC_POOL ((void *) ~0)

to
#define BIO_KMALLOC_POOL NULL

We want a define for this - bio_alloc_bioset(GFP_KERNEL, 1, NULL)
doesn't make any sense. I just don't see the argument for changing an
arbitrary constant... If it's just the ~0 pointer you don't like, I
originally used a real statically allocated struct bio_set as a sentinel
value.
