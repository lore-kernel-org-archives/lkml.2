Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab0FWJ0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:26:23 -0400
Received: from verein.lst.de ([213.95.11.210]:40247 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab0FWJ0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:26:22 -0400
Date: Wed, 23 Jun 2010 11:26:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100623092606.GA8278@lst.de>
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk> <x49mxuo6ww6.fsf@segfault.boston.devel.redhat.com> <4C1FB66B.1030203@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1FB66B.1030203@kernel.dk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0.001 () BAYES_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 08:58:51PM +0200, Jens Axboe wrote:
> It's definitely a win in some cases, as you showed there as well.
> My initial testing a long time ago had some nice benefits too. So
> perhaps the above wasn't worded very well, I always worry that we
> have regressions doing boosts for things like that. But given that
> meta data is something that needs to be done before we get to the
> real data, bumping priority generally seems like a good thing to do.

Even if the REQ_META special casing helps with performance it creates
a big issue if we want to follow your other guide line, that is marking
all actual metadata requests REQ_META for blocktrace.  What about
only applying the metadata preference only to _synchronous_ (read or
REQ_SYNC) I/Os that also have REQ_META set?

Right now we never use REQ_META on a non-synchronous request (XFS appears
to, but the code is not actually reachable anymore), so it's not
actually a change in behaviour.  After that we could do an easy sweep
through the tree and mark all metadata requests as REQ_META.  Btw, what
do we consider metadata for this purpose?  The interesting question
here is about indirect blocks / bmap btree blocks.  In the traditional
sense they are metadata, but for I/O purposes they are mostly part of
the I/O stream.
