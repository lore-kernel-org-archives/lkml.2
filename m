Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab2DIN7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:59:34 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:45344 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab2DIN7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:59:32 -0400
Message-ID: <4F82EB3B.8000204@linux.vnet.ibm.com>
Date: Mon, 09 Apr 2012 21:59:23 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F7436FB.9000004@redhat.com> <4F744A43.4060600@linux.vnet.ibm.com> <4F745C4F.4060404@redhat.com> <4F757A7C.6020109@linux.vnet.ibm.com> <4F7850EA.3080203@redhat.com> <4F7E1531.5020307@gmail.com> <4F7E7E1A.3000807@linux.vnet.ibm.com> <4F82E228.7050602@redhat.com>
In-Reply-To: <4F82E228.7050602@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12040913-8256-0000-0000-000001F03587
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 09:20 PM, Avi Kivity wrote:

> On 04/06/2012 08:24 AM, Xiao Guangrong wrote:
>>
>> Foolish me, i should be crazy. Sorry for my mistake. :(
>>
>> Unfortunately, it can not work, we can not get a stable gfn from gpte or
>> sp->gfns[]. For example:
>>
>> beginning:
>> Gpte = Gfn1
>> gfn_to_pfn(Gfn1) = Pfn
>> Spte = Pfn
>> Gfn1 is write-free
>> Gfn2 is write-protected
>>
>>
>> VCPU 0                              VCPU 1                     VCPU 2
>>
>> fault on gpte
>> fast page fault path:
>>   set Spte.fast_pf
>>   get Gfn1 from Gpte/sp->gfns[]
>>   if (Gfn1 is writable)
>>                                 Pfn is swapped out:
>> 					Spte = 0
>> 				Gpte is modified to Gfn2,
>>                                 and Pfn is realloced and remapped
>>                                 to Gfn2, so:
>>                                         Spte = Pfn
>>
>>                                                           fast page fault path:
>>                                                              set Spte.fast_pf
>>
>>          cmpxchg  Spte+w
>>             OOPS!!!
>>   <we see Spte is not changed and
>>    happily make it writable, so gfn2 can be writable>
>>
>> It seems only a unique identification can prevent this. :(
>>
> 
> Ouch.
> 
> What about restricting this to role.direct=1?  Then gfn is stable?
> 


Yes.

The gfn of direct sp is stable since it is calculated by sp->gfn which is
independent with gpte.

