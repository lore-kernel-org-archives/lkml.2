Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0GAMIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:08:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab0GAMIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:08:19 -0400
Date: Thu, 1 Jul 2010 09:03:15 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 3/11] KVM: MMU: fix direct sp's access corruptted
Message-ID: <20100701120315.GA18607@amt.cnet>
References: <4C2AF9FA.9020601@cn.fujitsu.com>
 <4C2AFA50.1070502@cn.fujitsu.com>
 <20100630193929.GA4817@amt.cnet>
 <4C2BE672.7030703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2BE672.7030703@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 08:50:58AM +0800, Xiao Guangrong wrote:
> 
> 
> Marcelo Tosatti wrote:
> 
> >> -		if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
> >> -			continue;
> >> +		if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
> >> +			struct kvm_mmu_page *child;
> >> +			unsigned direct_access;
> >> +
> >> +			if (level != gw->level)
> >> +				continue;
> > 
> > This will skip the check for the sp at level 1 when emulating 1GB pages
> > with 4k host pages (where there are direct sp's at level 2 and 1).
> > Should be > instead of !=.
> > 
> 
> Marcelo,
> 
> I think the patch is right.
> 
> Every level's direct sp has the same access in the mapping since while we setup the
> mapping we find the direct sp with the same access.
> (Note: we have encode the D bit to the sp->role.access)
> 
> Consider guest 1G writable clean pages and host 4K pages, the shadow pages mapping
> is like this:
> 
> indirect L4 --> indirect L3 --> direct ReadOnly L2 --> direct ReadOnly L1
> 
> When change guest pte to dirty, we update L3' spte and find the direct writable L2 sp,
> assume it's A, then we can sure that A's children sps should also writable, the final
> mapping is like this:
> 
> indirect L4 --> indirect L3 --> direct Writable L2 --> direct Writable L1.
> 
> So, i think we not broken anything in this patch :-)

You're right. Applied.
