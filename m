Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab0GAAys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:54:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65335 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab0GAAyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:54:47 -0400
Message-ID: <4C2BE672.7030703@cn.fujitsu.com>
Date: Thu, 01 Jul 2010 08:50:58 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 3/11] KVM: MMU: fix direct sp's access corruptted
References: <4C2AF9FA.9020601@cn.fujitsu.com> <4C2AFA50.1070502@cn.fujitsu.com> <20100630193929.GA4817@amt.cnet>
In-Reply-To: <20100630193929.GA4817@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:

>> -		if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
>> -			continue;
>> +		if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
>> +			struct kvm_mmu_page *child;
>> +			unsigned direct_access;
>> +
>> +			if (level != gw->level)
>> +				continue;
> 
> This will skip the check for the sp at level 1 when emulating 1GB pages
> with 4k host pages (where there are direct sp's at level 2 and 1).
> Should be > instead of !=.
> 

Marcelo,

I think the patch is right.

Every level's direct sp has the same access in the mapping since while we setup the
mapping we find the direct sp with the same access.
(Note: we have encode the D bit to the sp->role.access)

Consider guest 1G writable clean pages and host 4K pages, the shadow pages mapping
is like this:

indirect L4 --> indirect L3 --> direct ReadOnly L2 --> direct ReadOnly L1

When change guest pte to dirty, we update L3' spte and find the direct writable L2 sp,
assume it's A, then we can sure that A's children sps should also writable, the final
mapping is like this:

indirect L4 --> indirect L3 --> direct Writable L2 --> direct Writable L1.

So, i think we not broken anything in this patch :-)






 
