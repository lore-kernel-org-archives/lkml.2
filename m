Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0ECJDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:03:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65208 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0ECJDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mgyn2jiLuyfPgJTIC/mWO+cPWKlVs6PnTrOVckumZv7YxO6ohTU0+H/LiAR+V1WqqV
         YTZbnAJqN+2uQDXku7wqKj43JglVcb78CfIuZckpPAIIGXm73a321ZEamkeVFe7ghX34
         lJ5g1fZ2JX6ptjrCvJBCJB+aiTOvKwZpdwHnY=
Message-ID: <4BDE914C.6080504@suse.cz>
Date: Mon, 03 May 2010 11:03:08 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.6 Thunderbird/3.1b1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Changli Gao <xiaosuo@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
References: <viro@zeniv.linux.org.uk> <1272818776-7729-1-git-send-email-xiaosuo@gmail.com> 	<4BDDB6E9.4060703@redhat.com> <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp> 	<4BDE67DA.4080004@redhat.com> <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com> 	<4BDE7E66.8030509@redhat.com> <m2l412e6f7f1005030052ka39a33ceke8c6b61553ba007f@mail.gmail.com> <4BDE8E24.5050200@redhat.com>
In-Reply-To: <4BDE8E24.5050200@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 10:49 AM, Avi Kivity wrote:
> On 05/03/2010 10:52 AM, Changli Gao wrote:
>> On Mon, May 3, 2010 at 3:42 PM, Avi Kivity<avi@redhat.com>  wrote:
>>   
>>> On 05/03/2010 10:05 AM, Changli Gao wrote:
>>>     
>>>> On Mon, May 3, 2010 at 2:06 PM, Avi Kivity<avi@redhat.com>    wrote:
>>>>
>>>>       
>>>>> My point is, vmalloc() and vfree should do this, not their callers:
>>>>>
>>>>> vmalloc(size):
>>>>>     if (size<= PAGE_SIZE)
>>>>>         return kmalloc(size, GFP_KERNEL);
>>>>>     ...
>>>>>
>>>>> vfree(p):
>>>>>     if (!is_vmalloc_addr(p) {
>>>>>         kfree(p);
>>>>>         return;
>>>>>     }
>>>>>     ...
>>>>>
>>>>>          
>>>> I think we should not change vmalloc/vfree, and you can invent new
>>>> memory APIs, such as malloc()/free().
>>>>
>>>>        
>>> Why?
>>>
>>>      
>> Because vmalloc is used to allocate virtually contiguous memory. v in
>> vmalloc means virtually.
>>
>>    
> 
> A kmalloc()ed page is virtually contiguous, satisfying your requirement.

But it won't work well for vmalloc_to_{page,pfn} and similar. Some code
may expect vmalloc result to be in the vmalloc area and page-aligned
(both in position and size).

Not that it won't be possible to inspect the callers, but in my eyes it
would definitely be better to introduce kmalloc_or_vmalloc-alike where
the caller explicitly doesn't care about the resulting position and size.

regards,
-- 
js
suse labs
