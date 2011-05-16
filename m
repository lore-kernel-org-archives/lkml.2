Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1EPU4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:56:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48285 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab1EPU4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:56:01 -0400
Message-ID: <4DD18F4A.5030208@kernel.org>
Date: Mon, 16 May 2011 13:55:38 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource allocation.
References: <20110509142014.617e3100@jbarnes-desktop> <BANLkTi=U0LSj45y+5+n+7R=Cj4uRqk-LQw@mail.gmail.com> <4DC9E415.5010402@kernel.org> <20110512180638.GA5012@ram-laptop> <BANLkTikGG6F22+JEtueF8c5xjX9bBPp+0A@mail.gmail.com> <20110512182229.GQ8195@ram-laptop> <20110512113726.123fd85b@jbarnes-desktop> <BANLkTikt_oWhYHZwVMnrxvow4j+zkPuFCQ@mail.gmail.com> <20110512123412.64e9b4cc@jbarnes-desktop> <4DCDD589.8010309@kernel.org> <20110516075926.GW8195@ram-laptop>
In-Reply-To: <20110516075926.GW8195@ram-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DD18F53.0141,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2011 12:59 AM, Ram Pai wrote:
> On Fri, May 13, 2011 at 06:06:17PM -0700, Yinghai Lu wrote:
>> On 05/12/2011 12:34 PM, Jesse Barnes wrote:
>>> On Thu, 12 May 2011 12:18:43 -0700
>>> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>
>>>> On Thu, May 12, 2011 at 11:37 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>>>>
>>>>> Linus, I don't have anything else queued up, so you may as well take
>>>>> this one directly if you want it in 2.6.39.  It's a regression fix, but
>>>>> resource changes always make me nervous.  Alternately, I could put it
>>>>> into 2.6.40 instead, the backport to 2.6.39.x if it survives until
>>>>> 2.6.40-rc2 or so...
>>>>
>>>> Considering the trouble resource allocation always ends up being, I'd
>>>> almost prefer that "mark it for stable and put it in the 2.6.40
>>>> queue".
>>>>
>>>> Afaik this problem hasn't actually hit any "normal" users, has it? So ...
>>>
>>> Sounds good, thanks.  Yeah I don't think it's hit anyone but Yinghai
>>> (at least I don't know of any other reports).
>>>
>>
>> please check this one, it should be safe for 2.6.39 ?
> 
>>  	size0 = calculate_iosize(size, min_size, size1,
>>  			resource_size(b_res), 4096);
>> -	size1 = !add_size? size0:
>> +	size1 = (!add_head || (add_head && !add_size)) ? size0 :
>>  		calculate_iosize(size, min_size+add_size, size1,
>>  			resource_size(b_res), 4096);
> 
> This solves the problem you encountered.
> 
> But, I think, it still does not fix the following scenario:
> 
> adjust_resource() failing to allocate additional resource to a hotplug bridge
> that has no children. In this case  ->flags of that 'struct resource'
> continues to be set even when no resource is allocated to that hot-plug bridge.
> 
that case: requested_size will be 0, but add_size will not be zero.

res->flags is not cleared in pbus_size_xx, so it will be put into head.
so it will go through first path.
...
                if (!resource_size(res) && add_size) {
                         res->end = res->start + add_size - 1;
                         if(pci_assign_resource(list->dev, idx))
                                reset_resource(res);
                } else if (add_size) {
                        adjust_resource(res, res->start,
                                resource_size(res) + add_size);
                }

and if it fails to get assign, the flags will get clear in reset_resource.

so it should be ok. and testing in one my setup show those flags get clear correctly and does not emit any warning.

Thanks

Yinghai
