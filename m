Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965430Ab1GOKE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 06:04:58 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53092 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965286Ab1GOKE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:04:56 -0400
Message-ID: <4E20112C.6040307@gmail.com>
Date: Fri, 15 Jul 2011 18:06:36 +0800
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: benh@kernel.crashing.org, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, dhowells@redhat.com, cmetcalf@tilera.com,
        tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>	 <1310718056.2586.275.camel@twins>  <4E1FFC7B.4000209@gmail.com>	 <1310719445.2586.288.camel@twins>  <4E20037C.5070506@gmail.com> <1310723441.2586.291.camel@twins>
In-Reply-To: <1310723441.2586.291.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 05:50 PM, Peter Zijlstra wrote:
> On Fri, 2011-07-15 at 17:08 +0800, Shan Hai wrote:
>> The whole scenario should be,
>> - the child process triggers a page fault at the first time access to
>>       the lock, and it got its own writable page, but its *clean* for
>>       the reason just for checking the status of the lock.
>>       I am sorry for above "unbreakable COW".
>> - the futex_lock_pi() is invoked because of the lock contention,
>>       and the futex_atomic_cmpxchg_inatomic() tries to get the lock,
>>       it found out the lock is free so tries to write to the lock for
>>       reservation, a page fault occurs, because the page is read only
>>       for kernel(e500 specific), and returns -EFAULT to the caller
>> - the fault_in_user_writeable() tries to fix the fault,
>>       but from the get_user_pages() view everything is ok, because
>>       the COW was already broken, retry futex_lock_pi_atomic()
> but that's a bug right there, gup(.write=1) _should_ be a complete write
> fault, and as such toggle your sw dirty/young tracking.
>

The fault causing futex_atomic_cmpxchg_inatomic() is
protected by pagefault_disable(), so the page fault handler has
no chance to toggle the SW dirty/young tracking.

Thanks
Shan Hai

>> - futex_lock_pi_atomic() -->  futex_atomic_cmpxchg_inatomic(),
>>       another write protection page fault
>> - infinite loop

