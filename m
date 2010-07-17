Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab0GRHIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 03:08:11 -0400
Received: from THUNK.ORG ([69.25.196.29]:51137 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab0GRHIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 03:08:07 -0400
Date: Sat, 17 Jul 2010 06:28:06 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Giangiacomo Mariotti <gg.mariotti@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Message-ID: <20100717102806.GD27114@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Giangiacomo Mariotti <gg.mariotti@gmail.com>,
	linux-kernel@vger.kernel.org
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
 <20100714194905.GA20286@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714194905.GA20286@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 03:49:05PM -0400, Christoph Hellwig wrote:
> Below I have a table comparing raw blockdevices, xfs, btrfs, ext4 and
> ext3.  For ext3 we also compare the default, unsafe barrier=0 version
> and the barrier=1 version you should use if you actually care about
> your data.
> 
> The comparism is a simple untar of a Linux 2.6.34 tarball, including a
> sync after it.  We run this with ext3 in the guest, either using the
> default barrier=0, or for the later tests also using barrier=1.  It
> is done on an OCZ Vertext SSD, which gets reformatted and fully TRIMed
> before each test.
> 
> As you can see you generally do want to use cache=none and every
> filesystem is about the same speed for that - except that on XFS you
> also really need preallocation.  What's interesting is how bad btrfs
> is for the default compared to the others, and that for many filesystems
> things actually get minimally faster when enabling barriers in the
> guest.

Christoph,

Thanks so much for running these benchmarks.  It's been on my todo
list ever since the original complaint came across on the linux-ext4
list, but I just haven't had time to do the investigation.  I wonder
exactly what qemu is doing which is impact btrfs in particularly so
badly.  I assume that using the qcow2 format with cache=writethrough,
it's doing lots of effectively file appends whih require allocation
(or conversion of uninitialized preallocated blocks to initialized
blocks in the fs metadata) with lots of fsync()'s afterwards.

But when I've benchmarked the fs_mark benchmark writing 10k files
followed by an fsync, I didn't see results for btrfs that were way out
of line compared to xfs, ext3, ext4, et.al.  So merely doing a block
allocation, a small write, followed by an fsync, was something that
all file systems did fairly well at.  So there must be something
interesting/pathalogical about what qemu is doing with
cache=writethrough.  It might be interesting to understand what is
going on there, either to fix qemu/kvm, or so file systems know that
there's a particular workload that requires some special attention...

  	     	      	   	    	 - Ted

P.S.  I assume since you listed "sparse" that you were using a raw
disk and not a qcom2 block device image?

