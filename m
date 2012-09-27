Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2I0UDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 16:03:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab2I0UDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 16:03:43 -0400
Date: Thu, 27 Sep 2012 22:03:42 +0200
From: Jan Kara <jack@suse.cz>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Jan Kara <jack@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
Message-ID: <20120927200342.GB12553@quack.suse.cz>
References: <50531629.9020107@ahsoftware.de>
 <20120925110206.GD28937@mwanda>
 <50643C4A.9010202@ahsoftware.de>
 <20120927151232.GA12210@quack.suse.cz>
 <506474E8.3030300@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506474E8.3030300@ahsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-09-12 17:46:48, Alexander Holler wrote:
> Hello,
> 
> Am 27.09.2012 17:12, schrieb Jan Kara:
> >   Just some thoughts about your oops:
> >The assertion which fails is:
> >BUG_ON(!list_empty(&bh->b_assoc_buffers));
> >
> >Now b_assoc_buffers isn't used very much. In particular ext4 which you seem
> >to be using doesn't use this list at all (except when mounted in nojournal
> >mode but that doesn't seem to be your case). That would point rather
> >strongly at a memory corruption issue.
> >
> >So if you can reproduce the oops, it might be interesting to print
> >bh->b_assoc_buffers.next and &bh->b_assoc_buffers.next if the list is found
> >to be non-empty.
> 
> Hmm, a loose pointer would explain it all too. Especially the cases
> when I just have seen wrong content in the archive without having
> any oops. I try to reproduce it with
> 
> pr_info("AHO: %p %p\n", bh->b_assoc_buffers.next,
> &bh->b_assoc_buffers.next);
> after the BUG_ON().
  It should have been:
	if (!list_empty(&bh->b_assoc_buffers))
		pr_info("AHO: %p %p\n", bh->b_assoc_buffers.next,
			&bh->b_assoc_buffers.next);
  *before* BUG_ON().

  What you saw in the logs were just pointers showing the list is empty
(naturally as otherwise we'd see the BUG_ON trigger).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
