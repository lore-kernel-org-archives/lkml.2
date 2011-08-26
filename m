Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab1HZT2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 15:28:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab1HZT2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 15:28:38 -0400
Date: Fri, 26 Aug 2011 21:28:10 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] thp: tail page refcounting fix #2
Message-ID: <20110826192810.GA6439@redhat.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
 <20110822213347.GF2507@redhat.com>
 <CANN689HE=TKyr-0yDQgXEoothGJ0Cw0HLB2iOvCKrOXVF2DNww@mail.gmail.com>
 <20110824000914.GH23870@redhat.com>
 <20110824002717.GI23870@redhat.com>
 <20110824133459.GP23870@redhat.com>
 <20110826062436.GA5847@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826062436.GA5847@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 11:24:36PM -0700, Michel Lespinasse wrote:
> In __get_page_tail(), you could add a VM_BUG_ON(page_mapcount(page) <= 0)
> to reflect the fact that get_page() callers are expected to have already
> gotten a reference on the page through a gup call.

Turns out this is going to generate false positives. For THP it should
have been always ok, but if you allocate a compound page (that can't
be splitted) and then map it on 4k pagetables and doing
get_page/put_page in the map/unmap of the pte, it'll fail because the
page fault will be the first occurrence where the tail page refcount
is elevated. I'll check it in more detail tomorrow... So you may want
to delete the bugcheck above before testing #3.
