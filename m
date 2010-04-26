Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab0DZGIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 02:08:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab0DZGIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 02:08:01 -0400
Message-ID: <4BD52DBA.5070001@redhat.com>
Date: Mon, 26 Apr 2010 09:07:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/10] KVM MMU: don't write-protect if have new mapping
 to unsync page
References: <4BD3E306.4020202@cn.fujitsu.com> <4BD3E8AB.4020704@cn.fujitsu.com> <4BD412A0.1000101@redhat.com> <4BD50F63.1010008@cn.fujitsu.com>
In-Reply-To: <4BD50F63.1010008@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 06:58 AM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>    
>> On 04/25/2010 10:00 AM, Xiao Guangrong wrote:
>>      
>>> Two cases maybe happen in kvm_mmu_get_page() function:
>>>
>>> - one case is, the goal sp is already in cache, if the sp is unsync,
>>>     we only need update it to assure this mapping is valid, but not
>>>     mark it sync and not write-protect sp->gfn since it not broke unsync
>>>     rule(one shadow page for a gfn)
>>>
>>> - another case is, the goal sp not existed, we need create a new sp
>>>     for gfn, i.e, gfn (may)has another shadow page, to keep unsync rule,
>>>     we should sync(mark sync and write-protect) gfn's unsync shadow page.
>>>     After enabling multiple unsync shadows, we sync those shadow pages
>>>     only when the new sp not allow to become unsync(also for the unsyc
>>>     rule, the new rule is: allow all pte page become unsync)
>>>
>>>        
>> Another interesting case is to create new shadow pages in the unsync
>> state.  That can help when the guest starts a short lived process: we
>> can avoid write protecting its pagetables completely.  Even if we do
>> sync them, we can sync them in a batch instead of one by one, saving IPIs.
>>      
> IPI is needed when rmap_write_protect() changes mappings form writable to read-only,
> so while we sync all gfn's unsync page, only one IPI is needed.
>    

I meant, we can write protect all pages, then use one IPI to drop the 
tlbs for all of them.

> And, another problem is we call ramp_write_protect()/flush-local-tlb many times when sync gfn's
> unsync page, the same problem is in mmu_sync_children() function, could you allow me to improve
> it after this patchset? :-)
>    

Of course, this is more than enough to chew on.  Just suggesting an idea...


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

