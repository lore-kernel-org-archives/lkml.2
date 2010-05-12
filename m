Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab0ELF77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 01:59:59 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60195 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab0ELF74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 01:59:56 -0400
Message-ID: <4BEA44B8.7050409@oss.ntt.co.jp>
Date: Wed, 12 May 2010 15:03:36 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, avi@redhat.com,
       agraf@suse.de, fernando@oss.ntt.co.jp, kvm@vger.kernel.org,
       kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/12] KVM: introduce new API for getting/switching
 dirty bitmaps
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <20100504220821.d68bde57.takuya.yoshikawa@gmail.com> <20100511034329.GB3458@amt.cnet> <4BE8F0F2.60706@oss.ntt.co.jp> <20100511140712.GA7063@amt.cnet>
In-Reply-To: <20100511140712.GA7063@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> One alternative would be:
>>>
>>> KVM_SWITCH_DIRTY_LOG passing the address of a bitmap. If the active
>>> bitmap was clean, it returns 0, no switch performed. If the active
>>> bitmap was dirty, the kernel switches to the new bitmap and returns 1.
>>>
>>> And the responsability of cleaning the new bitmap could also be left
>>> for userspace.
>>>
>>
>> That is a beautiful approach but we can do that only when we give up using
>> GET api.
>>
>>
>> I follow you and Avi's advice about that kind of maintenance policy!
>> What do you think?
>
> If you introduce a switch ioctl that frees the bitmap vmalloc'ed by the
> current set_memory_region (if its not freed already), after pointing the
> memslot to the user supplied one, it should be fine?
>

You mean switching from vmalloc'ed(not do_mmap'ed) one to user supplied one?

It may be possible but makes things really complicated in my view:
until some point we use set_bit, and then use set_bit_user, etc.

IMO:
  - # of slots is limited and the size of dirty_bitmap_old pointer is not problematic.
  - Both user side and kernel side need not allocate buffers every time and once
    paired buffers are registered, we will reuse the buffers until user side orders
    to stop logging.
  - We have a tiny advantage if we need not copy_from_user to get a bitmap address
    for switch ioctl.

  => So I think having two __user bitmaps is not a bad thing.
