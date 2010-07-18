Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab0GRPOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 11:14:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab0GRPOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 11:14:19 -0400
Message-ID: <4C431A43.5010808@redhat.com>
Date: Sun, 18 Jul 2010 18:14:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 5/6] kvm, x86: use ro page and don't copy shared page
References: <4C3FC033.3000605@cn.fujitsu.com> <20100716071936.GE17894@redhat.com> <20100716232612.GB8946@amt.cnet> <20100717043124.GA24480@redhat.com>
In-Reply-To: <20100717043124.GA24480@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2010 07:31 AM, Gleb Natapov wrote:
>>>
>>> Currently pages allocated for guest memory are required to be RW, so after your series
>>> behaviour will remain exactly the same as before.
>>>        
>> Except KSM pages.
>>
>>      
> KSM page will be COWed by __get_user_pages_fast(addr, 1, 1, page) in
> get_user_page_and_protection() just like it COWed now, no?
>    

Well, we don't want to COW it on write faults.

The optimal behaviour is:

- write faults: COW and instantiate a writeable spte
- read faults: instantiate a readable spte; if likely(page is 
writeable), make it a writeable spte; if likely(page is dirty) make it a 
dirty spte
- speculative spte instantiations: if likely(page is present) 
instantiate a pte; if accessed, mark it accessed, if writeable, mark it 
writeable; if dirty, mark it dirty

-- 
error compiling committee.c: too many arguments to function

