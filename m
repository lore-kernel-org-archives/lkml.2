Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2DIIh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:37:28 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38526 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab2DIIgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:36:49 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V5 06/14] hugetlb: Simplify migrate_huge_page
In-Reply-To: <4F8277ED.8040904@jp.fujitsu.com>
References: <1333738260-1329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1333738260-1329-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F8277ED.8040904@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 09 Apr 2012 14:06:33 +0530
Message-ID: <87398de1yl.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12040822-9264-0000-0000-000001349AD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> (2012/04/07 3:50), Aneesh Kumar K.V wrote:
>
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> Since we migrate only one hugepage don't use linked list for passing
>> the page around. Directly pass page that need to be migrated as argument.
>> This also remove the usage page->lru in migrate path.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>
>
> seems good to me. I have one question below.
>
>
>> ---

...... snip ......


>> -	list_add(&hpage->lru, &pagelist);
>> -	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
>> -				true);
>> +	ret = migrate_huge_page(page, new_page, MPOL_MF_MOVE_ALL, 0, true);
>> +	put_page(page);
>>  	if (ret) {
>> -		struct page *page1, *page2;
>> -		list_for_each_entry_safe(page1, page2, &pagelist, lru)
>> -			put_page(page1);
>> -
>>  		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
>>  			pfn, ret, page->flags);
>> -		if (ret > 0)
>> -			ret = -EIO;   <---------------------------- here
>>  		return ret;
>>  	}
>>  done:
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 51c08a0..d7eb82d 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -929,15 +929,8 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
>>  	if (anon_vma)
>>  		put_anon_vma(anon_vma);
>>  	unlock_page(hpage);

.... snip .....

>> -
>> -			rc = unmap_and_move_huge_page(get_new_page,
>> -					private, page, pass > 2, offlining,
>> -					mode);
>> -
>> -			switch(rc) {
>> -			case -ENOMEM:
>> -				goto out;
>> -			case -EAGAIN:
>> -				retry++;
>> -				break;
>> -			case 0:
>> -				break;
>> -			default:
>> -				/* Permanent failure */
>> -				nr_failed++;
>> -				break;
>> -			}
>> +			break;
>> +		case 0:
>> +			goto out;
>> +		default:
>> +			rc = -EIO;
>> +			goto out;
>
>
> why -EIO ? Isn't this BUG() ??

I am not sure doing a BUG() for migrate is a good idea. We may want to
return error and let the higher layer handle this. Also as you see in
the two hunks I listed above, default is mapped to -EIO in the current
code. I didn't want to change that.

-aneesh

