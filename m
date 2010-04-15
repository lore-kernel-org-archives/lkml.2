Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0DOKky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:40:54 -0400
Received: from 8bytes.org ([88.198.83.132]:57481 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab0DOKkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:40:52 -0400
Date: Thu, 15 Apr 2010 12:40:51 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os
	statistics from host side
Message-ID: <20100415104051.GC12697@8bytes.org>
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <4BC588CF.5010507@redhat.com> <1902445479.2078.458.camel@ymzhang.sh.intel.com> <4BC6C8CD.1020801@redhat.com> <1902473858.2078.481.camel@ymzhang.sh.intel.com> <20100415090403.GA12697@8bytes.org> <4BC6D7C8.9060302@redhat.com> <20100415094407.GB12697@8bytes.org> <4BC6E0D9.1090202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC6E0D9.1090202@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 12:48:09PM +0300, Avi Kivity wrote:
> On 04/15/2010 12:44 PM, oerg Roedel wrote:
>>
>>> So, we'd need something like the following:
>>>
>>>     if (exit == NMI)
>>>         __get_cpu_var(nmi_vcpu) = vcpu;
>>>
>>>     stgi();
>>>
>>>     if (exit == NMI) {
>>>         while (!nmi_handled())
>>>             cpu_relax();
>>>         __get_cpu_var(nmi_vcpu) = NULL;
>>>     }
>>>      
>> Hmm, looks a bit complicated to me. The NMI should happen shortly after
>> the stgi instruction. Interrupts are still disabled so we stay on this
>> cpu. Can't we just set and erase the cpu_var at vcpu_load/vcpu_put time?
>>
>>    
>
> That means an NMI that happens outside guest code (for example, in the  
> mmu, or during the exit itself) would be counted as if in guest code.

Hmm, true. The same is true for an NMI that happens between VMSAVE and
STGI but that window is smaller. Anyway, I think we don't need the
busy-wait loop. The NMI should be executed at a well defined point and
we set the cpu_var back to NULL after that point.

	Joerg

