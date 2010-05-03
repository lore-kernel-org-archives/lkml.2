Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0ECGHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 02:07:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab0ECGHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 02:07:06 -0400
Message-ID: <4BDE67DA.4080004@redhat.com>
Date: Mon, 03 May 2010 09:06:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: xiaosuo@gmail.com, jslaby@suse.cz, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, adobriyan@gmail.com, mingo@elte.hu,
       peterz@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
References: <viro@zeniv.linux.org.uk>	<1272818776-7729-1-git-send-email-xiaosuo@gmail.com>	<4BDDB6E9.4060703@redhat.com> <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp>
In-Reply-To: <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 03:15 AM, Tetsuo Handa wrote:
> Avi Kivity wrote:
>    
>> On 05/02/2010 07:46 PM, Changli Gao wrote:
>>      
>>> use kmalloc() to allocate fdmem if possible.
>>>
>>> vmalloc() is used as a fallback solution for fdmem allocation. Two members are
>>> added into the hole of the structure fdtable to indicate if vmalloc() is used
>>> or not.
>>>
>>>
>>> diff --git a/fs/file.c b/fs/file.c
>>> index 34bb7f7..f71dd85 100644
>>> --- a/fs/file.c
>>> +++ b/fs/file.c
>>> @@ -39,28 +39,34 @@ int sysctl_nr_open_max = 1024 * 1024; /* raised later */
>>>     */
>>>    static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
>>>
>>> -static inline void * alloc_fdmem(unsigned int size)
>>> +static inline void *alloc_fdmem(unsigned int size, unsigned short *use_vmalloc)
>>>    {
>>> -	if (size<= PAGE_SIZE)
>>> -		return kmalloc(size, GFP_KERNEL);
>>> -	else
>>> -		return vmalloc(size);
>>> +	void *data;
>>> +
>>> +	data = kmalloc(size, GFP_KERNEL);
>>> +	if (data != NULL) {
>>> +		*use_vmalloc = 0;
>>> +		return data;
>>> +	}
>>> +	*use_vmalloc = 1;
>>> +
>>> +	return vmalloc(size);
>>>    }
>>>
>>>        
>> Perhaps vmalloc() should do this by itself?  vfree() can examine the
>> pointer and call kfree() if it isn't within the vmalloc address range.
>>      
> You can use is_vmalloc_addr().
>
> 	if (is_vmalloc_addr(p))
> 		vfree(p);
> 	else
> 		kfree(p);
>    


My point is, vmalloc() and vfree should do this, not their callers:

vmalloc(size):
     if (size <= PAGE_SIZE)
         return kmalloc(size, GFP_KERNEL);
     ...

vfree(p):
     if (!is_vmalloc_addr(p) {
         kfree(p);
         return;
     }
     ...

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

