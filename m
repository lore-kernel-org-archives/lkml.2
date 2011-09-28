Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab1I1JAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:00:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42832 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1I1JAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:00:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 17:59:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 6/9] kstaled: rate limit pages scanned per second.
Message-Id: <20110928175947.d3af52f0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CANN689GFE_hqtndKY6i4ouBBe+gVU_pqOK2HRrc-U1LJMONaXw@mail.gmail.com>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	<1317170947-17074-7-git-send-email-walken@google.com>
	<20110928171309.b45c684f.kamezawa.hiroyu@jp.fujitsu.com>
	<CANN689GFE_hqtndKY6i4ouBBe+gVU_pqOK2HRrc-U1LJMONaXw@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Sep 2011 01:19:50 -0700
Michel Lespinasse <walken@google.com> wrote:

> On Wed, Sep 28, 2011 at 1:13 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Tue, 27 Sep 2011 17:49:04 -0700
> > Michel Lespinasse <walken@google.com> wrote:
> >
> >> Scan some number of pages from each node every second, instead of trying to
> >> scan the entime memory at once and being idle for the rest of the configured
> >> interval.
> >>
> >> In addition to spreading the CPU usage over the entire scanning interval,
> >> this also reduces the jitter between two consecutive scans of the same page.
> >>
> >>
> >> Signed-off-by: Michel Lespinasse <walken@google.com>
> >
> > Does this scan thread need to be signle thread ?
> 
> It tends to perform worse if we try making it multithreaded. What
> happens is that the scanning threads call page_referenced() a lot, and
> if they both try scanning pages that belong to the same file that
> causes the mapping's i_mmap_mutex lock to bounce. Same things happens
> if they try scanning pages that belong to the same anon VMA too.
> 

Hmm. with brief thinking, if you can scan list of page tables,
you can set young flags without any locks. 
For inode pages, you can hook page lookup, I think.

You only need to clear Young flag by scanning [pfn, end_pfn].
Then, multi-threaded. ?


Thanks,
-Kame



