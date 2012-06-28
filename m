Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab2F1Czd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:55:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15985 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2F1Czc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:55:32 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=EvKSwpK77UAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VHRhf7ZKJIMguAfPpN4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340852129.16702.73.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Steven Rostedt <rostedt@goodmis.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Wed, 27 Jun 2012 22:55:29 -0400
In-Reply-To: <1340869133.876.10.camel@mop>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com>
	 <20120625150722.8cd4f45d.akpm@linux-foundation.org>
	 <20120625235531.GB3652@kroah.com>
	 <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
	 <20120626002307.GA4389@kroah.com>
	 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
	 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
	 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
	 <1340726856.977.6.camel@mop>
	 <1340810038.16702.16.camel@gandalf.stny.rr.com>
	 <1340810283.16702.19.camel@gandalf.stny.rr.com>
	 <CAPXgP121+zA_p4x9VdSMWtu-SqqqiNC51CKkYKY4YkAL+QsQ4g@mail.gmail.com>
	 <1340869133.876.10.camel@mop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 09:38 +0200, Kay Sievers wrote:

> +static void cont_flush(void)
> +{
> +	if (cont.flushed)
> +		return;
> +	if (cont.len == 0)
> +		return;
> +
> +	log_store(cont.facility, cont.level, LOG_NOCONS, cont.ts_nsec,
> +		  NULL, 0, cont.buf, cont.len);
> +
> +	cont.flushed = true;
> +}
> +
> +static bool cont_add(int facility, int level, const char *text, size_t len)
> +{
> +	if (cont.len && cont.flushed)
> +		return false;
> +
> +	if (cont.len + len > sizeof(cont.buf)) {
> +		cont_flush();
> +		return false;
> +	}
> +
> +	if (!cont.len) {
> +		cont.facility = facility;
> +		cont.level = level;
> +		cont.owner = current;
> +		cont.ts_nsec = local_clock();
> +		cont.cons = 0;
> +		cont.flushed = false;
> +	}
> +
> +	memcpy(cont.buf + cont.len, text, len);
> +	cont.len += len;
> +	return true;
> +}
> +
> +static size_t cont_print_text(char *text, size_t size)
> +{
> +	size_t textlen = 0;
> +	size_t len;
> +
> +	if (cont.cons == 0) {
> +		textlen += print_time(cont.ts_nsec, text);
> +		size -= textlen;
> +	}
> +
> +	len = cont.len - cont.cons;
> +	if (len > 0) {
> +		if (len+1 > size)
> +			len = size-1;
> +		memcpy(text + textlen, cont.buf + cont.cons, len);
> +		textlen += len;
> +		cont.cons = cont.len;
> +	}
> +
> +	if (cont.flushed) {
> +		text[textlen++] = '\n';
> +		/* got everything, release buffer */
> +		cont.len = 0;
> +	}
> +	return textlen;
> +}
> +
>  asmlinkage int vprintk_emit(int facility, int level,
>  			    const char *dict, size_t dictlen,
>  			    const char *fmt, va_list args)
>  {
>  	static int recursion_bug;
> -	static char cont_buf[LOG_LINE_MAX];
> -	static size_t cont_len;
> -	static int cont_level;
> -	static struct task_struct *cont_task;
>  	static char textbuf[LOG_LINE_MAX];
>  	char *text = textbuf;
>  	size_t text_len;
> @@ -1348,7 +1442,8 @@ asmlinkage int vprintk_emit(int facility, int level,
>  		recursion_bug = 0;
>  		printed_len += strlen(recursion_msg);
>  		/* emit KERN_CRIT message */
> -		log_store(0, 2, NULL, 0, recursion_msg, printed_len);
> +		log_store(0, 2, LOG_DEFAULT, 0,
> +			  NULL, 0, recursion_msg, printed_len);
>  	}
>  
>  	/*
> @@ -1386,55 +1481,38 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	}
>  
>  	if (!newline) {
> -		if (cont_len && (prefix || cont_task != current)) {
> -			/*
> -			 * Flush earlier buffer, which is either from a
> -			 * different thread, or when we got a new prefix.
> -			 */
> -			log_store(facility, cont_level, NULL, 0, cont_buf, cont_len);
> -			cont_len = 0;
> -		}
> -
> -		if (!cont_len) {
> -			cont_level = level;
> -			cont_task = current;
> -		}
> +		/*
> +		 * Flush the conflicting buffer. An earlier newline was missing,
> +		 * or another task also prints continuation lines.
> +		 */
> +		if (cont.len && (prefix || cont.owner != current))
> +			cont_flush();
>  
> -		/* buffer or append to earlier buffer from the same thread */
> -		if (cont_len + text_len > sizeof(cont_buf))
> -			text_len = sizeof(cont_buf) - cont_len;
> -		memcpy(cont_buf + cont_len, text, text_len);
> -		cont_len += text_len;
> +		/* buffer line if possible, otherwise store it right away */
> +		if (!cont_add(facility, level, text, text_len))
> +			log_store(facility, level, LOG_DEFAULT, 0,
> +				  dict, dictlen, text, text_len);
>  	} else {
> -		if (cont_len && cont_task == current) {
> -			if (prefix) {
> -				/*
> -				 * New prefix from the same thread; flush. We
> -				 * either got no earlier newline, or we race
> -				 * with an interrupt.
> -				 */
> -				log_store(facility, cont_level,
> -					  NULL, 0, cont_buf, cont_len);
> -				cont_len = 0;
> -			}
> +		bool stored = false;
>  
> -			/* append to the earlier buffer and flush */
> -			if (cont_len + text_len > sizeof(cont_buf))
> -				text_len = sizeof(cont_buf) - cont_len;
> -			memcpy(cont_buf + cont_len, text, text_len);
> -			cont_len += text_len;
> -			log_store(facility, cont_level,
> -				  NULL, 0, cont_buf, cont_len);
> -			cont_len = 0;
> -			cont_task = NULL;
> -			printed_len = cont_len;
> -		} else {
> -			/* ordinary single and terminated line */
> -			log_store(facility, level,
> -				  dict, dictlen, text, text_len);
> -			printed_len = text_len;
> +		/*
> +		 * Flush the conflicting buffer. An earlier newline was missing,
> +		 * or we race with a continuation line from an interrupt.
> +		 */
> +		if (cont.len && prefix && cont.owner == current)
> +			cont_flush();
> +
> +		/* Merge with our buffer if possible; flush it in any case */
> +		if (cont.len && cont.owner == current) {
> +			stored = cont_add(facility, level, text, text_len);
> +			cont_flush();
>  		}


I wonder if it would be better to do the following for the above two
ifs:

	if (cont.len && cont.owner == current) {
		if (!prefix)
			stored = cont_add(facility, level, text, text_len);
		cont_flush();
	}

If the prefix was true, then the cont.flush would be set when cont_add()
is called, and the first thing that cont_add() does:

	if (cont.len && cont.flushed)
		return false;

which would always be true (returning false) if prefix was set.

And the second cont_flush() is a nop due to it doing:

	if (cont.flushed)
		return;

-- Steve


> +
> +		if (!stored)
> +			log_store(facility, level, LOG_DEFAULT, 0,
> +				  dict, dictlen, text, text_len);
>  	}
> +	printed_len += text_len;
>  
>  	/*
>  	 * Try to acquire and then immediately release the console semaphore.
> @@ -1521,11 +1599,18 @@ EXPORT_SYMBOL(printk);
>  #else
>  
>  #define LOG_LINE_MAX 0
> +static struct cont {
> +	size_t len;
> +	size_t cons;
> +	u8 level;
> +	bool flushed:1;
> +} cont;
>  static struct log *log_from_idx(u32 idx) { return NULL; }
>  static u32 log_next(u32 idx) { return 0; }
>  static void call_console_drivers(int level, const char *text, size_t len) {}
>  static size_t msg_print_text(const struct log *msg, bool syslog,
>  			     char *buf, size_t size) { return 0; }
> +static size_t cont_print_text(char *text, size_t size) { return 0; }
>  
>  #endif /* CONFIG_PRINTK */
>  
> @@ -1817,6 +1902,7 @@ static u32 console_idx;
>   */
>  void console_unlock(void)
>  {
> +	static char text[LOG_LINE_MAX];
>  	static u64 seen_seq;
>  	unsigned long flags;
>  	bool wake_klogd = false;
> @@ -1829,10 +1915,23 @@ void console_unlock(void)
>  
>  	console_may_schedule = 0;
>  
> +	/* flush buffered message fragment immediately to console */
> +	raw_spin_lock_irqsave(&logbuf_lock, flags);
> +	if (cont.len && (cont.cons < cont.len || cont.flushed)) {
> +		size_t len;
> +
> +		len = cont_print_text(text, sizeof(text));
> +		raw_spin_unlock(&logbuf_lock);
> +		stop_critical_timings();
> +		call_console_drivers(cont.level, text, len);
> +		start_critical_timings();
> +		local_irq_restore(flags);
> +	} else
> +		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
> +
>  again:
>  	for (;;) {
>  		struct log *msg;
> -		static char text[LOG_LINE_MAX];
>  		size_t len;
>  		int level;
>  
> @@ -1847,13 +1946,22 @@ again:
>  			console_seq = log_first_seq;
>  			console_idx = log_first_idx;
>  		}
> -
> +skip:
>  		if (console_seq == log_next_seq)
>  			break;
>  
>  		msg = log_from_idx(console_idx);
> -		level = msg->level & 7;
> +		if (msg->flags & LOG_NOCONS) {
> +			/*
> +			 * Skip record we have buffered and already printed
> +			 * directly to the console when we received it.
> +			 */
> +			console_idx = log_next(console_idx);
> +			console_seq++;
> +			goto skip;
> +		}
>  
> +		level = msg->level;
>  		len = msg_print_text(msg, false, text, sizeof(text));
>  
>  		console_idx = log_next(console_idx);
> 


