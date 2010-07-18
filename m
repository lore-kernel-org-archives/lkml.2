Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0GRHPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 03:15:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0GRHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 03:15:09 -0400
Date: Sun, 18 Jul 2010 03:15:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        Giangiacomo Mariotti <gg.mariotti@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Message-ID: <20100718071508.GA6952@infradead.org>
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
 <20100714194905.GA20286@infradead.org>
 <20100717102806.GD27114@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100717102806.GD27114@thunk.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 17, 2010 at 06:28:06AM -0400, Ted Ts'o wrote:
> Thanks so much for running these benchmarks.  It's been on my todo
> list ever since the original complaint came across on the linux-ext4
> list, but I just haven't had time to do the investigation.  I wonder
> exactly what qemu is doing which is impact btrfs in particularly so
> badly.  I assume that using the qcow2 format with cache=writethrough,
> it's doing lots of effectively file appends whih require allocation
> (or conversion of uninitialized preallocated blocks to initialized
> blocks in the fs metadata) with lots of fsync()'s afterwards.

This is using raw images.  So what we're doing there is hole filling.
No explicit fsyncs are done for cache=writethrough.  cache=writethrough
translates to using O_DSYNC, which makes every write synchronous, which
these days translates to an implicity ->fsync call on every write.

> P.S.  I assume since you listed "sparse" that you were using a raw
> disk and not a qcom2 block device image?

All of these are using raw images.  sparse means just doing a truncate
to the image size, preallocated means using fallocate to pre-allocate
the space.

