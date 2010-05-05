Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934693Ab0EEMwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934498Ab0EEMwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:52:18 -0400
Message-ID: <4BE169FE.3020805@redhat.com>
Date: Wed, 05 May 2010 15:52:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM MMU: fix race in invlpg code
References: <4BE16265.7060004@cn.fujitsu.com> <4BE162B9.201@cn.fujitsu.com> <4BE1650B.7080809@redhat.com> <4BE1686D.9000902@cn.fujitsu.com>
In-Reply-To: <4BE1686D.9000902@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 03:45 PM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>
>    
>>>        spin_lock(&vcpu->kvm->mmu_lock);
>>> +    index = kvm_page_table_hashfn(gfn);
>>> +    bucket =&vcpu->kvm->arch.mmu_page_hash[index];
>>> +    hlist_for_each_entry_safe(s, node, tmp, bucket, hash_link)
>>> +        if (s == sp) {
>>> +            if (s->gfn == gfn&&   s->role.word == role.word)
>>> +                live = true;
>>> +            break;
>>> +        }
>>> +
>>> +    if (!live)
>>> +        goto unlock_exit;
>>> +
>>>
>>>        
>> Did you try the root_count method?  I think it's cleaner.
>>      
> Avi, Thanks for your idea.
>
> I have considered this method, but i'm not sure when it's the good time
> to real free this page, and i think we also need a way to synchronize the
> real free path and this path. Do you have any comment for it :-(
>    

Same as mmu_free_roots():

         --sp->root_count;
         if (!sp->root_count && sp->role.invalid) {
                 kvm_mmu_zap_page(vcpu->kvm, sp);
                 goto unlock_exit;
         }


-- 
error compiling committee.c: too many arguments to function

