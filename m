Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1LAADR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:03:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab1LAADQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:03:16 -0500
Date: Thu, 1 Dec 2011 01:03:13 +0100
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
        esandeen@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Message-ID: <20111201000313.GG4541@quack.suse.cz>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20111128150400.GE6366@quack.suse.cz>
 <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz>
 <20111130140913.GX7595@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1111301136360.5759@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1111301136360.5759@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-11-11 11:53:40, Mikulas Patocka wrote:
> 
> 
> On Wed, 30 Nov 2011, Alasdair G Kergon wrote:
> 
> > On Tue, Nov 29, 2011 at 11:19:01AM +0100, Jan Kara wrote:
> > > So I believe the consensus was that we should not block sync or flusher
> 
> Well, I think that not blocking sync actually doesn't help at all.
> 
> Suppose at first that you have a perfectly-barriered filesystem --- that 
> is filesystem, that contains barriers around all code paths that could 
> possibly create dirty data. In this case it is impossible to have dirty 
> data while the filesystem is suspended. --- In this case you can call 
> sync on suspened filesystem as much as you like, sync never finds ady 
> dirty data, consequently it never tries to write anything and it can't 
> deadlock. So skipping sync has no effect.
> 
> Suppose as a second case that you have imperfectly-barriered filesystem 
> --- that means there exists a code path that creates dirty data while the 
> filesystem is suspended. In this case if you skip sync, you are violating 
> sync semantics, because the application can create dirty data while 
> suspended, call sync while still suspended and assume that the dirty data 
> was written.
  Except that currently we are in situation c) with e.g. ext4 and xfs. We
have perfectly-barriered filesystem *but* there are dirty bits set in this
filesystem although we are certain there are no dirty data. This
inconsistency between dirty bits and fact whether a page contains dirty
data is due to way how page faults are handled. I've already tried to
explain this in this thread in https://lkml.org/lkml/2011/11/29/109 but
apparently I failed. I can try to explain it once more but in fact I don't
think this technical detail makes a difference in this discussion. So in our
situation c) skipping sync makes difference and does not break guarantees
sync should have.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
