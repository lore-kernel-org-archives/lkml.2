Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab0DGHG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:06:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52574
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757160Ab0DGHGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:06:22 -0400
Date: Wed, 07 Apr 2010 00:06:25 -0700 (PDT)
Message-Id: <20100407.000625.203083228.davem@davemloft.net>
To: peterz@infradead.org
Cc: mingo@elte.hu, acme@redhat.com, paulus@samba.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] sparc64: Implement local_irq_save_nmi().
From: David Miller <davem@davemloft.net>
In-Reply-To: <1270623146.5109.532.camel@twins>
References: <20100406.163955.28809295.davem@davemloft.net>
	<1270623146.5109.532.camel@twins>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 07 Apr 2010 08:52:26 +0200

> On Tue, 2010-04-06 at 16:39 -0700, David Miller wrote:
>> @@ -49,6 +49,16 @@ static inline void raw_local_irq_disable(void)
>>  	);
>>  }
>>  
>> +static inline void raw_local_irq_disable_nmi(void)
>> +{
>> +	__asm__ __volatile__(
>> +		"wrpr	%0, %%pil"
>> +		: /* no outputs */
>> +		: "i" (PIL_NMI)
>> +		: "memory"
>> +	);
>> +}
>> +
> 
> Isn't this wrong when used from !NMI context?
> 
> Should this thing do something like:
> 
>   if (rdpr() < PIL_NORMAL_MAX)
>     wrpr(PIL_NORMAL_MAX);
> 
> so that it only disables IRQs, but doesn't enable NMIs.

It's immaterial, local_irq_restore() will do the right thing,
and it's ok to disable NMIs in these few cases I think.

I desperately want to avoid that "test and maybe change the
value %pil value we write" business, and honestly that's
the whole point of this exercise.
