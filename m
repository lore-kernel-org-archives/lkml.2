Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab0KOTg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:36:59 -0500
Received: from claw.goop.org ([74.207.240.146]:56021 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360Ab0KOTg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:36:58 -0500
Message-ID: <4CE18BD6.40809@goop.org>
Date: Mon, 15 Nov 2010 11:36:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 01/20] x86/ticketlock: clean up types and accessors
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com> <742be99eb6d64784dbc3e446d22df78b7a55fc0c.1288794124.git.jeremy.fitzhardinge@citrix.com> <20101113095732.GF3837@hack>
In-Reply-To: <20101113095732.GF3837@hack>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2010 01:57 AM, Américo Wang wrote:
> On Wed, Nov 03, 2010 at 10:59:42AM -0400, Jeremy Fitzhardinge wrote:
> ...
>> static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>> {
>> -	int inc = 0x00010000;
>> -	int tmp;
>> +	unsigned inc = 1 << TICKET_SHIFT;
>> +	unsigned tmp;
> Please don't use old implicit-int.

I don't mind much either way, but I don't think I've seen anyone worry
about this before.

>> -	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
>> +	return ((tmp.tail - tmp.head) & TICKET_MASK) > 1;
>
> There is a type promotion here.

...

>> }
>>
>> #ifndef CONFIG_PARAVIRT_SPINLOCKS
>> diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
>> index dcb48b2..4582640 100644
>> --- a/arch/x86/include/asm/spinlock_types.h
>> +++ b/arch/x86/include/asm/spinlock_types.h
>> @@ -5,11 +5,27 @@
>> # error "please don't include this file directly"
>> #endif
>>
>> +#include <linux/types.h>
>> +
>> +#if (CONFIG_NR_CPUS < 256)
>> +typedef u8  __ticket_t;
>> +#else
>> +typedef u16 __ticket_t;
>> +#endif
>> +
>> +#define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
>> +#define TICKET_MASK	((1 << TICKET_SHIFT) - 1)
>
> So here you may need to cast the result to __ticket_t.

OK.

    J
