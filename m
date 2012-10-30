Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab2J3PX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:23:28 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33399 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab2J3PXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:23:21 -0400
Message-ID: <508FEECE.2070402@linux.vnet.ibm.com>
Date: Tue, 30 Oct 2012 08:14:22 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Mike Yoknis <mike.yoknis@hp.com>, mingo@redhat.com,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org, mmarek@suse.cz,
        tglx@linutronix.de, hpa@zytor.com, arnd@arndb.de, sam@ravnborg.org,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: memmap_init_zone() performance improvement
References: <1349276174-8398-1-git-send-email-mike.yoknis@hp.com> <20121008151656.GM29125@suse.de> <1349794597.29752.10.camel@MikesLinux.fc.hp.com> <1350676398.1169.6.camel@MikesLinux.fc.hp.com> <20121020082858.GA2698@suse.de>
In-Reply-To: <20121020082858.GA2698@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103015-7282-0000-0000-00000E68DDDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2012 01:29 AM, Mel Gorman wrote:
> I'm travelling at the moment so apologies that I have not followed up on
> this. My problem is still the same with the patch - it changes more
> headers than is necessary and it is sparsemem specific. At minimum, try
> the suggestion of 
> 
> if (!early_pfn_valid(pfn)) {
>       pfn = ALIGN(pfn + MAX_ORDER_NR_PAGES, MAX_ORDER_NR_PAGES) - 1;
>       continue;
> }

Sorry I didn't catch this until v2...

Is that ALIGN() correct?  If pfn=3, then it would expand to:

(3+MAX_ORDER_NR_PAGES+MAX_ORDER_NR_PAGES-1) & ~(MAX_ORDER_NR_PAGES-1)

You would end up skipping the current MAX_ORDER_NR_PAGES area, and then
one _extra_ because ALIGN() aligns up, and you're adding
MAX_ORDER_NR_PAGES too.  It doesn't matter unless you run in to a
!early_valid_pfn() in the middle of a MAX_ORDER area, I guess.

I think this would work, plus be a bit smaller:

	pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES) - 1;

