Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1HaF0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 01:26:34 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44997
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758Ab1HaF02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 01:26:28 -0400
Date: Wed, 31 Aug 2011 01:26:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110831052627.GA5338@infradead.org>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
 <20110830053231.GA1627@infradead.org>
 <CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 02:51:01PM -0700, Daniel Ehrenberg wrote:
> > Let filesystems handle this. ?I've actually prototyped it in XFS,
> > based on some pending work from Dave but at this point it's still butt
> > ugly.
> 
> Great, would you be willing to let me see the draft code?
> 
> Are you sure that there wouldn't be any benefit to having the code be
> in the aio/dio levels in terms of making it easier for file
> systems/reducing code duplication?

I'll get it polished up and send it out for RFC once Dave sends out
the updated allocation workqueue patch.  With this he moves all
allocator calls in XFS into a workqueue.  My direct I/O patch uses that
fact to use that workqueue for the allocator call and let the existing
aio retry infrastructure retry the direct I/O operation one that
workqueue has finished.

> > No way. ?I've fixed this for XFS, and it's trivial without the need to
> > queue them up. ?The only thing preventing appending writes to work is
> > a flag to tell the dio layer to just do them, just like it already works
> > for holes. ?(and more QA).
> >
> >
> Are you saying this is already fixed for XFS? Appends don't block,
> only reads to metadata do?

XFS-internal yes, just the generic direct I/O code doesn't let us do it
yet.  Remember that XFS only updates the on-disk i_size after I/O
completion.

