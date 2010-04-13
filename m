Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0DMDJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 23:09:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57742 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab0DMDJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 23:09:50 -0400
Message-ID: <4BC3DFE3.6090006@cn.fujitsu.com>
Date: Tue, 13 Apr 2010 11:07:15 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] KVM MMU: optimize for writing cr4
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D3E0.8070602@cn.fujitsu.com> <4BC2DB27.7060005@redhat.com> <4BC2F928.2060407@cn.fujitsu.com> <4BC30273.3050406@redhat.com>
In-Reply-To: <4BC30273.3050406@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

> See 6364a3918cb.  It was reverted later due to a problem with the
> implementation.  I'm not sure whether I want to fix the bug and restore
> that patch, or to drop it altogether and give the guest ownership of
> cr4.pge.  See cr4_guest_owned_bits (currently only used on ept).
> 

Oh, i see, thanks very much.

>> As i know, global page is not static in TLB, and x86 cpu also may
>> flush them form TLB,
>> maybe we no need treat global page specially... Am i miss something? :-(
>>    
> 
> You can't read reverted patches? :)

I usually use 'get blame' to look into source, and not noticed reverted
patches, i'll pay more attention on those.

Below code still confused me:

| vcpu->arch.mmu.base_role.cr4_pge = (cr4&  X86_CR4_PGE)&&!tdp_enabled; 

And i found the commit 87778d60ee:

|    KVM: MMU: Segregate mmu pages created with different cr4.pge settings
|    
|    Don't allow a vcpu with cr4.pge cleared to use a shadow page created with
|    cr4.pge set; this might cause a cr3 switch not to sync ptes that have the
|    global bit set (the global bit has no effect if !cr4.pge).
|    
|    This can only occur on smp with different cr4.pge settings for different
|    vcpus (since a cr4 change will resync the shadow ptes), but there's no
|    cost to being correct here.

In current code, cr3 switch will sync all unsync shadow pages(regardless it's
global or not) and this issue not live now, so, do we need also revert this
patch?

Xiao

