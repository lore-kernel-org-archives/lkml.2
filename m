Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab0IMJsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 05:48:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50480 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0IMJsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 05:48:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oyD02R+ELkh3iefKfUL0lYZ49jrZHFMXTI8LfVGPmcOL6WnmbdAyqFChSmsoUUNQE1
         /BEDuTE5wDe+X9ZqBrI/cR2/88BzepE/RFGuijvRm5cc0QAPg5kxG2bQNUmRxmdfQQii
         KGrktTtjxH3A/R5WyWElxF8+Td5MuXLP7uhvc=
MIME-Version: 1.0
In-Reply-To: <20100913085549.GA23508@csn.ul.ie>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
	<1283770053-18833-4-git-send-email-mel@csn.ul.ie>
	<20100907152533.GB4620@barrios-desktop>
	<20100908110403.GB29263@csn.ul.ie>
	<20100908145245.GG4620@barrios-desktop>
	<20100909085436.GJ29263@csn.ul.ie>
	<20100912153744.GA3563@barrios-desktop>
	<20100913085549.GA23508@csn.ul.ie>
Date: Mon, 13 Sep 2010 18:48:10 +0900
Message-ID: <AANLkTimkSU5G1qO0JDp8An5ofM2BPoPY0SGUOuTvSuOL@mail.gmail.com>
Subject: Re: [PATCH 03/10] writeback: Do not congestion sleep if there are no
 congested BDIs or significant writeback
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 5:55 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Mon, Sep 13, 2010 at 12:37:44AM +0900, Minchan Kim wrote:
>> > > > > > <SNIP>
>> > > > > >
>> > > > > > + * in sleeping but cond_resched() is called in case the current process has
>> > > > > > + * consumed its CPU quota.
>> > > > > > + */
>> > > > > > +long wait_iff_congested(struct zone *zone, int sync, long timeout)
>> > > > > > +{
>> > > > > > +   long ret;
>> > > > > > +   unsigned long start = jiffies;
>> > > > > > +   DEFINE_WAIT(wait);
>> > > > > > +   wait_queue_head_t *wqh = &congestion_wqh[sync];
>> > > > > > +
>> > > > > > +   /*
>> > > > > > +    * If there is no congestion, check the amount of writeback. If there
>> > > > > > +    * is no significant writeback and no congestion, just cond_resched
>> > > > > > +    */
>> > > > > > +   if (atomic_read(&nr_bdi_congested[sync]) == 0) {
>> > > > > > +           unsigned long inactive, writeback;
>> > > > > > +
>> > > > > > +           inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
>> > > > > > +                           zone_page_state(zone, NR_INACTIVE_ANON);
>> > > > > > +           writeback = zone_page_state(zone, NR_WRITEBACK);
>> > > > > > +
>> > > > > > +           /*
>> > > > > > +            * If less than half the inactive list is being written back,
>> > > > > > +            * reclaim might as well continue
>> > > > > > +            */
>> > > > > > +           if (writeback < inactive / 2) {
>> > > > >
>> > > > > I am not sure this is best.
>> > > > >
>> > > >
>> > > > I'm not saying it is. The objective is to identify a situation where
>> > > > sleeping until the next write or congestion clears is pointless. We have
>> > > > already identified that we are not congested so the question is "are we
>> > > > writing a lot at the moment?". The assumption is that if there is a lot
>> > > > of writing going on, we might as well sleep until one completes rather
>> > > > than reclaiming more.
>> > > >
>> > > > This is the first effort at identifying pointless sleeps. Better ones
>> > > > might be identified in the future but that shouldn't stop us making a
>> > > > semi-sensible decision now.
>> > >
>> > > nr_bdi_congested is no problem since we have used it for a long time.
>> > > But you added new rule about writeback.
>> > >
>> >
>> > Yes, I'm trying to add a new rule about throttling in the page allocator
>> > and from vmscan. As you can see from the results in the leader, we are
>> > currently sleeping more than we need to.
>>
>> I can see the about avoiding congestion_wait but can't find about
>> (writeback < incative / 2) hueristic result.
>>
>
> See the leader and each of the report sections entitled
> "FTrace Reclaim Statistics: congestion_wait". It provides a measure of
> how sleep times are affected.
>
> "congest waited" are waits due to calling congestion_wait. "conditional waited"
> are those related to wait_iff_congested(). As you will see from the reports,
> sleep times are reduced overall while callers of wait_iff_congested() still
> go to sleep. The reports entitled "FTrace Reclaim Statistics: vmscan" show
> how reclaim is behaving and indicators so far are that reclaim is not hurt
> by introducing wait_iff_congested().

I saw  the result.
It was a result about effectiveness _both_ nr_bdi_congested and
(writeback < inactive/2).
What I mean is just effectiveness (writeback < inactive/2) _alone_.
If we remove (writeback < inactive / 2) check and unconditionally
return, how does the behavior changed?

Am I misunderstanding your report in leader?

-- 
Kind regards,
Minchan Kim
