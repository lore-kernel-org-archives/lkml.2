Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1GFTYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:24:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49787 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab1GFTYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:24:19 -0400
Message-ID: <4E14B6D6.4020902@cn.fujitsu.com>
Date: Thu, 07 Jul 2011 03:26:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 16/19] KVM: MMU: lockless walking shadow page table
References: <4E0C3178.2080603@cn.fujitsu.com> <4E0C3337.5040304@cn.fujitsu.com> <20110706180859.GB9820@amt.cnet>
In-Reply-To: <20110706180859.GB9820@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 03:23:39,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 03:23:39,
	Serialize complete at 2011-07-07 03:23:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 02:08 AM, Marcelo Tosatti wrote:

>> +static void free_pages_rcu(struct rcu_head *head)
>> +{
>> +	struct kvm_mmu_page *next, *sp;
>> +
>> +	sp = container_of(head, struct kvm_mmu_page, rcu);
>> +	while (sp) {
>> +		if (!list_empty(&sp->link))
>> +			next = list_first_entry(&sp->link,
>> +				      struct kvm_mmu_page, link);
>> +		else
>> +			next = NULL;
>> +		kvm_mmu_free_page(sp);
>> +		sp = next;
>> +	}
>> +}
> 
> There is no need for this while loop.
> 

The while loop is needed, since many shadow pages can be freed together in
the rcu context, on commit_zap_page path, we only remove the list head, and
the shadow page is still listed.

 

