Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2JZBsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 21:48:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36039 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2JZBs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 21:48:29 -0400
Message-ID: <5089EBE1.1050009@gmail.com>
Date: Fri, 26 Oct 2012 09:48:17 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: shmem_getpage_gfp VM_BUG_ON triggered. [3.7rc2]
References: <20121025023738.GA27001@redhat.com> <alpine.LNX.2.00.1210242121410.1697@eggly.anvils> <5088C51D.3060009@gmail.com> <alpine.LNX.2.00.1210242338030.2688@eggly.anvils> <508912B0.7080805@gmail.com> <alpine.LNX.2.00.1210251419260.3623@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1210251419260.3623@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 05:27 AM, Hugh Dickins wrote:
> On Thu, 25 Oct 2012, Ni zhan Chen wrote:
>> On 10/25/2012 02:59 PM, Hugh Dickins wrote:
>>> On Thu, 25 Oct 2012, Ni zhan Chen wrote:
>>>> I think it maybe caused by your commit [d189922862e03ce: shmem: fix
>>>> negative
>>>> rss in memcg memory.stat], one question:
>>> Well, yes, I added the VM_BUG_ON in that commit.
>>>
>>>> if function shmem_confirm_swap confirm the entry has already brought back
>>>> from swap by a racing thread,
>>> The reverse: true confirms that the swap entry has not been brought back
>>> from swap by a racing thread; false indicates that there has been a race.
>>>
>>>> then why call shmem_add_to_page_cache to add
>>>> page from swapcache to pagecache again?
>>> Adding it to pagecache again, after such a race, would set error to
>>> -EEXIST (originating from radix_tree_insert); but we don't do that,
>>> we add it to pagecache when it has not already been added.
>>>
>>> Or that's the intention: but Dave seems to have found an unexpected
>>> exception, despite us holding the page lock across all this.
>>>
>>> (But if it weren't for the memcg and replace_page issues, I'd much
>>> prefer to let shmem_add_to_page_cache discover the race as before.)
>>>
>>> Hugh
>> Hi Hugh
>>
>> Thanks for your response. You mean the -EEXIST originating from
>> radix_tree_insert, in radix_tree_insert:
>> if (slot != NULL)
>>      return -EEXIST;
>> But why slot should be NULL? if no race, the pagecache related radix tree
>> entry should be RADIX_TREE_EXCEPTIONAL_ENTRY+swap_entry_t.val, where I miss?
> I was describing what would happen in a case that should not exist,
> that you had thought the common case.  In actuality, the entry should
> not be NULL, it should be as you say there.

Thanks for your patience. So in the common case, the entry should be the 
value I mentioned, then why has this check?
if (slot != NULL)
     return -EEXIST;

the common case will return -EEXIST.

>
> Hugh
>

