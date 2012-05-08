Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab2EHQ60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:58:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39945 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab2EHQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:58:24 -0400
Date: Tue, 8 May 2012 09:58:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: linux-next oops in __lock_acquire for process_one_work
Message-ID: <20120508165819.GB10687@google.com>
References: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils>
 <20120507175743.GC19417@google.com>
 <1336482202.16236.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336482202.16236.29.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 03:03:22PM +0200, Peter Zijlstra wrote:
> I think there's a problem if indeed we do silly things like small copies
> like Hugh saw (why would gcc ever generate small copies for objects that
> are naturally aligned and naturally sized?).
> 
> Something like the below should fix that problem, but it doesn't explain
> the observed issue..

Hmmm.... Hugh, can you please verify whether this patch makes the
problem go away somehow?

> @@ -1810,7 +1810,7 @@ __acquires(&gcwq->lock)
>  	 * lock freed" warnings as well as problems when looking into
>  	 * work->lockdep_map, make a copy and use that here.
>  	 */
> -	struct lockdep_map lockdep_map = work->lockdep_map;
> +	struct lockdep_map lockdep_map = lockdep_copy_map(&work->lockdep_map);

If this is the correct fix for whatever reason, maybe we want the copy
interface to be a bit more conventional?  lockdep_copy_map(to, from)?

Thanks.

-- 
tejun
