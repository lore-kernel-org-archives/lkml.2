Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2E2Qau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:30:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:58526 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2E2Qat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:30:49 -0400
Message-ID: <1338309029.26856.123.camel@twins>
Subject: Re: [PATCH 30/35] autonuma: reset autonuma page data when pages are
 freed
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Date: Tue, 29 May 2012 18:30:29 +0200
In-Reply-To: <1337965359-29725-31-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-31-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:
> When pages are freed abort any pending migration. If knuma_migrated
> arrives first it will notice because get_page_unless_zero would fail.

But knuma_migrated can run on a different cpu than this free is
happening, ACCESS_ONCE() won't cure that.

What's that ACCESS_ONCE() good for?

Also, you already have an autonuma_ hook right there, why add more
#ifdeffery ?

> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  mm/page_alloc.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3d1ee70..1d3163f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -614,6 +614,10 @@ static inline int free_pages_check(struct page *page)
>  		bad_page(page);
>  		return 1;
>  	}
> +	autonuma_migrate_page_remove(page);
> +#ifdef CONFIG_AUTONUMA
> +	ACCESS_ONCE(page->autonuma_last_nid) = -1;
> +#endif
>  	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
>  		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
>  	return 0;

