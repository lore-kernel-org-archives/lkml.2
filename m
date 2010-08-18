Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0HRBZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:25:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56369 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab0HRBZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:25:30 -0400
X-Authority-Analysis: v=1.1 cv=yHIl1GXhF427//PKRp6qBSoAWm+VmAP8iV7xFCEBb5c= c=1 sm=0 a=ALrJC2IdMPkA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=i18r_AFR3jBX9JLy4NgA:9 a=ipGkerq4dnN-K2_y4ooA:7 a=NvuQDNWi4GuRzrH0ajU5NBtSbbwA:4 a=PUjeQqilurYA:10 a=2Spnn5INwWhIUN8G:21 a=CRK-b5zTMFaqm9X1:21 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [RFC PATCH 01/20] Create generic alignment API (v8)
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Shishkin <virtuoso@slind.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Imre Deak <imre.deak@nokia.com>,
        Jamie Lokier <jamie@shareable.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20100817232150.251244768@efficios.com>
References: <20100817231619.277457797@efficios.com>
	 <20100817232150.251244768@efficios.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 Aug 2010 21:25:26 -0400
Message-ID: <1282094726.3268.2197.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 19:16 -0400, Mathieu Desnoyers wrote:

> +/*
> + * Align pointer on natural object alignment. Object size must be power of two.
> + */

Hmm, I wonder if we should add a compiler bug here too.

extern void __bug_obj_not_power_of_two(void);

({
	if ((sizeof(*obj) - 1) & sizeof(*obj))
		__bug_obj_not_power_of_two();
	PTR_ALIGN((obj), __alignof__(*(obj)));
})

> +#define object_align(obj)	PTR_ALIGN((obj), __alignof__(*(obj)))
> +#define object_align_floor(obj)	PTR_ALIGN_FLOOR((obj), __alignof__(*(obj)))
> +
> +/**
> + * offset_align - Calculate the offset needed to align an object on its natural
> + *                alignment towards higher addresses.
> + * @align_drift:  object offset from an "alignment"-aligned address.
> + * @alignment:    natural object alignment. Must be non-zero, power of 2.
> + *
> + * Returns the offset that must be added to align towards higher
> + * addresses.
> + */
> +static inline size_t offset_align(size_t align_drift, size_t alignment)
> +{
> +	return (alignment - align_drift) & (alignment - 1);
> +}
> +
> +/**
> + * offset_align_floor - Calculate the offset needed to align an object
> + *                      on its natural alignment towards lower addresses.
> + * @align_drift:  object offset from an "alignment"-aligned address.
> + * @alignment:    natural object alignment. Must be non-zero, power of 2.
> + *
> + * Returns the offset that must be substracted to align towards lower addresses.
> + */
> +static inline size_t offset_align_floor(size_t align_drift, size_t alignment)
> +{
> +	return (align_drift - alignment) & (alignment - 1);
> +}

I take it that theses functions can have variables passed to it for
alignment, thus a check wont help. Although, we could add a test for the
constant case.

-- Steve

> +


