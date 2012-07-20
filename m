Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2GTDBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 23:01:39 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48411 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2GTDBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:01:35 -0400
Message-ID: <5008CA08.6040804@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 11:01:28 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 08/10] KVM: introduce readonly_bad_hva
References: <5005791B.8040807@linux.vnet.ibm.com> <50057A73.40005@linux.vnet.ibm.com> <5007DE72.6030300@redhat.com>
In-Reply-To: <5007DE72.6030300@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072003-5816-0000-0000-000003A93283
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 06:16 PM, Avi Kivity wrote:
> On 07/17/2012 05:45 PM, Xiao Guangrong wrote:
>> In the later patch, it indicates failure when we try to get a writable
>> hva from the readonly slot
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  virt/kvm/kvm_main.c |   12 +++++++++++-
>>  1 files changed, 11 insertions(+), 1 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index b70f1a4..c056736 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -994,9 +994,19 @@ static inline unsigned long bad_hva(void)
>>  	return PAGE_OFFSET;
>>  }
>>
>> +static inline unsigned long readonly_bad_hva(void)
>> +{
>> +	return PAGE_OFFSET + PAGE_SIZE;
>> +}
>> +
>> +static int kvm_is_readonly_bad_hva(unsigned long addr)
>> +{
>> +	return addr == readonly_bad_hva();
>> +}
>> +
>>  int kvm_is_error_hva(unsigned long addr)
>>  {
>> -	return addr == bad_hva();
>> +	return addr == bad_hva() || kvm_is_readonly_bad_hva(addr);
>>  }
> 
> addr >= PAGE_OFFSET.  Or change it to use -E*.

I prefer to the first one, addr >= PAGE_OFFSET, all virtual addresses
between 0 and (~0ULL) are valid, Using PAGE_OFFSET is more readable.

[ is_error_pfn is suitable to use -err because the the range of physical
  address is always limited, for example,  0 ~ 64G on x86.]

