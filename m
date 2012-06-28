Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab2F1DqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 23:46:01 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:42848 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab2F1Dp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 23:45:59 -0400
Date: Thu, 28 Jun 2012 12:45:46 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de, paulus@samba.org,
        aarcange@redhat.com, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 5/6] KVM: Separate rmap_pde from
 kvm_lpage_info->write_count
Message-Id: <20120628124546.83a829f3.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4FEBCBB3.3060707@linux.vnet.ibm.com>
References: <20120628105733.ccd9abb3.yoshikawa.takuya@oss.ntt.co.jp>
	<20120628110141.7b908c91.yoshikawa.takuya@oss.ntt.co.jp>
	<4FEBCBB3.3060707@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 11:12:51 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> >  struct kvm_arch_memory_slot {
> > +	unsigned long *rmap_pde[KVM_NR_PAGE_SIZES - 1];
> >  	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
> >  };
> > 
> 
> It looks little complex than before - need manage more alloc-ed/freed buffers.

Actually I want to integrate rmap and rmap_pde in the future:

	rmap[KVM_NR_PAGE_SIZES]

For this we need to modify some unrelated ppc code, so I just
avoided the integration in this series.

Note: write_count: 4 bytes, rmap_pde: 8 bytes.  So we are wasting
extra paddings by packing them into lpage_info.

> Why not just introduce a function to get the next rmap? Something like this:

I want to eliminate this kind of overheads.

Thanks,
	Takuya

> static unsigned long *get_next_rmap(unsigned long *rmap, int level)
> {
> 	struct kvm_lpage_info *linfo
> 
> 	if (level == 1)
> 		return rmap++
> 	
> 	linfo = container_of(rmap, struct kvm_lpage_info, rmap_pde);
> 	
> 	return &(++linfo)->rmap_pde
> }
> 
> [ Completely untested ]
