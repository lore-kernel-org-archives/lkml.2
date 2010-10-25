Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab0JYSsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:48:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab0JYSsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:48:18 -0400
Date: Mon, 25 Oct 2010 14:47:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, daniel.stodden@citrix.com,
        Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: linux-next regression: IO errors in with ext4
 and xen-blkfront
Message-ID: <20101025184756.GA26230@infradead.org>
References: <4CBF83A0.8090802@goop.org>
 <4CBF84C9.6050606@goop.org>
 <4CC148E5.2030605@kernel.dk>
 <20101022082916.GA14070@infradead.org>
 <20101025182630.GA6036@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025182630.GA6036@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 02:26:30PM -0400, Konrad Rzeszutek Wilk wrote:
> I think we just blindly assume that we would pass the request
> to the backend. And if the backend is running under an ancient
> version (2.6.18), the behavior would be quite different.

I don't think this has much to do with the backend.  Xen never
implemented empty barriers correctly.  This has been a bug since day
one, although before no one noticed because the cruft in the old
barrier code made them look like they succeed without them actually
succeeding.  With the new barrier code you do get an error back for
them - and you do get them more often because cache flushes aka
empty barriers are the only thing we send now.

The right fix is to add a cache flush command to the protocol which
will do the right things for all guests.  In fact I read on a netbsd
lists they had to do exactly that command to get their cache flushes
to work, so it must exist for some versions of the backends.

