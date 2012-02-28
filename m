Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab2B1J3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:29:31 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51722
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905Ab2B1J32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:29:28 -0500
Date: Tue, 28 Feb 2012 04:29:26 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>
Subject: Re: [RFC PATCH 00/22] loop: Issue O_DIRECT aio with pages
Message-ID: <20120228092926.GA2766@infradead.org>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a very brief look over the series, and in general I like it.

But there is one thing that needs a major revision, and that is the
filesyste, interface.

For one you make ->aio_read/write trivial wrappers around ->read_iter
and ->write_iter.  Instead of keeping this duplication around please
make sure to entirely kill ->aio_read/write and always use your new
methods.  Without that we'll get into a complete mess like the old
->aio_read/write vs ->readv/writev again.

A similar thing applies to the ->direct_IO/direct_IO_bvec interface -
instead of duplicating it I'd rather change the ->direct_IO interface to:

	ssize_t (*direct_IO)(int rw, struct kiocb *iocb,
			     struct iov_iter *iter, loff_t pos)

and let only fs/direct-io.c care about the difference when using user vs
kernel pages.

