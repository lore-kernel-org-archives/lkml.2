Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1F3QVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:21:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928Ab1F3QVS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:21:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110630121710.GJ11559@pengutronix.de>
References: <20110630142910.2fea4257.sfr@canb.auug.org.au> <20110630072559.GA4048@pengutronix.de>
 <20110630193023.6056d48e.sfr@canb.auug.org.au> <20110630121710.GJ11559@pengutronix.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 30 Jun 2011 09:20:35 -0700
Message-ID: <BANLkTi=usrsF60Popfu55v3_dXe7Yo0GrA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the security-testing tree with the tree
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, James Morris <jmorris@namei.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        git@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/30 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>
> A flag would be nice that does what I did: redo the merge and compare
> bcd05ca10420^{tree} with the result?

The problem with that is that it's *way* too expensive an operation to
do for the normal "git log" kind of operations.

Also, truly re-doing the merge actually requires workspace access
and/or require new objects to be created, so it would be inappropriate
anyway: git log/show absolutely has to be a read-only operation,
anything else would be totally insane.

So there's no way - both for performance and 'fundamental' reasons -
to make the normal logging code truly re-do the merge and then compare
the end result of the merge with the end result that is in the tree.

That said, what the current "git show/log" does is to just compare the
end points with the merge result, which means that if the end result
matches either of the end-points, nothing will be shown. That works
for the common cases, but it absolutely doesn't work if somebody does
something crazy, and just picks one end-point over another without
doing a proper merge (ie "-s ours" or just a mis-merge). But the
reason it's done that way is that it's possible to do without re-doing
the merge.

It would be lovely if "git show" (and log operations) had some option
to do a "expensive merge check" and did actually figure out the common
ancestor and at least took that into account.

It would be doable to do it at least better than we do now - the
common ancestor is not cheap to compute, but it's much cheaper than a
full merge, and would at least allow us to flag dangerous merges. Of
course, it gets fun when there are multiple common ancestors and
renames. It's entirely possible that it's never going to be practical
to do anything but "re-do the merge and compare result".

                      Linus
