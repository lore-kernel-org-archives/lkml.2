Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab0DOJoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 05:44:10 -0400
Received: from 8bytes.org ([88.198.83.132]:54978 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757666Ab0DOJoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:44:09 -0400
Date: Thu, 15 Apr 2010 11:44:07 +0200
From: oerg Roedel <joro@8bytes.org>
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
Message-ID: <20100415094407.GB12697@8bytes.org>
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <4BC588CF.5010507@redhat.com> <1902445479.2078.458.camel@ymzhang.sh.intel.com> <4BC6C8CD.1020801@redhat.com> <1902473858.2078.481.camel@ymzhang.sh.intel.com> <20100415090403.GA12697@8bytes.org> <4BC6D7C8.9060302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC6D7C8.9060302@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 12:09:28PM +0300, Avi Kivity wrote:
> On 04/15/2010 12:04 PM, oerg Roedel wrote:
>> On Mon, Apr 15, 2030 at 04:57:38PM +0800, Zhang, Yanmin wrote:
>>
>>    
>>> I checked svm.c and it seems svm.c doesn't trigger a NMI to host if the NMI
>>> happens in guest os. In addition, svm_complete_interrupts is called after
>>> interrupt is enabled.
>>>      
>> Yes. The NMI is held pending by the hardware until the STGI instruction
>> is executed.
>> And for nested svm the svm_complete_interrupts function needs to be
>> executed after the nested exit handling. Therefore it is done late on
>> svm.
>>    
>
> So, we'd need something like the following:
>
>    if (exit == NMI)
>        __get_cpu_var(nmi_vcpu) = vcpu;
>
>    stgi();
>
>    if (exit == NMI) {
>        while (!nmi_handled())
>            cpu_relax();
>        __get_cpu_var(nmi_vcpu) = NULL;
>    }

Hmm, looks a bit complicated to me. The NMI should happen shortly after
the stgi instruction. Interrupts are still disabled so we stay on this
cpu. Can't we just set and erase the cpu_var at vcpu_load/vcpu_put time?

	Joerg

