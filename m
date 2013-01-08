Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3AHRPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:15:32 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34012 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231Ab3AHRPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:15:31 -0500
Message-ID: <50EC541B.5000905@linux.vnet.ibm.com>
Date: Tue, 08 Jan 2013 09:15:07 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv2 8/9] zswap: add to mm/
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com> <1357590280-31535-9-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1357590280-31535-9-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010817-7182-0000-0000-00000443DC09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 12:24 PM, Seth Jennings wrote:
> +struct zswap_tree {
> +	struct rb_root rbroot;
> +	struct list_head lru;
> +	spinlock_t lock;
> +	struct zs_pool *pool;
> +};

BTW, I spent some time trying to get this lock contended.  You thought
the anon_vma locks would dominate and this spinlock would not end up
very contended.

I figured that if I hit zswap from a bunch of CPUs that _didn't_ use
anonymous memory (and thus the anon_vma locks) that some more contention
would pop up.  I did that with a bunch of CPUs writing to tmpfs, and
this lock was still well down below anon_vma.  The anon_vma contention
was obviously coming from _other_ anonymous memory around.

IOW, I feel a bit better about this lock.  I only tested on 16 cores on
a system with relatively light NUMA characteristics, and it might be the
bottleneck if all the anonymous memory on the system is mlock()'d and
you're pounding on tmpfs, but that's pretty contrived.

