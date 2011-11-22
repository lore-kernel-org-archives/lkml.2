Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab1KVLyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:54:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756900Ab1KVLya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:54:30 -0500
Date: Tue, 22 Nov 2011 12:54:27 +0100
From: Jan Kara <jack@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shaohua.li@intel.com>, Linux-MM <linux-mm@kvack.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] mm: compaction: Introduce sync-light migration for
 use by compaction
Message-ID: <20111122115427.GA8058@quack.suse.cz>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
 <1321900608-27687-8-git-send-email-mgorman@suse.de>
 <1321945011.22361.335.camel@sli10-conroe>
 <20111122101451.GJ19415@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122101451.GJ19415@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-11-11 10:14:51, Mel Gorman wrote:
> On Tue, Nov 22, 2011 at 02:56:51PM +0800, Shaohua Li wrote:
> > On Tue, 2011-11-22 at 02:36 +0800, Mel Gorman wrote:
> > on the other hand, MIGRATE_SYNC_LIGHT now waits for pagelock and buffer
> > lock, so could wait on page read. page read and page out have the same
> > latency, why takes them different?
> > 
> 
> That's a very reasonable question.
> 
> To date, the stalls that were reported to be a problem were related to
> heavy writing workloads. Workloads are naturally throttled on reads
> but not necessarily on writes and the IO scheduler priorities sync
> reads over writes which contributes to keeping stalls due to page
> reads low.  In my own tests, there have been no significant stalls
> due to waiting on page reads. I accept this may be because the stall
> threshold I record is too low.
> 
> Still, I double checked an old USB copy based test to see what the
> compaction-related stalls really were.
> 
> 58 seconds	waiting on PageWriteback
> 22 seconds	waiting on generic_make_request calling ->writepage
> 
> These are total times, each stall was about 2-5 seconds and very rough
> estimates. There were no other sources of stalls that had compaction
> in the stacktrace I'm rerunning to gather more accurate stall times
> and for a workload similar to Andrea's and will see if page reads
> crop up as a major source of stalls.
  OK, but the fact that reads do not stall may pretty much depend on the
behavior of the underlying IO scheduler and we probably don't want to rely
on it's behavior too closely. So if you are going to treat reads in a
special way, check with NOOP or DEADLINE io schedulers that read-stalls
are not a problem with them as well.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
