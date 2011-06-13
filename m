Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1FMDNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 23:13:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53042 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab1FMDNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 23:13:18 -0400
Message-ID: <4DF580C8.5060600@cn.fujitsu.com>
Date: Mon, 13 Jun 2011 11:15:20 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 09/15] KVM: MMU: split kvm_mmu_free_page
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE21AE.9050703@cn.fujitsu.com> <4DF0712B.5050400@redhat.com> <4DF19484.8000707@cn.fujitsu.com> <4DF479C5.3010002@redhat.com>
In-Reply-To: <4DF479C5.3010002@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-13 11:12:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-13 11:13:00,
	Serialize complete at 2011-06-13 11:13:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2011 04:33 PM, Avi Kivity wrote:
> On 06/10/2011 06:50 AM, Xiao Guangrong wrote:
>> >>  +static void kvm_mmu_free_unlock_parts(struct kvm_mmu_page *sp)
>> >>  +{
>> >>  +    list_del(&sp->link);
>> >>  +    free_page((unsigned long)sp->spt);
>> >>        kmem_cache_free(mmu_page_header_cache, sp);
>> >>    }
>> >
>> >  The list_del() must be run under a lock, no? it can access kvm->arch.active_mmu_pages.
>> >
>>
>> In prepare path, we have moved the sp from active_mmu_pages to invlaid_list.
> 
> It still needs to be accessed under a lock, no matter which list is used.
> 

Actually, if we need to free page in RCU context, we unlink them from invalid_list firstly:

if (atomic_read(&kvm->arch.reader_counter)) {
		......
		list_del_init(invalid_list);
		trace_kvm_mmu_delay_free_pages(sp);
		call_rcu(&sp->rcu, free_invalid_pages_rcu);
		return;
	}

Then, global list is not used anymore. 
