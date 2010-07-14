Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab0GNTtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:49:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40695 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0GNTtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:49:07 -0400
Date: Wed, 14 Jul 2010 15:49:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Message-ID: <20100714194905.GA20286@infradead.org>
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a lot of variables when using qemu.

The most important one are:

 - the cache mode on the device.  The default is cache=writethrough,
   which is not quite optimal.  You generally do want to use cache=none
   which uses O_DIRECT in qemu.
 - if the backing image is sparse or not.
 - if you use barrier - both in the host and the guest.

Below I have a table comparing raw blockdevices, xfs, btrfs, ext4 and
ext3.  For ext3 we also compare the default, unsafe barrier=0 version
and the barrier=1 version you should use if you actually care about
your data.

The comparism is a simple untar of a Linux 2.6.34 tarball, including a
sync after it.  We run this with ext3 in the guest, either using the
default barrier=0, or for the later tests also using barrier=1.  It
is done on an OCZ Vertext SSD, which gets reformatted and fully TRIMed
before each test.

As you can see you generally do want to use cache=none and every
filesystem is about the same speed for that - except that on XFS you
also really need preallocation.  What's interesting is how bad btrfs
is for the default compared to the others, and that for many filesystems
things actually get minimally faster when enabling barriers in the
guest.  Things will look very different for barrier heavy guest, I'll
do another benchmark for those.

							bdev		xfs		btrfs		ext4		ext3		ext3 (barrier)

cache=writethrough	nobarrier	sparse		0m27.183s	0m42.552s	2m28.929s	0m33.749s	0m24.975s	0m37.105s
cache=writethrough	nobarrier	prealloc	-		0m32.840s	2m28.378s	0m34.233s	-		-

cache=none		nobarrier	sparse		0m21.988s	0m49.758s	0m24.819s	0m23.977s	0m22.569s	0m24.938s
cache=none		nobarrier	prealloc	-		0m24.464s	0m24.646s	0m24.346s	-		-

cache=none		barrier		sparse		0m21.526s	0m41.158s	0m24.403s	0m23.924s	0m23.040s	0m23.272s
cache=none		barrier		prealloc	-		0m23.944s	0m24.284s	0m23.981s	-		-
