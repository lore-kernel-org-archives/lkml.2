Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab2BAUNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:13:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab2BAUNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:13:47 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>,
        Herbert Poetzl <herbert@13thfloor.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Wu Fengguang <wfg@linux.intel.com>
Subject: Re: [PATCH] fix readahead pipeline break caused by block plug
References: <1327996780.21268.42.camel@sli10-conroe>
	<20120131220333.GD4378@redhat.com>
	<20120131141301.ba35ffe0.akpm@linux-foundation.org>
	<20120131222217.GE4378@redhat.com> <20120201033653.GA12092@redhat.com>
	<20120201091807.GA7451@infradead.org>
	<20120201201017.GC13246@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 01 Feb 2012 15:13:32 -0500
In-Reply-To: <20120201201017.GC13246@redhat.com> (Vivek Goyal's message of
	"Wed, 1 Feb 2012 15:10:17 -0500")
Message-ID: <x49y5smpb0z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Feb 01, 2012 at 04:18:07AM -0500, Christoph Hellwig wrote:
>> On Tue, Jan 31, 2012 at 10:36:53PM -0500, Vivek Goyal wrote:
>> > I still see that IO is being submitted one page at a time. The only
>> > real difference seems to be that queue unplug happening at random times
>> > and many a times we are submitting much smaller requests (40 sectors, 48
>> > sectors etc).
>> 
>> This is expected given that the block device node uses
>> block_read_full_page, and not mpage_readpage(s).
>
> What is the difference between block_read_full_page() and
> mpage_readpage(). IOW, why block device does not use mpage_readpage(s)
> interface?
>
> Is enabling mpage_readpages() on block devices is as simple as following
> patch or more is involved? (I suspect it has to be more than this. If it
> was this simple, it would have been done by now).
>
> This patch complies and seems to work. (system does not crash and dd
> seems to be working. I can't verify the contents of the file though).
>
> Applying following patch improved the speed from 110MB/s to more than
> 230MB/s.
>
> # dd if=/dev/sdb of=/dev/null bs=1M count=1K
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 4.6269 s, 232 MB/s

See:
commit db2dbb12dc47a50c7a4c5678f526014063e486f6
Author: Jeff Moyer <jmoyer@redhat.com>
Date:   Wed Apr 22 14:08:13 2009 +0200

    block: implement blkdev_readpages
    
    Doing a proper block dev ->readpages() speeds up the crazy dump(8)
    approach of using interleaved process IO.
    
    Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

And:

commit 172124e220f1854acc99ee394671781b8b5e2120
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Thu Jun 4 22:34:44 2009 +0200

    Revert "block: implement blkdev_readpages"
    
    This reverts commit db2dbb12dc47a50c7a4c5678f526014063e486f6.
    
    It apparently causes problems with partition table read-ahead
    on archs with large page sizes. Until that problem is diagnosed
    further, just drop the readpages support on block devices.
    
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

;-)

Cheers,
Jeff
