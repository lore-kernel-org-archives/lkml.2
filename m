Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2CLOTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:19:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:49050 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab2CLOTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:19:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127805443"
Message-ID: <1331562109.12037.54.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 5/9] writeback: introduce the pageout work
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Date: Mon, 12 Mar 2012 16:21:49 +0200
In-Reply-To: <20120312140229.GG5998@quack.suse.cz>
References: <20120302095910.GB1744@quack.suse.cz>
	 <20120302103951.GA13378@localhost>
	 <20120302115700.7d970497.akpm@linux-foundation.org>
	 <20120303135558.GA9869@localhost>
	 <1331135301.32316.29.camel@sauron.fi.intel.com>
	 <20120309073113.GA5337@localhost> <20120309095135.GC21038@quack.suse.cz>
	 <1331309451.29445.42.camel@sauron.fi.intel.com>
	 <20120309211156.GA6262@quack.suse.cz>
	 <1331555774.12037.9.camel@sauron.fi.intel.com>
	 <20120312140229.GG5998@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 15:02 +0100, Jan Kara wrote:
> > The second part of the overall deletion job will be when we commit - the
> > updated version of the FS index will be written to the flash media.
>   Oh, I see. This is what I was missing. And I presume you always make sure
> to have enough space for new FS index so it cannot deadlock when trying to
> push out dirty pages.

Yes, this is one of the hardest part and this is what the budgeting
subsystem does. Every VFS call (even unlink()) first invokes something
like 'ubifs_budget_space()' with arguments describing the space needs,
and the budgeting subsystem will account for the space, including the
possibility of the index growth. And the budgeting subsystem actually
forces write-back when it sees that there is not enough free space for
the operation. Because all the calculations are pessimistic, write-back
helps: the data nodes are compressed, and so on. The budgeting subsystem
may also force commit, which will clarify many unclarities and make the
calculations more precise. If nothing helps - ENOSPC is reported. For
deletions we also have a bit of reserve space to prevent -ENOSPC when
you actually want to delete a file on full file-system.

But the shorted answer: yes, we reserve 2 times the current index size
of the space for the index growths.

Long time ago I tried to describe this and the surrounding issues here:
http://www.linux-mtd.infradead.org/doc/ubifs.html#L_spaceacc

-- 
Best Regards,
Artem Bityutskiy

