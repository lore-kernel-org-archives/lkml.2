Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab0DLMtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:49:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab0DLMt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:49:29 -0400
Message-ID: <4BC316D1.3030009@redhat.com>
Date: Mon, 12 Apr 2010 15:49:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] KVM MMU: fix kvm_mmu_zap_page() and its calling path
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D345.100@cn.fujitsu.com> <4BC2D8D6.6030306@redhat.com> <4BC2DFA0.6000609@cn.fujitsu.com> <4BC2E2FF.9020005@redhat.com> <4BC2E654.7050002@cn.fujitsu.com> <4BC2F536.70808@redhat.com> <4BC310A0.3090005@cn.fujitsu.com>
In-Reply-To: <4BC310A0.3090005@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 03:22 PM, Xiao Guangrong wrote:
>
>> But kvm_mmu_zap_page() will only destroy sp == tpos == pos; n points at
>> pos->next already, so it's safe.
>>
>>      
> kvm_mmu_zap_page(sp) not only zaps sp but also zaps all sp's unsync children
> pages, if n is just sp's unsyc child, just at the same hlist and just behind sp,
> it will crash. :-)
>    

Ouch.  I see now, thanks for explaining.

One way to fix it is to make kvm_mmu_zap_page() only zap the page it is 
given, and use sp->role.invalid on its children.  But it's better to fix 
it now quickly and do the more involved fixes later.

Just change the assignment to a 'goto restart;' please, I don't like 
playing with list_for_each internals.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

