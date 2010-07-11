Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0GKPkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 11:40:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab0GKPkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 11:40:12 -0400
Message-ID: <4C39E5D7.7030703@redhat.com>
Date: Sun, 11 Jul 2010 18:40:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 2/9] KVM: MMU: fix race between 'walk_addr' and 'fetch'
References: <4C330918.6040709@cn.fujitsu.com> <4C330948.1070305@cn.fujitsu.com> <4C39BE90.1030802@redhat.com>
In-Reply-To: <4C39BE90.1030802@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2010 03:52 PM, Avi Kivity wrote:
> On 07/06/2010 01:45 PM, Xiao Guangrong wrote:
>> 'walk_addr' is out of mmu_lock's protection, so while we handle 'fetch',
>> then guest's mapping has modifited by other vcpu's write path, such as
>> invlpg, pte_write and other fetch path
>>
>> Fixed by checking all level's mapping
>>
>>
>> @@ -319,22 +319,23 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, 
>> gva_t addr,
>>           direct_access&= ~ACC_WRITE_MASK;
>>
>>       for_each_shadow_entry(vcpu, addr, iterator) {
>> +        bool nonpresent = false, last_mapping = false;
>> +
>
> I don't like these two new variables, but no suggestion at the 
> moment.  I'll try to simplify this loop later.
>
> One idea may be:
>
>    while (level > walker.level) {
>          handle indirect pages
>    }
>    while (level > hlevel) {
>          handle direct pages
>    }
>    handle last spte
>
> I'm worried that this change is too big for backporting, but no 
> suggestions on how to make it smaller, so we'll have to accept it.

Okay, I couldn't resist, posting this soon.

-- 
error compiling committee.c: too many arguments to function

