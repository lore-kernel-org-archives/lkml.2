Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab1CAEui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 23:50:38 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64928 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab1CAEuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 23:50:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=pvmhL1uDaPZDjlwUHhiszI4fTOL43ajwFfU0zSKtja7dRVigV4Oje/XKdjxaB7QpS0
         S+oI1MQKMNZbGwj0v1mGs2Dnqr8WHvCoUI1QTCJpVcffzzI7ydBq58DnuY7pMo/36Jrs
         fwxGJ8aUJXcHVtFMpvokoxt0YymZwuub5DHI4=
Date: Tue, 1 Mar 2011 13:50:25 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v5 3/9] writeback: convert variables to unsigned
Message-ID: <20110301045025.GC2107@barrios-desktop>
References: <1298669760-26344-1-git-send-email-gthelen@google.com>
 <1298669760-26344-4-git-send-email-gthelen@google.com>
 <20110227160721.GB3226@barrios-desktop>
 <AANLkTik7LfGfYpteufr68AqEe3wUriJKgAMkmT8pJSzZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik7LfGfYpteufr68AqEe3wUriJKgAMkmT8pJSzZ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 03:52:53PM -0800, Greg Thelen wrote:
> On Sun, Feb 27, 2011 at 8:07 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> > On Fri, Feb 25, 2011 at 01:35:54PM -0800, Greg Thelen wrote:
> >> Convert two balance_dirty_pages() page counter variables (nr_reclaimable
> >> and nr_writeback) from 'long' to 'unsigned long'.
> >>
> >> These two variables are used to store results from global_page_state().
> >> global_page_state() returns unsigned long and carefully sums per-cpu
> >> counters explicitly avoiding returning a negative value.
> >>
> >> Signed-off-by: Greg Thelen <gthelen@google.com>
> > Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> >
> >> ---
> >> Changelog since v4:
> >> - Created this patch for clarity.  Previously this patch was integrated within
> >>   the "writeback: create dirty_info structure" patch.
> >>
> >>  mm/page-writeback.c |    6 ++++--
> >>  1 files changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> >> index 2cb01f6..4408e54 100644
> >> --- a/mm/page-writeback.c
> >> +++ b/mm/page-writeback.c
> >> @@ -478,8 +478,10 @@ unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
> >>  static void balance_dirty_pages(struct address_space *mapping,
> >>                               unsigned long write_chunk)
> >>  {
> >> -     long nr_reclaimable, bdi_nr_reclaimable;
> >> -     long nr_writeback, bdi_nr_writeback;
> >> +     unsigned long nr_reclaimable;
> >> +     long bdi_nr_reclaimable;
> >> +     unsigned long nr_writeback;
> >> +     long bdi_nr_writeback;
> >>       unsigned long background_thresh;
> >>       unsigned long dirty_thresh;
> >>       unsigned long bdi_thresh;
> >> --
> >> 1.7.3.1
> >>
> > bdi_nr_[reclaimable|writeback] can return negative value?
> > When I just look through bdi_stat_sum, it uses *percpu_counter_sum_positive*.
> > So I guess it always returns positive value.
> > If it is right, could you change it, too?
> 
> Yes, I think we can also change bdi_nr_[reclaimable|writeback] to unsigned long.
> 
> bdi_stat_sum() and bdi_stat() both call percpu_counter_sum_positive(),
> which return a positive number.  bdi_stat[_sum]() return s64.  Should
> we also change bdi_stat[_sum]() to return unsigned long rather than
> s64?  I would like the return value type to match the type of the
> corresponding local variables in balance_dirty_pages().  All current
> callers appear to expect bdi_stat[_sum]() to return unsigned long.

Please, clear them, too.
But this patch could be orthogonal with your series so it's up to you. :)

> 
> > --
> > Kind regards,
> > Minchan Kim
> >

-- 
Kind regards,
Minchan Kim
