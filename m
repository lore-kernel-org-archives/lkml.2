Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3AGOr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:47:57 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54404 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab3AGOr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:47:56 -0500
Message-ID: <50EAE015.1000702@linux.vnet.ibm.com>
Date: Mon, 07 Jan 2013 08:47:49 -0600
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
References: <<1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>> <<1355262966-15281-8-git-send-email-sjenning@linux.vnet.ibm.com>> <0e91c1e5-7a62-4b89-9473-09fff384a334@default> <50E32255.60901@linux.vnet.ibm.com> <26bb76b3-308e-404f-b2bf-3d19b28b393a@default> <50E4C1FA.4070701@linux.vnet.ibm.com> <640d712e-0217-456a-a2d1-d03dd7914a55@default> <50E6F862.2030703@linux.vnet.ibm.com> <f66f40b3-6568-4183-b592-2990d4cd2083@default>
In-Reply-To: <f66f40b3-6568-4183-b592-2990d4cd2083@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010714-7182-0000-0000-0000043B4C05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 04:45 PM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Subject: Re: [PATCH 7/8] zswap: add to mm/
>>
>> On 01/03/2013 04:33 PM, Dan Magenheimer wrote:
>>>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>>>>
>>>> However, once the flushing code was introduced and could free an entry
>>>> from the zswap_fs_store() path, it became necessary to add a per-entry
>>>> refcount to make sure that the entry isn't freed while another code
>>>> path was operating on it.
>>>
>>> Hmmm... doesn't the refcount at least need to be an atomic_t?
>>
>> An entry's refcount is only ever changed under the tree lock, so
>> making them atomic_t would be redundantly atomic.
> 
> Maybe I'm missing something still but then I think you also
> need to evaluate and act on the refcount (not just read it) while
> your treelock is held.  I.e., in:
> 
>> +		/* page is already in the swap cache, ignore for now */
>> +		spin_lock(&tree->lock);
>> +		refcount = zswap_entry_put(entry);
>> +		spin_unlock(&tree->lock);
>> +
>> +		if (likely(refcount))
>> +			return 0;
>> +
>> +		/* if the refcount is zero, invalidate must have come in */
>> +		/* free */
>> +		zs_free(tree->pool, entry->handle);
>> +		zswap_entry_cache_free(entry);
>> +		atomic_dec(&zswap_stored_pages);
> 
> the entry's refcount may be changed by another processor
> immediately after the unlock, and then the "if (refcount)"
> is testing a stale value and you will get (I think) a memory leak.

It is true that the refcount could be stale by the time we do the
check. However, all functions that do a zswap_entry_put(), which
potentially drops the refcount to 0, check the refcount and free the
entry if they need to.  All the functions that do a zswap_entry_put()
that result in the refcount being 0 also ensure that there is no way
for another thread to gain a reference to entry by either the tree or
lru list before releasing the lock.  That way the cleanup can happen
outside the lock with the risk of someone gaining access to the entry
being freed in the meantime.

<snip>
> A nit: Even I, steeped in tmem terminology, was confused by
> your use of "fs"... to nearly all readers it will
> be translated as "filesystem" which is mystifying.
> Just spell it out "frontswap", even if it causes a few
> lines to be wrapped.

Sound good. I'll queue it up.

Thanks,
Seth

