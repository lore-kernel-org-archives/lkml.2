Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2F0POE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:14:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15474 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2F0POA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:14:00 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=EvKSwpK77UAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=82irRftXAAAA:8 a=T_D7DxnaFWuFB38QkAoA:9 a=PUjeQqilurYA:10 a=WgwKcZQGGVUA:10 a=jeBq3FmKZ4MA:10 a=7MV9688Znd1sK1vi:21 a=KGScE2wOivjdEYtI:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340810038.16702.16.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Steven Rostedt <rostedt@goodmis.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Wed, 27 Jun 2012 11:13:58 -0400
In-Reply-To: <1340726856.977.6.camel@mop>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com>
	 <20120625150722.8cd4f45d.akpm@linux-foundation.org>
	 <20120625235531.GB3652@kroah.com>
	 <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
	 <20120626002307.GA4389@kroah.com>
	 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
	 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
	 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
	 <1340726856.977.6.camel@mop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 18:07 +0200, Kay Sievers wrote:

> From: Kay Sievers <kay@vrfy.org>
> Subject: printk: flush continuation lines immediately to console
> 
> Continuation lines are buffered internally to merge the chunked
> printk()s into a single record, and to isolate potentially racy
> continuation users from usual terminated line users.
> 
> This though, has the effect that partial lines are not printed to
> the console in the moment they are emitted. In case the kernel
> crashes in the meantime, the potentially interesting printed
> information will never reach the consoles.
> 
> Here we share the continuation buffer with the console copy logic,
> and partial lines are immediately flushed to the consoles, but still
> buffered internally to improve the integrity of the messages.

I just tested this patch and it boots fine for me. Better still, I put
in my 'delay' to make sure the output shows up as it is printed, and it
seems to do so.

Tested-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
> 
>  kernel/printk.c |  129 +++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 101 insertions(+), 28 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index a2276b9..92c34bd1 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -193,12 +193,19 @@ static int console_may_schedule;
>   * separated by ',', and find the message after the ';' character.
>   */
>  
> +enum log_flags {
> +	LOG_DEFAULT = 0,
> +	LOG_NOCONS = 1,		/* already flushed, do not print to console */
> +};
> +
>  struct log {
>  	u64 ts_nsec;		/* timestamp in nanoseconds */
>  	u16 len;		/* length of entire record */
>  	u16 text_len;		/* length of text buffer */
>  	u16 dict_len;		/* length of dictionary buffer */
> -	u16 level;		/* syslog level + facility */
> +	u8 facility;		/* syslog facility */
> +	u8 flags:5;		/* internal record flags */
> +	u8 level:3;		/* syslog level */
>  };
>  
>  /*
> @@ -286,6 +293,7 @@ static u32 log_next(u32 idx)
>  
>  /* insert record into the buffer, discard old ones, update heads */
>  static void log_store(int facility, int level,
> +		      enum log_flags flags, u64 ts_nsec,
>  		      const char *dict, u16 dict_len,
>  		      const char *text, u16 text_len)
>  {
> @@ -329,8 +337,13 @@ static void log_store(int facility, int level,
>  	msg->text_len = text_len;
>  	memcpy(log_dict(msg), dict, dict_len);
>  	msg->dict_len = dict_len;
> -	msg->level = (facility << 3) | (level & 7);
> -	msg->ts_nsec = local_clock();
> +	msg->facility = facility;
> +	msg->level = level & 7;
> +	msg->flags = flags & 0x1f;
> +	if (ts_nsec > 0)
> +		msg->ts_nsec = ts_nsec;
> +	else
> +		msg->ts_nsec = local_clock();
>  	memset(log_dict(msg) + dict_len, 0, pad_len);
>  	msg->len = sizeof(struct log) + text_len + dict_len + pad_len;
>  
> @@ -446,7 +459,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>  	ts_usec = msg->ts_nsec;
>  	do_div(ts_usec, 1000);
>  	len = sprintf(user->buf, "%u,%llu,%llu;",
> -		      msg->level, user->seq, ts_usec);
> +		      (msg->facility << 3) | msg->level, user->seq, ts_usec);
>  
>  	/* escape non-printable characters */
>  	for (i = 0; i < msg->text_len; i++) {
> @@ -787,6 +800,21 @@ static bool printk_time;
>  #endif
>  module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
>  
> +static size_t print_time(u64 ts, char *buf)
> +{
> +	unsigned long rem_nsec;
> +
> +	if (!printk_time)
> +		return 0;
> +
> +	if (!buf)
> +		return 15;
> +
> +	rem_nsec = do_div(ts, 1000000000);
> +	return sprintf(buf, "[%5lu.%06lu] ",
> +		       (unsigned long)ts, rem_nsec / 1000);
> +}
> +
>  static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
>  {
>  	size_t len = 0;
> @@ -803,18 +831,7 @@ static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
>  		}
>  	}
>  
> -	if (printk_time) {
> -		if (buf) {
> -			unsigned long long ts = msg->ts_nsec;
> -			unsigned long rem_nsec = do_div(ts, 1000000000);
> -
> -			len += sprintf(buf + len, "[%5lu.%06lu] ",
> -					 (unsigned long) ts, rem_nsec / 1000);
> -		} else {
> -			len += 15;
> -		}
> -	}
> -
> +	len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
>  	return len;
>  }
>  
> @@ -1272,15 +1289,25 @@ static inline void printk_delay(void)
>  	}
>  }
>  
> +/*
> + * Continuation lines are buffered, and not committed to the record buffer
> + * until the line is complete, or a race forces a flush. The line fragments
> + * though, are printed immediately to the consoles to ensure everything has
> + * reached the console in case of a kernel crash.
> + */
> +static char cont_buf[LOG_LINE_MAX];
> +static size_t cont_len;
> +static size_t cont_cons;
> +static size_t cont_cons_len;
> +static int cont_level;
> +static u64 cont_ts_nsec;
> +static struct task_struct *cont_task;
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
> @@ -1326,7 +1353,8 @@ asmlinkage int vprintk_emit(int facility, int level,
>  		recursion_bug = 0;
>  		printed_len += strlen(recursion_msg);
>  		/* emit KERN_CRIT message */
> -		log_store(0, 2, NULL, 0, recursion_msg, printed_len);
> +		log_store(0, 2, LOG_DEFAULT, 0,
> +			  NULL, 0, recursion_msg, printed_len);
>  	}
>  
>  	/*
> @@ -1369,13 +1397,17 @@ asmlinkage int vprintk_emit(int facility, int level,
>  			 * Flush earlier buffer, which is either from a
>  			 * different thread, or when we got a new prefix.
>  			 */
> -			log_store(facility, cont_level, NULL, 0, cont_buf, cont_len);
> +			log_store(facility, cont_level,
> +				  LOG_NOCONS, cont_ts_nsec,
> +				  NULL, 0, cont_buf, cont_len);
>  			cont_len = 0;
>  		}
>  
>  		if (!cont_len) {
> +			cont_cons = 0;
>  			cont_level = level;
>  			cont_task = current;
> +			cont_ts_nsec = local_clock();
>  		}
>  
>  		/* buffer or append to earlier buffer from the same thread */
> @@ -1383,6 +1415,8 @@ asmlinkage int vprintk_emit(int facility, int level,
>  			text_len = sizeof(cont_buf) - cont_len;
>  		memcpy(cont_buf + cont_len, text, text_len);
>  		cont_len += text_len;
> +		cont_cons_len = cont_len;
> +		printed_len = text_len;
>  	} else {
>  		if (cont_len && cont_task == current) {
>  			if (prefix) {
> @@ -1392,6 +1426,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  				 * with an interrupt.
>  				 */
>  				log_store(facility, cont_level,
> +					  LOG_NOCONS, cont_ts_nsec,
>  					  NULL, 0, cont_buf, cont_len);
>  				cont_len = 0;
>  			}
> @@ -1401,14 +1436,15 @@ asmlinkage int vprintk_emit(int facility, int level,
>  				text_len = sizeof(cont_buf) - cont_len;
>  			memcpy(cont_buf + cont_len, text, text_len);
>  			cont_len += text_len;
> +			cont_cons_len = cont_len;
>  			log_store(facility, cont_level,
> +				  LOG_NOCONS, cont_ts_nsec,
>  				  NULL, 0, cont_buf, cont_len);
>  			cont_len = 0;
> -			cont_task = NULL;
> -			printed_len = cont_len;
> +			printed_len = text_len;
>  		} else {
>  			/* ordinary single and terminated line */
> -			log_store(facility, level,
> +			log_store(facility, level, LOG_DEFAULT, 0,
>  				  dict, dictlen, text, text_len);
>  			printed_len = text_len;
>  		}
> @@ -1795,6 +1831,7 @@ static u32 console_idx;
>   */
>  void console_unlock(void)
>  {
> +	static char text[LOG_LINE_MAX];
>  	static u64 seen_seq;
>  	unsigned long flags;
>  	bool wake_klogd = false;
> @@ -1807,10 +1844,37 @@ void console_unlock(void)
>  
>  	console_may_schedule = 0;
>  
> +	/* flush buffered message fragment immediately to console */
> +	raw_spin_lock_irqsave(&logbuf_lock, flags);
> +	if (cont_cons_len && (cont_cons < cont_cons_len || !cont_len)) {
> +		size_t textlen = 0;
> +		size_t len;
> +
> +		len = cont_cons_len - cont_cons;
> +		if (!cont_cons)
> +			textlen = print_time(cont_ts_nsec, text);
> +		memcpy(text + textlen, cont_buf + cont_cons, len);
> +		textlen += len;
> +		cont_cons = cont_cons_len;
> +
> +		if (!cont_len) {
> +			/* last chunk of line; terminate */
> +			text[textlen++] = '\n';
> +			cont_cons_len = 0;
> +		}
> +		raw_spin_unlock(&logbuf_lock);
> +
> +		stop_critical_timings();
> +		call_console_drivers(cont_level, text, textlen);
> +		start_critical_timings();
> +
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
> @@ -1825,13 +1889,22 @@ again:
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


