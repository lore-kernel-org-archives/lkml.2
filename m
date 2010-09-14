Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0INJZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 05:25:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49001 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab0INJZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 05:25:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 05/17] writeback: quit throttling when signal pending
Cc: kosaki.motohiro@jp.fujitsu.com, Neil Brown <neilb@suse.de>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <20100914091720.GA23042@localhost>
References: <20100914174017.C9BB.A69D9226@jp.fujitsu.com> <20100914091720.GA23042@localhost>
Message-Id: <20100914182433.C9C1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 14 Sep 2010 18:25:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > However, I suspect the process is guaranteed to exit on
> > > fatal_signal_pending, so it won't dirty more pages :)
> > 
> > Process exiting is delayed until syscall exiting. So, we exit write syscall
> > manually if necessary.
> 
> Got it, you mean this fix. It looks good. I didn't add "status =
> -EINTR" in the patch because the bottom line "written ? : status" will
> always select the non-zero written.
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 3d4df44..f6d2740 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2304,7 +2304,8 @@ again:
>  		written += copied;
>  
>  		balance_dirty_pages_ratelimited(mapping);
> -
> +		if (fatal_signal_pending(current))
> +			break;
>  	} while (iov_iter_count(i));

Looks good. however other callers also need to be updated.



