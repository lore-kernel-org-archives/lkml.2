Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0JYLlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:41:46 -0400
Received: from thoth.sbs.de ([192.35.17.2]:24372 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab0JYLlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:41:45 -0400
Message-ID: <4CC56CC6.4020703@siemens.com>
Date: Mon, 25 Oct 2010 13:40:54 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] kvm: write protect memory after slot swap
References: <20101025012124.GA31262@redhat.com> <4CC54EB8.9020604@redhat.com>
In-Reply-To: <4CC54EB8.9020604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.10.2010 11:32, Avi Kivity wrote:
>   On 10/25/2010 03:21 AM, Michael S. Tsirkin wrote:
>> I have observed the following bug trigger:
>>
>> 1. userspace calls GET_DIRTY_LOG
>> 2. kvm_mmu_slot_remove_write_access is called and makes a page ro
>> 3. page fault happens and makes the page writeable
>>     fault is logged in the bitmap appropriately
>> 4. kvm_vm_ioctl_get_dirty_log swaps slot pointers
>>
>> a lot of time passes
>>
>> 5. guest writes into the page
>> 6. userspace calls GET_DIRTY_LOG
>>
>> At point (5), bitmap is clean and page is writeable,
>> thus, guest modification of memory is not logged
>> and GET_DIRTY_LOG returns an empty bitmap.
>>
>> The rule is that all pages are either dirty in the current bitmap,
>> or write-protected, which is violated here.
>>
>> It seems that just moving kvm_mmu_slot_remove_write_access down
>> to after the slot pointer swap should fix this bug.
>>
>> Warning: completely untested.
>> Please comment.
>> Note: fix will be needed for -stable etc.
> 
> Excellent catch, I stared at this code for a while and didn't see the 
> bug.  Patch applied.
> 

BTW, while this was an annoying one for graphic emulation, wasn't it
potentially lethal for live migration?

The issue looks like is was introduced with the switch to SRCU, so every
kernel since 2.6.34 should be affected, correct?

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
