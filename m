Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab2FSXVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:21:07 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42908 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750814Ab2FSXVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:21:04 -0400
Date: Tue, 19 Jun 2012 18:21:02 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        hughd@google.com, npiggin@gmail.com, cl@linux.com,
        lee.schermerhorn@hp.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH v2] tmpfs not interleaving properly
Message-ID: <20120619232102.GA5698@gulag1.americas.sgi.com>
References: <20120531143916.GA16162@gulag1.americas.sgi.com> <4FC7CFEB.5040009@gmail.com> <20120531132515.6af60152.akpm@linux-foundation.org> <4FC7D629.3090801@gmail.com> <20120601142437.GA13739@gulag1.americas.sgi.com> <4FC8FA47.70001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC8FA47.70001@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 01:22:15PM -0400, KOSAKI Motohiro wrote:
> (6/1/12 10:24 AM), Nathan Zimmer wrote:
>> On Thu, May 31, 2012 at 04:35:53PM -0400, KOSAKI Motohiro wrote:
>>> (5/31/12 4:25 PM), Andrew Morton wrote:
>>>> On Thu, 31 May 2012 16:09:15 -0400
>>>> KOSAKI Motohiro<kosaki.motohiro@gmail.com>   wrote:
>>>>
>>>>>> --- a/mm/shmem.c
>>>>>> +++ b/mm/shmem.c
>>>>>> @@ -929,7 +929,7 @@ static struct page *shmem_alloc_page(gfp_t gfp,
>>>>>>     	/*
>>>>>>     	 * alloc_page_vma() will drop the shared policy reference
>>>>>>     	 */
>>>>>> -	return alloc_page_vma(gfp,&pvma, 0);
>>>>>> +	return alloc_page_vma(gfp,&pvma, info->node_offset<<    PAGE_SHIFT );
>>>>>
>>>>> 3rd argument of alloc_page_vma() is an address. This is type error.
>>>>
>>>> Well, it's an unsigned long...
>>>>
>>>> But yes, it is conceptually wrong and *looks* weird.  I think we can
>>>> address that by overcoming our peculair aversion to documenting our
>>>> code, sigh.  This?
>>>
>>> Sorry, no.
>>>
>>> addr agrument of alloc_pages_vma() have two meanings.
>>>
>>> 1) interleave node seed
>>> 2) look-up key of shmem policy
>>>
>>> I think this patch break (2). shmem_get_policy(pol, addr) assume caller honor to
>>> pass correct address.
>>
>> But the pseudo vma we generated in shmem_alloc_page the vm_ops are set to NULL.
>> So get_vma_policy will return the policy provided by the pseudo vma and not reach
>> the shmem_get_policy.
>
> yes, and it is bug source. we may need to change soon. I guess the right way is
> to make vm_ops->interleave and interleave_nid uses it if povided.
>

If we provide vm_ops then won't shmem_get_policy get called?
That would be an issue since shmem_get_policy assumes vm_file is non NULL.

> btw, I don't think node_random() is good idea. it is random(pid + jiffies + cycle).
> current->cpuset_mem_spread_rotor is per-thread value. but you now need per-inode
> interleave offset. maybe, just inode addition is enough. Why do you need randomness?
>

I don't really need the randomness, the rotor should be good enough.
The correct way to get that is cpuset_mem_spread_node(), yes?

Also apologies for such a delay in my response.
