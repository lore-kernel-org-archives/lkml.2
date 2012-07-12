Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab2GLIem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:34:42 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:33770 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab2GLIei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:34:38 -0400
Message-ID: <4FFE8BA1.8000507@linux.vnet.ibm.com>
Date: Thu, 12 Jul 2012 14:02:33 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
References: <20120709062012.24030.37154.sendpatchset@codeblue> <4FFA8E5E.3070108@de.ibm.com> <4FFD422B.9060008@redhat.com> <4FFD52CD.7040403@de.ibm.com> <4FFD5DA3.3010001@redhat.com> <4FFD6100.8050202@de.ibm.com> <4FFD65E0.500@redhat.com> <4FFE5C9C.9070001@linux.vnet.ibm.com> <4FFE86A4.2010809@redhat.com>
In-Reply-To: <4FFE86A4.2010809@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071122-1396-0000-0000-0000018C5C65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 01:41 PM, Avi Kivity wrote:
> On 07/12/2012 08:11 AM, Raghavendra K T wrote:
>>> Ah, I thouht you objected to the CONFIG var.  Maybe call it
>>> cpu_relax_intercepted since that's the linuxy name for the instruction.
>>>
>>
>> Ok, just to be on same page. 'll have :
>> 1. cpu_relax_intercepted instead of  pause_loop_exited.
>>
>> 2. CONFIG_KVM_HAVE_CPU_RELAX_INTERCEPT which is unconditionally
>> selected for x86 and s390
>>
>> 3. make request mechanism to clear cpu_relax_intercepted.
>>
>> ('ll do same thing for s390 also but have not seen s390 code using
>> request mechanism, so not sure if it ok.. otherwise we have to clear
>> unconditionally for s390 before guest enter and for x86 we have to move
>> make_request back to vmx/svm).
>> will post V3 with these changes.
>
> You can leave the s390 changes to the s390 people; just make sure the
> generic code is ready.
>
Yep,
Checked the following logic with make_request and it works fine,

vcpu_spin()
{
  ple_exited = true;
.
.
make_request(KVM_REQ_CLEAR_PLE, vcpu);
}

vcpu_enter_guest()
{
  if(check_request(KVM_REQ_CLEAR_PLE))
     ple_exited = false;
.
.
}

But there is following approach that is working perfectly fine.
vcpu_spin()
{
  ple_exited = true;
.
.

  ple_exited = false;
}

I hope to go with second approach. let me know if you find any loop
hole.

