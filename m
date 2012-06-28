Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab2F1FAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 01:00:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60295 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751152Ab2F1FAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 01:00:16 -0400
Message-ID: <1340859614.16533.66.camel@joe2Laptop>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Wed, 27 Jun 2012 22:00:14 -0700
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 09:38 +0200, Kay Sievers wrote:
> Here we share the continuation buffer with the console copy logic,
> and partial lines are always immediately flushed to the available
> consoles. They are still buffered internally to improve the
> readability and integrity of the messages and minimize the amount
> of needed record headers to store.

trivia:

> diff --git a/kernel/printk.c b/kernel/printk.c

> @@ -329,8 +337,13 @@ static void log_store(int facility, int level,
>  	msg->text_len = text_len;
>  	memcpy(log_dict(msg), dict, dict_len);
>  	msg->dict_len = dict_len;
> -	msg->level = (facility << 3) | (level & 7);
> -	msg->ts_nsec = local_clock();
> +	msg->facility = facility;
> +	msg->level = level & 7;

Doesn't need & 7

> +	msg->flags = flags & 0x1f;
> +	if (ts_nsec > 0)
> +		msg->ts_nsec = ts_nsec;
> +	else
> +		msg->ts_nsec = local_clock();

Why local_clock?  ts_nsec really can be 0.
[]

> @@ -1294,15 +1311,92 @@ static inline void printk_delay(void)
>  	}
>  }
>  
> +/*
> + * Continuation lines are buffered, and not committed to the record buffer
> + * until the line is complete, or a race forces it. The line fragments
> + * though, are printed immediately to the consoles to ensure everything has
> + * reached the console in case of a kernel crash.
> + */
> +static struct cont {
> +	char buf[LOG_LINE_MAX];
> +	size_t len;			/* length == 0 means unused buffer */
> +	size_t cons;			/* bytes written to console */
> +	struct task_struct *owner;	/* task of first print*/
> +	u64 ts_nsec;			/* time of first print */
> +	u8 level;			/* log level of first message */
> +	u8 facility;			/* log level of first message */
> +	bool flushed:1;			/* buffer sealed and committed */

bool flushed:1 seems unnecessary.
bool flushed seems more appropriate.

> +} cont;
> +
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

Looks like you can still overrun cont.buf.


