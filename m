Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2F1Rpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:45:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab2F1Rpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:45:30 -0400
Message-ID: <4FEC96EB.1050307@redhat.com>
Date: Thu, 28 Jun 2012 20:39:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, mtosatti@redhat.com,
        agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 5/6] KVM: Separate rmap_pde from kvm_lpage_info->write_count
References: <20120628105733.ccd9abb3.yoshikawa.takuya@oss.ntt.co.jp> <20120628110141.7b908c91.yoshikawa.takuya@oss.ntt.co.jp> <4FEBCBB3.3060707@linux.vnet.ibm.com> <20120628124546.83a829f3.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120628124546.83a829f3.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 06:45 AM, Takuya Yoshikawa wrote:
> On Thu, 28 Jun 2012 11:12:51 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> >  struct kvm_arch_memory_slot {
>> > +	unsigned long *rmap_pde[KVM_NR_PAGE_SIZES - 1];
>> >  	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
>> >  };
>> > 
>> 
>> It looks little complex than before - need manage more alloc-ed/freed buffers.
> 
> Actually I want to integrate rmap and rmap_pde in the future:
> 
> 	rmap[KVM_NR_PAGE_SIZES]

That's a good direction.

> 
> For this we need to modify some unrelated ppc code, so I just
> avoided the integration in this series.
> 
> Note: write_count: 4 bytes, rmap_pde: 8 bytes.  So we are wasting
> extra paddings by packing them into lpage_info.

The wastage is quite low since it's just 4 bytes per 2MB.

> 
>> Why not just introduce a function to get the next rmap? Something like this:
> 
> I want to eliminate this kind of overheads.

I don't think the overhead is significant.  rmap walk speed is largely a
function of cache misses IMO, and we may even be adding cache misses by
splitting lpage_info.

But I still think it's the right thing since it simplifies the code.
Maybe we should add a prefetch() on write_count do mitigate the
overhead, if it starts showing up in profiles.

-- 
error compiling committee.c: too many arguments to function


