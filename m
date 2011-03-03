Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1CCGLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:11:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53462 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab1CCGLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:11:40 -0500
Message-ID: <4D6F30DA.2070907@zytor.com>
Date: Wed, 02 Mar 2011 22:10:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: stop machine text poke should issue sync core
References: <20110228152405.GA7064@Krystal>
In-Reply-To: <20110228152405.GA7064@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2011 07:24 AM, Mathieu Desnoyers wrote:
> 
> Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c
> +++ linux-2.6-lttng/arch/x86/kernel/alternative.c
> @@ -612,6 +612,12 @@ static int __kprobes stop_machine_text_p
>  
>  	flush_icache_range((unsigned long)tpp->addr,
>  			   (unsigned long)tpp->addr + tpp->len);
> +	/*
> +	 * Intel Archiecture Software Developer's Manual section 7.1.3 specifies
> +	 * that a core serializing instruction such as "cpuid" should be
> +	 * executed on _each_ core before the new instruction is made visible.
> +	 */
> +	sync_core();
>  	return 0;
>  }
>  

Isn't this executed from an IPI handler, which will return with IRET (a
serializing instruction) anyway?

	-hpa
