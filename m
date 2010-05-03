Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab0ECJS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:18:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab0ECJS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:18:26 -0400
Message-ID: <4BDE94C8.9000108@redhat.com>
Date: Mon, 03 May 2010 12:18:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Changli Gao <xiaosuo@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
References: <viro@zeniv.linux.org.uk> <1272818776-7729-1-git-send-email-xiaosuo@gmail.com> 	<4BDDB6E9.4060703@redhat.com> <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp> 	<4BDE67DA.4080004@redhat.com> <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com> 	<4BDE7E66.8030509@redhat.com> <m2l412e6f7f1005030052ka39a33ceke8c6b61553ba007f@mail.gmail.com> <4BDE8E24.5050200@redhat.com> <4BDE914C.6080504@suse.cz>
In-Reply-To: <4BDE914C.6080504@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 12:03 PM, Jiri Slaby wrote:
>
>    
>>> Because vmalloc is used to allocate virtually contiguous memory. v in
>>> vmalloc means virtually.
>>>
>>>
>>>        
>> A kmalloc()ed page is virtually contiguous, satisfying your requirement.
>>      
> But it won't work well for vmalloc_to_{page,pfn} and similar.

Modify vmalloc_to_{page,pfn} accordingly.

> Some code
> may expect vmalloc result to be in the vmalloc area and page-aligned
> (both in position and size).
>    

Both would be a bug IMO.  vmalloc() follows kmalloc() and malloc() which 
only guarantee natural alignment.

> Not that it won't be possible to inspect the callers, but in my eyes it
> would definitely be better to introduce kmalloc_or_vmalloc-alike where
> the caller explicitly doesn't care about the resulting position and size.
>    

You're forcing every user to make a choice about what's essentially a 
micro optimization.

If it's really needed to have a vmalloc-in-vmalloc-space, that should be 
a special function, while the ordinary vmalloc should make the optimization.

-- 
error compiling committee.c: too many arguments to function

