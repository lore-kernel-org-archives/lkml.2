Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab0JQBYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 21:24:41 -0400
Received: from canuck.infradead.org ([134.117.69.58]:48169 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab0JQBYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 21:24:40 -0400
Date: Sat, 16 Oct 2010 21:24:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] exofs: use iput() for inode reference count
 decrements
Message-ID: <20101017012437.GA4227@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-7-git-send-email-david@fromorbit.com>
 <20101013113402.GC19456@infradead.org>
 <4CB5C70A.2010401@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB5C70A.2010401@panasas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 10:49:46AM -0400, Boaz Harrosh wrote:
> I suspect it's not a bug but a useless inc/dec because in all my testing
> I have not seen an inode leak. Let me investigate if it can be removed.
> 
> So I do not think we need it for 2.6.36.
> 
> I'll take this patch into my 2.6.37-rcX merge window. It should appear
> in linux-next by tomorrow. Hopefully followed by a removal patch later.

It's a very real bug.  If an inode goes away in-core before the creation
on the OSD has finished, e.g. by using the drop_cache files the
atomic_dec instead of the iput means you will never call iput_final
and thus leak all ressources associated with the inode, as well as
leaving it on all lists.  It's not easy to hit, but very nasty when
it is hit.

Another option to fix it might be to drop the refcount games and just
add a wait for the objection creation in the evict_inode method to
make sure we never remove the inode before the object creation
has finished.

