Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab0DOJJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 05:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181Ab0DOJJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:09:51 -0400
Message-ID: <4BC6D7C8.9060302@redhat.com>
Date: Thu, 15 Apr 2010 12:09:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: oerg Roedel <joro@8bytes.org>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os	statistics
 from host side
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <4BC588CF.5010507@redhat.com> <1902445479.2078.458.camel@ymzhang.sh.intel.com> <4BC6C8CD.1020801@redhat.com> <1902473858.2078.481.camel@ymzhang.sh.intel.com> <20100415090403.GA12697@8bytes.org>
In-Reply-To: <20100415090403.GA12697@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 12:04 PM, oerg Roedel wrote:
> On Mon, Apr 15, 2030 at 04:57:38PM +0800, Zhang, Yanmin wrote:
>
>    
>> I checked svm.c and it seems svm.c doesn't trigger a NMI to host if the NMI
>> happens in guest os. In addition, svm_complete_interrupts is called after
>> interrupt is enabled.
>>      
> Yes. The NMI is held pending by the hardware until the STGI instruction
> is executed.
> And for nested svm the svm_complete_interrupts function needs to be
> executed after the nested exit handling. Therefore it is done late on
> svm.
>    

So, we'd need something like the following:

    if (exit == NMI)
        __get_cpu_var(nmi_vcpu) = vcpu;

    stgi();

    if (exit == NMI) {
        while (!nmi_handled())
            cpu_relax();
        __get_cpu_var(nmi_vcpu) = NULL;
    }

and no code sharing betweem vmx and svm.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

