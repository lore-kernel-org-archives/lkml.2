Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab0HEPfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:35:45 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:35408 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755878Ab0HEPfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:35:44 -0400
Date: Thu, 5 Aug 2010 17:35:19 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Chris Mason <chris.mason@oracle.com>, josef@redhat.com
Cc: Valdis.Kletnieks@vt.edu,
        Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: direct-io regression [Was: How to track down abysmal
 performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805153519.GA7242@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Chris Mason <chris.mason@oracle.com>, josef@redhat.com,
	Valdis.Kletnieks@vt.edu,
	Michael Monnerie <michael.monnerie@is.it-management.at>,
	Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
	xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
 <20100805113240.GA29846@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Aug 05, 2010 at 07:32:40AM -0400, Chris Mason wrote:
> But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> seems a little high.  

Well, that's what it does:

# $ dd if=/dev/mapper/vg0-home_crypt of=/dev/zero iflag=direct bs=8k count=131072 seek=131072
# 131072+0 records in
# 131072+0 records out
# 1073741824 bytes (1.1 GB) copied, 62.0177 s, 17.3 MB/s

On Thu, Aug 05, 2010 at 08:36:49AM -0400, Josef Bacik wrote:
> Hrm, I made sure there were no perf regressions when I wast testing this stuff,
> though I think I only tested xfs and ext4.

For this test, I'm not doing dio on filesystem level, but on block level
(/dev/mapper/vg0-*_crypt). It seems that dm-crypt creates such offending
holes, which cause this huge performance drop.

>  Originally I had a test where if we
> provided our own submit_io, so maybe as a workaround just make
> 
> if (dio->final_block_in_bio != dio->cur_page_block ||
>                     cur_offset != bio_next_offset) 
> 
> look like this
> 
> if (dio->final_block_in_bio != dio->cur_page_block ||
>     (dio->submit_io && cur_offset != bio_next_offset))

Tested-by: Dominik Brodowski <linux@dominikbrodowski.net>

With this fix, I get proper speeds when doing dio reads from
/dev/mapper/vg0-*_crypt; see the 17.3 MB/s above. Most strangely,
also accesing /dev/mapper/vg0-* (un-encrypted) and the raw
device at /dev/sda* speeds up (to up to 28 MB/s). Was only seeing around
16 to 18 MB/s without this patch for unencrypted access.

> I know why it could cause a problem, but this change shouldn't be
> causing a 400% regression.

Well, it seems to cause -- at least on my notebook -- a 150% regression on
unencrypted LVM2 access; and this > 400% on encrypted LVM2 access...

> I suspect something else is afoot here.

There is, probably. But the fix you propose helps a lot, already.

Thanks & best,

	Dominik
