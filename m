Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab1IHIyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:54:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab1IHIyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:54:24 -0400
Date: Thu, 8 Sep 2011 10:54:04 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ying Han <yinghan@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: close race between charge and putback
Message-ID: <20110908085404.GA1316@redhat.com>
References: <1315467622-9520-1-git-send-email-jweiner@redhat.com>
 <20110908173042.4a6f8ac0.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908173042.4a6f8ac0.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 05:30:42PM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu,  8 Sep 2011 09:40:22 +0200
> Johannes Weiner <jweiner@redhat.com> wrote:
> 
> > There is a potential race between a thread charging a page and another
> > thread putting it back to the LRU list:
> > 
> > charge:                         putback:
> > SetPageCgroupUsed               SetPageLRU
> > PageLRU && add to memcg LRU     PageCgroupUsed && add to memcg LRU
> > 
> 
> I assumed that all pages are charged before added to LRU.
> (i.e. event happens in charge->lru_lock->putback order.)
> 
> But hmm, this assumption may be bad for maintainance.
> Do you find a code which adds pages to LRU before charge ?
> 
> Hmm, if there are codes which recharge the page to other memcg,
> it will cause bug and my assumption may be harmful.

Swap slots are read optimistically into swapcache and put to the LRU,
then charged upon fault.  Fuse apparently recharges uncharged LRU
pages.  That's why we have the lrucare stuff in the first place, no?
Or did I misunderstand your question?
