Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab1HXE3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:29:49 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60290 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1HXE3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:29:44 -0400
X-AuditID: b753bd60-a3c7dba0000050a4-4e-4e547e34c0c2
X-AuditID: b753bd60-a3c7dba0000050a4-4e-4e547e34c0c2
Message-ID: <4E547E32.4030001@hitachi.com>
Date: Wed, 24 Aug 2011 13:29:38 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        yrl.pp-manager.tt@hitachi.com, David Rientjes <rientjes@google.com>,
        Namhyung Kim <namhyung@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH -v3] avoid null pointer access in vm_struct
References: <20110821082132.28358.72280.stgit@ltc219.sdl.hitachi.co.jp> <20110822152505.22b58998.akpm@linux-foundation.org>
In-Reply-To: <20110822152505.22b58998.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

(2011/08/23 7:25), Andrew Morton wrote:
> On Sun, 21 Aug 2011 17:21:32 +0900
> Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> wrote:
> 
>> The /proc/vmallocinfo shows information about vmalloc allocations in vmlist
>> that is a linklist of vm_struct. It, however, may access pages field of
>> vm_struct where a page was not allocated. This results in a null pointer
>> access and leads to a kernel panic.
>>
>> Why this happen:
>> In __vmalloc_node_range() called from vmalloc(), newly allocated vm_struct
>> is added to vmlist at __get_vm_area_node() and then, some fields of
>> vm_struct such as nr_pages and pages are set at __vmalloc_area_node(). In
>> other words, it is added to vmlist before it is fully initialized. At the
>> same time, when the /proc/vmallocinfo is read, it accesses the pages field
>> of vm_struct according to the nr_pages field at show_numa_info(). Thus, a
>> null pointer access happens.
>>
>> Patch:
>> This patch adds newly allocated vm_struct to the vmlist *after* it is fully
>> initialized. So, it can avoid accessing the pages field with unallocated
>> page when show_numa_info() is called.
> 
> Seems rather ugly, but I guess it's OK.  vmalloc() is "special" in that
> it fills the area with allocated pages, whereas all the
> get_vm_area()-type callers don't do that.
> 
>>
>> ...
>>
>> @@ -1381,17 +1403,20 @@ struct vm_struct *remove_vm_area(const void *addr)
>>  	va = find_vmap_area((unsigned long)addr);
>>  	if (va && va->flags & VM_VM_AREA) {
>>  		struct vm_struct *vm = va->private;
>> -		struct vm_struct *tmp, **p;
>> -		/*
>> -		 * remove from list and disallow access to this vm_struct
>> -		 * before unmap. (address range confliction is maintained by
>> -		 * vmap.)
>> -		 */
>> -		write_lock(&vmlist_lock);
>> -		for (p = &vmlist; (tmp = *p) != vm; p = &tmp->next)
>> -			;
>> -		*p = tmp->next;
>> -		write_unlock(&vmlist_lock);
>> +
>> +		if (!(vm->flags & VM_UNLIST)) {
>> +			struct vm_struct *tmp, **p;
>> +			/*
>> +			 * remove from list and disallow access to
>> +			 * this vm_struct before unmap. (address range
>> +			 * confliction is maintained by vmap.)
>> +			 */
>> +			write_lock(&vmlist_lock);
>> +			for (p = &vmlist; (tmp = *p) != vm; p = &tmp->next)
>> +				;
>> +			*p = tmp->next;
>> +			write_unlock(&vmlist_lock);
>> +		}
> 
> Is this needed?  How can remove_vm_area() actually be called with a
> VM_UNLIST area?
> 

Yes, it is needed because this patch does not add the newly allocated vm_struct
to vmlist at __get_vm_area_node(). So, revove_vm_area() with unlisted vm_struct
will be called when an error occurs within __vmalloc_area_node(). 

> 
> I think I'll let this patch cook in linux-next for a while and shall
> tag it for backporting into 3.1.x later on.
> 

I see, thank you. 
