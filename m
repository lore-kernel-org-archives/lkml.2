Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0CQJmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:42:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab0CQJmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:42:36 -0400
Message-ID: <4BA0A3E6.4040100@redhat.com>
Date: Wed, 17 Mar 2010 11:41:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       "Huang, Zhiteng" <zhiteng.huang@intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <1268717232.2813.36.camel@localhost> <4B9F5021.3080206@redhat.com> <1268793273.2813.70.camel@localhost> <201003171728.43739.sheng@linux.intel.com>
In-Reply-To: <201003171728.43739.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 11:28 AM, Sheng Yang wrote:
>
>> I'm not sure if vmexit does break NMI context or not. Hardware NMI context
>> isn't reentrant till a IRET. YangSheng would like to double check it.
>>      
> After more check, I think VMX won't remained NMI block state for host. That's
> means, if NMI happened and processor is in VMX non-root mode, it would only
> result in VMExit, with a reason indicate that it's due to NMI happened, but no
> more state change in the host.
>
> So in that meaning, there _is_ a window between VMExit and KVM handle the NMI.
> Moreover, I think we _can't_ stop the re-entrance of NMI handling code because
> "int $2" don't have effect to block following NMI.
>    

That's pretty bad, as NMI runs on a separate stack (via IST).  So if 
another NMI happens while our int $2 is running, the stack will be 
corrupted.

> And if the NMI sequence is not important(I think so), then we need to generate
> a real NMI in current vmexit-after code. Seems let APIC send a NMI IPI to
> itself is a good idea.
>
> I am debugging a patch based on apic->send_IPI_self(NMI_VECTOR) to replace
> "int $2". Something unexpected is happening...
>    

I think you need DM_NMI for that to work correctly.

An alternative is to call the NMI handler directly.

-- 
error compiling committee.c: too many arguments to function

