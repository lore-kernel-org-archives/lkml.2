Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab0CXUfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:35:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932457Ab0CXUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:35:04 -0400
Date: Wed, 24 Mar 2010 13:33:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 08/11] Add /proc trigger for memory compaction
Message-Id: <20100324133351.c7730969.akpm@linux-foundation.org>
In-Reply-To: <1269347146-7461-9-git-send-email-mel@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	<1269347146-7461-9-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 12:25:43 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> This patch adds a proc file /proc/sys/vm/compact_memory. When an arbitrary
> value is written to the file, all zones are compacted. The expected user
> of such a trigger is a job scheduler that prepares the system before the
> target application runs.
> 
>
> ...
>
> +/* This is the entry point for compacting all nodes via /proc/sys/vm */
> +int sysctl_compaction_handler(struct ctl_table *table, int write,
> +			void __user *buffer, size_t *length, loff_t *ppos)
> +{
> +	if (write)
> +		return compact_nodes();
> +
> +	return 0;
> +}

Neato.  When I saw the overall description I was afraid that this stuff
would be fiddling with kernel threads.

The underlying compaction code can at times cause rather large amounts
of memory to be put onto private lists, so it's lost to the rest of the
kernel.  What happens if 10000 processes simultaneously write to this
thing?  It's root-only so I guess the answer is "root becomes unemployed".


I fear that the overall effect of this feature is that people will come
up with ghastly hacks which keep on poking this tunable as a workaround
for some VM shortcoming.  This will lead to more shortcomings, and
longer-lived ones.


