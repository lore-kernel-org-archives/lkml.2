Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab2FZQa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:30:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40689 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758499Ab2FZQa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:30:56 -0400
Message-ID: <1340728255.3359.42.camel@joe2Laptop>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Tue, 26 Jun 2012 09:30:55 -0700
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 18:07 +0200, Kay Sievers wrote:
[]

Just a couple trivial notes:

> diff --git a/kernel/printk.c b/kernel/printk.c
[]
> @@ -1795,6 +1831,7 @@ static u32 console_idx;
>   */
>  void console_unlock(void)
>  {
> +	static char text[LOG_LINE_MAX];

Is this static to avoid excessive stack?
Might be useful to note that.

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

This could overrun the 512 bytes of text yes?


