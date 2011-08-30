Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab1H3Fcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:32:35 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35085
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842Ab1H3Fcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:32:32 -0400
Date: Tue, 30 Aug 2011 01:32:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110830053231.GA1627@infradead.org>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 10:33:24AM -0700, Daniel Ehrenberg wrote:
> - Blocking due to reading metadata.
> Proposed solution:
> Add a per-ioctx work queue to do metadata reads. It will be triggered
> from the dio code: if in async mode, then get_block will be called
> with an additional flag, meaning something like O_NONBLOCK on sockets.
> File systems' get_block functions can implement this flag and return
> -EAGAIN if a read from the underlying device would be necessary. (If
> we're worried that EAGAIN might be used for other purposes in the
> future, we could make a new errno for this purpose.) From a quick
> glance at the code, it looks like this would not be too difficult to
> add to ext4 for extent-based files, and support in other file systems
> could be added gradually. If -EAGAIN is returned, then the struct dio
> will be put on the work queue together with a description of what kind
> of processing it was doing. The work queue only serves the metadata
> request, and the rest of the request is served on the existing path.

Let filesystems handle this.  I've actually prototyped it in XFS,
based on some pending work from Dave but at this point it's still butt
ugly.

> - Blocking for appends and writes to file holes due to the need for a
> metadata write after the data write
> Proposed solution:
> Maintain a work queue for all appends and writes to file holes, which
> executes the current code.

No way.  I've fixed this for XFS, and it's trivial without the need to
queue them up.  The only thing preventing appending writes to work is
a flag to tell the dio layer to just do them, just like it already works
for holes.  (and more QA).

