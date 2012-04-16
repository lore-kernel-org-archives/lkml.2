Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab2DPD0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:26:31 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:43103 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2DPD0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:26:30 -0400
Message-ID: <4F8B915B.9080407@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 11:26:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 03/16] KVM: MMU: properly assert spte on rmap walking
 path
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FBA5.3060203@linux.vnet.ibm.com> <20120414111544.b3a4b9273fe84ddc33cb7e1c@gmail.com>
In-Reply-To: <20120414111544.b3a4b9273fe84ddc33cb7e1c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041603-3864-0000-0000-0000024704C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2012 10:15 AM, Takuya Yoshikawa wrote:

> On Fri, 13 Apr 2012 18:10:45 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>>  static u64 *rmap_get_next(struct rmap_iterator *iter)
>>  {
>> +	u64 *sptep = NULL;
>> +
>>  	if (iter->desc) {
>>  		if (iter->pos < PTE_LIST_EXT - 1) {
>> -			u64 *sptep;
>> -
>>  			++iter->pos;
>>  			sptep = iter->desc->sptes[iter->pos];
>>  			if (sptep)
>> -				return sptep;
>> +				goto exit;
>>  		}
>>
>>  		iter->desc = iter->desc->more;
>> @@ -1028,11 +1036,14 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
>>  		if (iter->desc) {
>>  			iter->pos = 0;
>>  			/* desc->sptes[0] cannot be NULL */
>> -			return iter->desc->sptes[iter->pos];
>> +			sptep = iter->desc->sptes[iter->pos];
>> +			goto exit;
>>  		}
>>  	}
>>
>> -	return NULL;
>> +exit:
>> +	WARN_ON(sptep && !is_shadow_present_pte(*sptep));
>> +	return sptep;
>>  }
> 
> This will, probably, again force rmap_get_next function-call even with EPT/NPT:
> CPU cannot skip it by branch prediction.
> 

No, EPT/NPT also needs it.

