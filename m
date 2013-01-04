Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3ADPnC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 10:43:02 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36472 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3ADPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 10:43:00 -0500
Message-ID: <50E6F862.2030703@linux.vnet.ibm.com>
Date: Fri, 04 Jan 2013 09:42:26 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/8] zswap: add to mm/
References: <<1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>> <<1355262966-15281-8-git-send-email-sjenning@linux.vnet.ibm.com>> <0e91c1e5-7a62-4b89-9473-09fff384a334@default> <50E32255.60901@linux.vnet.ibm.com> <26bb76b3-308e-404f-b2bf-3d19b28b393a@default> <50E4C1FA.4070701@linux.vnet.ibm.com> <640d712e-0217-456a-a2d1-d03dd7914a55@default>
In-Reply-To: <640d712e-0217-456a-a2d1-d03dd7914a55@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010415-5518-0000-0000-00000A7906AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 04:33 PM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>>
>> However, once the flushing code was introduced and could free an entry
>> from the zswap_fs_store() path, it became necessary to add a per-entry
>> refcount to make sure that the entry isn't freed while another code
>> path was operating on it.
> 
> Hmmm... doesn't the refcount at least need to be an atomic_t?

An entry's refcount is only ever changed under the tree lock, so
making them atomic_t would be redundantly atomic.

I should add a comment to that effect though, including all elements
that are protected by the tree lock which include:
* the tree structure
* the lru list
* the per-entry refcounts

I'll put that change in the queue for v2.

> Also, how can you "free" any entry of an rbtree while another
> thread is walking the rbtree?  (Deleting an entry from an rbtree
> causes rebalancing... afaik there is no equivalent RCU
> implementation for rbtrees... not that RCU would necessarily
> work well for this anyway.)

This also can't happen since a thread must obtain the tree lock before
accessing or changing the tree.

Regarding RCU, I saw that some work had been done on RCU aware rbtree
functions but they weren't ready yet.

> BTW, in case it appears otherwise, I'm trying to be helpful, not
> critical.  In the end, I think we are in agreement that in-kernel
> compression is very important and that the frontswap (and/or
> cleancache) interface(s) are the right way to identify compressible
> data, and we are mostly arguing allocation and implementation details.

Yes. I'm always grateful for comments about the code :)  At the very
least, it rehashes the justifications for design decisions.

Thanks,
Seth

