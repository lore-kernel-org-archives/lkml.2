Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0KIJMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:12:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55032 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab0KIJM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:12:28 -0500
Message-ID: <4CD91182.5010503@cn.fujitsu.com>
Date: Tue, 09 Nov 2010 17:16:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: MMU: retry #PF for softmmu
References: <4CD28B5F.1040205@cn.fujitsu.com> <4CD28CB4.9000906@cn.fujitsu.com> <20101109080631.GJ9036@redhat.com>
In-Reply-To: <20101109080631.GJ9036@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-09 17:12:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-09 17:12:56,
	Serialize complete at 2010-11-09 17:12:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 04:06 PM, Gleb Natapov wrote:
> On Thu, Nov 04, 2010 at 06:36:36PM +0800, Xiao Guangrong wrote:
>> Retry #PF for softmmu only when the current vcpu has the same
>> root shadow page as the time when #PF occurs. it means they
>> have same paging environment.
>>
> Avi had an idea to allocate spte at the fault time, get reference
> to it and populate it on completion instead of prefaulting. How hard
> will it be?
> 

Um. if we do it like this, we can't populate it directly, we should:

- hold mmu_lock and walk vcpu's page table to see whether this spte is mapping
  in vcpu's page table (since the middle mapping can be zapped during apf is
  requesting and shadow page table can be switched)

- the guest page mapping can be modified by other vcpu or other process, we need
  re-walk guest page table.

I prefer to the way in this patch since it's very light.
