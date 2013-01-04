Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3ADWr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:47:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44687 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3ADWrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:47:52 -0500
MIME-Version: 1.0
Message-ID: <f66f40b3-6568-4183-b592-2990d4cd2083@default>
Date: Fri, 4 Jan 2013 14:45:28 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: RE: [PATCH 7/8] zswap: add to mm/
References: <<1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>>
 <<1355262966-15281-8-git-send-email-sjenning@linux.vnet.ibm.com>>
 <0e91c1e5-7a62-4b89-9473-09fff384a334@default>
 <50E32255.60901@linux.vnet.ibm.com>
 <26bb76b3-308e-404f-b2bf-3d19b28b393a@default>
 <50E4C1FA.4070701@linux.vnet.ibm.com>
 <640d712e-0217-456a-a2d1-d03dd7914a55@default>
 <50E6F862.2030703@linux.vnet.ibm.com>
In-Reply-To: <50E6F862.2030703@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH 7/8] zswap: add to mm/
> 
> On 01/03/2013 04:33 PM, Dan Magenheimer wrote:
> >> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> >>
> >> However, once the flushing code was introduced and could free an entry
> >> from the zswap_fs_store() path, it became necessary to add a per-entry
> >> refcount to make sure that the entry isn't freed while another code
> >> path was operating on it.
> >
> > Hmmm... doesn't the refcount at least need to be an atomic_t?
> 
> An entry's refcount is only ever changed under the tree lock, so
> making them atomic_t would be redundantly atomic.

Maybe I'm missing something still but then I think you also
need to evaluate and act on the refcount (not just read it) while
your treelock is held.  I.e., in:

> +		/* page is already in the swap cache, ignore for now */
> +		spin_lock(&tree->lock);
> +		refcount = zswap_entry_put(entry);
> +		spin_unlock(&tree->lock);
> +
> +		if (likely(refcount))
> +			return 0;
> +
> +		/* if the refcount is zero, invalidate must have come in */
> +		/* free */
> +		zs_free(tree->pool, entry->handle);
> +		zswap_entry_cache_free(entry);
> +		atomic_dec(&zswap_stored_pages);

the entry's refcount may be changed by another processor
immediately after the unlock, and then the "if (refcount)"
is testing a stale value and you will get (I think) a memory leak.

There is similar racy code in zswap_fs_invalidate_page which
I think could lead to a double free.  There's another
I think in zswap_fs_load...  And the refcount is dec'd
in one path inside of zswap_fs_store as well which may
race with the above.

When flushing multiple zpages to free a pageframe, you may
need to test refcounts for all the entries while within the lock.
If so, this is one place where the high-density storage will make
things messy, especially if page boundaries are crossed.

A nit: Even I, steeped in tmem terminology, was confused by
your use of "fs"... to nearly all readers it will
be translated as "filesystem" which is mystifying.
Just spell it out "frontswap", even if it causes a few
lines to be wrapped.

Have a good weekend!
Dan
