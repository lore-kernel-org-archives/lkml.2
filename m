Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1CCHC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:02:59 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40093 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1CCHC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:02:57 -0500
X-AuditID: b753bd60-a3b4cba0000001d0-c1-4d6f3d1e09f3
X-AuditID: b753bd60-a3b4cba0000001d0-c1-4d6f3d1e09f3
Message-ID: <4D6F3D1B.3030005@hitachi.com>
Date: Thu, 03 Mar 2011 16:02:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.14) Gecko/20110221 Thunderbird/3.1.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: stop machine text poke should issue sync core
References: <20110228152405.GA7064@Krystal> <4D6F30DA.2070907@zytor.com>
In-Reply-To: <4D6F30DA.2070907@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/03 15:10), H. Peter Anvin wrote:
> On 02/28/2011 07:24 AM, Mathieu Desnoyers wrote:
>>
>> Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
>> ===================================================================
>> --- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c
>> +++ linux-2.6-lttng/arch/x86/kernel/alternative.c
>> @@ -612,6 +612,12 @@ static int __kprobes stop_machine_text_p
>>  
>>  	flush_icache_range((unsigned long)tpp->addr,
>>  			   (unsigned long)tpp->addr + tpp->len);
>> +	/*
>> +	 * Intel Archiecture Software Developer's Manual section 7.1.3 specifies
>> +	 * that a core serializing instruction such as "cpuid" should be
>> +	 * executed on _each_ core before the new instruction is made visible.
>> +	 */
>> +	sync_core();
>>  	return 0;
>>  }
>>  
> 
> Isn't this executed from an IPI handler, which will return with IRET (a
> serializing instruction) anyway?

No, now stop_machine uses per-cpu workqueue, so that handler will be
executed from worker threads. There is no iret anymore.

BTW, Mathieu, since the latest kernel has batch-text_poke_smp, this patch
needs to be updated.

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
