Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157Ab0HLNnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:43:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab0HLNnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:43:51 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC] [PATCH 2/4] dio: add page locking for direct I/O
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<alpine.DEB.2.00.1008110806070.673@router.home>
	<20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp>
	<20100812075941.GD6112@spritzera.linux.bs1.fc.nec.co.jp>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 12 Aug 2010 09:42:21 -0400
In-Reply-To: <20100812075941.GD6112@spritzera.linux.bs1.fc.nec.co.jp> (Naoya
	Horiguchi's message of "Thu, 12 Aug 2010 16:59:41 +0900")
Message-ID: <x49aaos3q2q.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> Basically it is user's responsibility to take care of race condition
> related to direct I/O, but some events which are out of user's control
> (such as memory failure) can happen at any time. So we need to lock and
> set/clear PG_writeback flags in dierct I/O code to protect from data loss.

Did you do any performance testing of this?  If not, please do and
report back.  I'm betting users won't be pleased with the results.

Cheers,
Jeff

>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  fs/direct-io.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 7600aac..0d0810d 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -439,7 +439,10 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
>  			struct page *page = bvec[page_no].bv_page;
>  
>  			if (dio->rw == READ && !PageCompound(page))
> -				set_page_dirty_lock(page);
> +				set_page_dirty(page);
> +			if (dio->rw & WRITE)
> +				end_page_writeback(page);
> +			unlock_page(page);
>  			page_cache_release(page);
>  		}
>  		bio_put(bio);
> @@ -702,11 +705,14 @@ submit_page_section(struct dio *dio, struct page *page,
>  {
>  	int ret = 0;
>  
> +	lock_page(page);
> +
>  	if (dio->rw & WRITE) {
>  		/*
>  		 * Read accounting is performed in submit_bio()
>  		 */
>  		task_io_account_write(len);
> +		set_page_writeback(page);
>  	}
>  
>  	/*
