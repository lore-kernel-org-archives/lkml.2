Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab1HTEWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 00:22:51 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40492 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1HTEWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 00:22:49 -0400
X-AuditID: b753bd60-9fe84ba000000655-7b-4e4f3696ed79
X-AuditID: b753bd60-9fe84ba000000655-7b-4e4f3696ed79
Message-ID: <4E4F367B.8060904@hitachi.com>
Date: Sat, 20 Aug 2011 13:22:19 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH v2] avoid null pointer access in vm_struct
References: <20110819105133.7504.62129.stgit@ltc219.sdl.hitachi.co.jp> <20110819155238.b11d19fb.akpm@linux-foundation.org>
In-Reply-To: <20110819155238.b11d19fb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul and Andrew,

(2011/08/20 3:53), Paul E. McKenney wrote:
>> @@ -1562,6 +1561,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>>  		}
>>  		area->pages[i] = page;
>>  	}
> Don't we need something here to prevent the compiler and/or the CPU
> from reordering the assignment?  Or am I missing how this is otherwise
> prevented?
>

(2011/08/20 7:52), Andrew Morton wrote:
> I think this is still just a workaround to fix up the real bug, and
> that the real bug is that the vm_struct is installed into the vmlist
> *before* it is fully initialised.  It's just wrong to insert an object
> into a globally-visible list and to then start populating it!  If we
> were instead to fully initialise the vm_struct and *then* insert it
> into vmlist, the bug is fixed.
>
> Also I'd agree with Paul's concern regarding cross-CPU memory ordering.
>

I deeply agreed with both of your concern and comments.
I'd like to create the patch where the vm_struct is installed into 
the vmlist *after* it is fully initialized.

Thanks.


(2011/08/20 7:52), Andrew Morton wrote:
> On Fri, 19 Aug 2011 19:51:33 +0900
> Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> wrote:
> 
>> The /proc/vmallocinfo shows information about vmalloc allocations in vmlist
>> that is a linklist of vm_struct. It, however, may access pages field of
>> vm_struct where a page was not allocated, which results in a null pointer
>> access and leads to a kernel panic.
>>
>> Why this happen:
>> In __vmalloc_area_node(), the nr_pages field of vm_struct are set to the
>> expected number of pages to be allocated, before the actual pages
>> allocations. At the same time, when the /proc/vmallocinfo is read, it
>> accesses the pages field of vm_struct according to the nr_pages field at
>> show_numa_info(). Thus, a null pointer access happens.
>>
>> Patch:
>> This patch sets nr_pages field of vm_struct AFTER the pages allocations
>> finished in __vmalloc_area_node(). So, it can avoid accessing the pages
>> field with unallocated page when show_numa_info() is called.
> 
> I think this is still just a workaround to fix up the real bug, and
> that the real bug is that the vm_struct is installed into the vmlist
> *before* it is fully initialised.  It's just wrong to insert an object
> into a globally-visible list and to then start populating it!  If we
> were instead to fully initialise the vm_struct and *then* insert it
> into vmlist, the bug is fixed.
> 
> Also I'd agree with Paul's concern regarding cross-CPU memory ordering.
> 

