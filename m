Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1A0BJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:09:28 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42560 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1A0BJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:09:27 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D40C687.2020202@np.css.fujitsu.com>
Date: Thu, 27 Jan 2011 10:12:39 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
        =?UTF-8?B?QUtQTeOAgA==?= <akpm@linux-foundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Avoid unmapping THP when it is failed to be split.
References: <4D3E6377.6060803@np.css.fujitsu.com> <20110125220118.GJ926@random.random>
In-Reply-To: <20110125220118.GJ926@random.random>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrea

(2011/01/26 7:01), Andrea Arcangeli wrote:
> On Tue, Jan 25, 2011 at 02:45:27PM +0900, Jin Dongming wrote:
>> If the THP is failed to be split,
>>    1. The processes using the poisoned page could not be collected.
>>       (Because page_mapped_in_vma() in collect_procs_anon() always
>>        returns NULL.)
> 
> page_mapped_in_vma is only called after split_huge_page without
> requiring this change.
> 
>>    2. The poisoned page could not be unmapped.
>>       (If CONFIG_DEBUG_VM is "y", VM_BUG_ON(PageTransHuge(page))
>>        in try_to_unmap() will be called, and system panic will be
>>        caused.)
> 
> This is more reasonable argument for the change because at times
> collect_procs may fail kmalloc or for other reasons kill may be set to
> 1 without split_huge_page having run.
> 
>>    3. The processes using the poisoned page could not be killed, too.
>>       (Because no process is collected in 1.)
> 
> I don't see the point of the change for 1.
> 

I am sorry for my poor description.

>> So if splitting THP is failed, it is better to stop unmapping
>> rather than causing panic. System might servive if the page is freed
>> later.
> 
> Splitting THP can't fail unless the page is freed under
> split_huge_page (like if the process quits while you're calling
> split_huge_page and in turn the anon_vma was already unusable).
> 

Basically I agree with you.

But this patch could do the following things.
    1st, as your comment for point 2, this patch could avoid
         unexpected failure which is not the real failure of
         split_huge_page().
    2nd, from the result of failure of split_huge_page(), 
         the operations after it is not meaningful any more or
         unexpected.
    3rd, this patch can reduce the account of patches after it.

So I will modify the description like following.
  1. Describe the result of failure of split_huge_page() clearly.
  2. Add the reason why move split_huge_page() here.

How do you think about it?

> Patch looks good but just for point 2.

Thanks.

Best Regards,
Jin Dongming

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


