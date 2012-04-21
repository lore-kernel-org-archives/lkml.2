Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab2DUEpW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 00:45:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab2DUEpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 00:45:19 -0400
Date: Sat, 21 Apr 2012 01:18:54 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/9] KVM: MMU: abstract spte write-protect
Message-ID: <20120421041854.GA2763@amt.cnet>
References: <4F911B74.4040305@linux.vnet.ibm.com>
 <4F911BAB.6000206@linux.vnet.ibm.com>
 <20120420213319.GA13817@amt.cnet>
 <4F922886.5060807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F922886.5060807@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 11:24:54AM +0800, Xiao Guangrong wrote:
> On 04/21/2012 05:33 AM, Marcelo Tosatti wrote:
> 
> 
> >>  static bool
> >>  __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
> >>  {
> >> @@ -1050,24 +1078,13 @@ __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
> >>
> >>  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
> >>  		BUG_ON(!(*sptep & PT_PRESENT_MASK));
> >> -		rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
> >> -
> >> -		if (!is_writable_pte(*sptep)) {
> >> -			sptep = rmap_get_next(&iter);
> >> -			continue;
> >> -		}
> >> -
> >> -		if (level == PT_PAGE_TABLE_LEVEL) {
> >> -			mmu_spte_update(sptep, *sptep & ~PT_WRITABLE_MASK);
> >> -			sptep = rmap_get_next(&iter);
> >> -		} else {
> >> -			BUG_ON(!is_large_pte(*sptep));
> >> -			drop_spte(kvm, sptep);
> >> -			--kvm->stat.lpages;
> > 
> > It is preferable to remove all large sptes including read-only ones, the
> 
> 
> It can cause page faults even if read memory on these large sptse.
> 
> Actually, Avi suggested that make large writable spte to be readonly
> (not dropped) on this path.

See commits e49146dce8c3dc6f4485c1904b6587855f393e71,
38187c830cab84daecb41169948467f1f19317e3 for issues
with large read-only sptes.

> > current behaviour, then to verify that no read->write transition can
> > occur in fault paths (fault paths which are increasing in number).
> 
> 
> Yes, the small spte also has issue (find a write-protected spte in
> fault paths). Later, the second part of this patchset will introduce
> rmap.WRITE_PROTECTED bit, then we can do the fast check before calling
> fast page fault.
