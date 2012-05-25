Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab2EYWj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:39:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab2EYWjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:39:54 -0400
Date: Fri, 25 May 2012 23:39:37 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>,
        Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net,
        mpatocka@redhat.com, vgoyal@redhat.com, bharrosh@panasas.com,
        tj@kernel.org, sage@newdream.net, agk@redhat.com,
        drbd-dev@lists.linbit.com, Dave Chinner <dchinner@redhat.com>,
        tytso@google.com
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Message-ID: <20120525223937.GF5761@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	yehuda@hq.newdream.net, mpatocka@redhat.com, vgoyal@redhat.com,
	bharrosh@panasas.com, tj@kernel.org, sage@newdream.net,
	agk@redhat.com, drbd-dev@lists.linbit.com,
	Dave Chinner <dchinner@redhat.com>, tytso@google.com
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-15-git-send-email-koverstreet@google.com> <20120525204651.GA24246@redhat.com> <20120525210944.GB14196@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525210944.GB14196@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where's the urge to remove merge_bvec coming from?

I think it's premature to touch this, and that the other changes, if
fixed and integrated, should be allowed to bed themselves down first.


Ideally every bio would be the best size on submission and no bio would
ever need to be split.

But there is a cost involved in calculating the best size - we use
merge_bvec for this, which gives a (probable) maximum size.  It's
usually very cheap to calculate - but not always.  [In dm, we permit
some situations where the answer we give will turn out to be wrong, but
ensure dm will always fix up those particular cases itself later and
still process the over-sized bio correctly.]

Similarly there is a performance penalty incurred when the size is wrong
- the bio has to be split, requiring memory, potential delays etc.

There is a trade-off between those two, and our experience with the current
code has that tilted strongly in favour of using merge_bvec all the time.
The wasted overhead in cases where it is of no benefit seem to be
outweighed by the benefit where it does avoid lots of splitting and help
filesystems optimise their behaviour.


If the splitting mechanism is changed as proposed, then that balance
might shift.  My gut feeling though is that any shift would strengthen
the case for merge_bvec.

Alasdair

