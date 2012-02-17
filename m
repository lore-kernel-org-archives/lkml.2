Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2BQWOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:14:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50931 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2BQWOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:14:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.234.8 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Fri, 17 Feb 2012 14:14:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120217221406.GJ29414@google.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217011907.GA15073@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Thu, Feb 16, 2012 at 05:19:07PM -0800, Kent Overstreet wrote:
> On Thu, Feb 16, 2012 at 02:37:56PM -0800, Tejun Heo wrote:
> > This patch implements bio_associate_current() which associates the
> > specified bio with %current.  The bio will record the associated ioc
> > and blkcg at that point and block layer will use the recorded ones
> > regardless of which task actually ends up issuing the bio.  bio
> > release puts the associated ioc and blkcg.
> 
> Excellent.
> 
> Why not have bio_associate_current() called from submit_bio()? I would
> expect that's what we want most of the time, and the places it's not
> (mainly writeback) calling it before submit_bio() would do the right
> thing.
> 
> It'd make things more consistent - rq_ioc() could be dropped, and
> incorrect usage would be more obvious.

Yeah, maybe, I was mostly trying to avoid adding extra operations on
common paths as explicit task association isn't that common, at least
for now.  That said, I agree that things can be much cleaner just
allocating and associating stuff upfront - ie. always have ioc and
associate blkcg with IOs on issue.

If the associated blkcg is used consistently through block layer, it
might be better but cfq doesn't even do that.  It has its own icq ->
blkcg mapping, which it initializes on first cfqq association.  It
even ignores tasks migrating to a different cgroup and keeps using
whatever cgroup the task first issued IOs on. :(

I don't know.  Maybe someday.

Thanks.

-- 
tejun
