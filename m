Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1DRVaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:30:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1DRVav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:30:51 -0400
Date: Mon, 18 Apr 2011 17:30:48 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110418213048.GA21852@infradead.org>
References: <4DA2E03A.2080607@fusionio.com>
 <20110411212635.7959de70@notabene.brown>
 <4DA2E7F0.9010904@fusionio.com>
 <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
 <20110418081922.1651474a@notabene.brown>
 <4DABDC60.2090009@fusionio.com>
 <20110418172551.55629fc6@notabene.brown>
 <4DABF1EA.3070301@fusionio.com>
 <20110418183343.036f412e@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418183343.036f412e@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>       md: provide generic support for handling unplug callbacks.

This looks like some horribly ugly code to me.  The real fix is to do
the plugging in the block layers for bios instead of requests.  The
effect should be about the same, except that merging will become a
little easier as all bios will be on the list now when calling into
__make_request or it's equivalent, and even better if we extent the
list sort callback to also sort by the start block it will actually
simplify the merge algorithm a lot as it only needs to do front merges
and no back merges for the on-stack merging.

In addition it should also allow for much more optimal queue_lock
roundtrips - we can keep it locked at the end of what's currently
__make_request to have it available for the next bio that's been
on the list.  If it either can be merged now that we have the lock
and/or we optimize get_request_wait not to sleep in the fast path
we could get down to a single queue_lock roundtrip for each unplug.

