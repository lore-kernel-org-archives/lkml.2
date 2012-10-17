Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2JQWMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:12:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2JQWMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:12:47 -0400
Date: Wed, 17 Oct 2012 15:12:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, <devel@openvz.org>,
        <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 13/14] protect architectures where THREAD_SIZE >=
 PAGE_SIZE against fork bombs
Message-Id: <20121017151245.f11c4d18.akpm@linux-foundation.org>
In-Reply-To: <1350382611-20579-14-git-send-email-glommer@parallels.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com>
	<1350382611-20579-14-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 14:16:50 +0400
Glauber Costa <glommer@parallels.com> wrote:

> @@ -146,7 +146,7 @@ void __weak arch_release_thread_info(struct thread_info *ti)
>  static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
>  						  int node)
>  {
> -	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
> +	struct page *page = alloc_pages_node(node, THREADINFO_GFP_ACCOUNTED,
>  					     THREAD_SIZE_ORDER);

yay, we actually used all this code for something ;)

I don't think we really saw a comprehensive list of what else the kmem
controller will be used for, but I believe that all other envisaged
applications will require slab accounting, yes?


So it appears that all we have at present is a
yet-another-fork-bomb-preventer, but one which requires that the
culprit be in a container?  That's reasonable, given your
hosted-environment scenario.  It's unclear (to me) that we should merge
all this code for only this feature.  Again, it would be good to have a
clear listing of and plan for other applications of this code.
