Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab0KOTii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:38:38 -0500
Received: from claw.goop.org ([74.207.240.146]:56038 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab0KOTih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:38:37 -0500
Message-ID: <4CE18C39.4050206@goop.org>
Date: Mon, 15 Nov 2010 11:38:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 03/20] x86/ticketlock: Use C for __ticket_spin_unlock
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com> <20092775a9df07a5a75820ac250194b535279d51.1288794124.git.jeremy.fitzhardinge@citrix.com> <20101113100527.GG3837@hack>
In-Reply-To: <20101113100527.GG3837@hack>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2010 02:05 AM, Américo Wang wrote:
> On Wed, Nov 03, 2010 at 10:59:44AM -0400, Jeremy Fitzhardinge wrote:
>>  * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
>>  * (PPro errata 66, 92)
>>  */
>> -# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
>> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>> +{
>> +	if (sizeof(lock->tickets.head) == sizeof(u8))
>> +		asm (LOCK_PREFIX "incb %0"
>> +		     : "+m" (lock->tickets.head) : : "memory");
>> +	else
>> +		asm (LOCK_PREFIX "incw %0"
>> +		     : "+m" (lock->tickets.head) : : "memory");
> This 'if/else' really should be done with #ifdef, even though
> the compiler may be smart enough to remove it.

No, we depend on if/else with constant arguments doing the right thing
all over the kernel.  It is always preferable to use it instead of
#ifdef where possible, so that the two branches of code are always
subjected to compiler checking, even if they're not being used.

>> +
>> +}
>> #else
>> -# define UNLOCK_LOCK_PREFIX
>> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>> +{
>> +	barrier();
>> +	lock->tickets.head++;
>> +	barrier();
> The second barrier() is not needed.

Agreed.  It gets removed in a later patch.

    J
