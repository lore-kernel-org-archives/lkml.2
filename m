Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab2F2Faf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 01:30:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64989 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2F2Fae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 01:30:34 -0400
Date: Fri, 29 Jun 2012 01:30:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
Message-ID: <20120629053027.GA9841@kroah.com>
References: <20120626002307.GA4389@kroah.com>
 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
 <1340726856.977.6.camel@mop>
 <1340810038.16702.16.camel@gandalf.stny.rr.com>
 <1340810283.16702.19.camel@gandalf.stny.rr.com>
 <CAPXgP121+zA_p4x9VdSMWtu-SqqqiNC51CKkYKY4YkAL+QsQ4g@mail.gmail.com>
 <1340869133.876.10.camel@mop>
 <1340852129.16702.73.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340852129.16702.73.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 10:55:29PM -0400, Steven Rostedt wrote:
> On Thu, 2012-06-28 at 09:38 +0200, Kay Sievers wrote:
> 
> > +static void cont_flush(void)
> > +{
> > +	if (cont.flushed)
> > +		return;
> > +	if (cont.len == 0)
> > +		return;
> > +
> > +	log_store(cont.facility, cont.level, LOG_NOCONS, cont.ts_nsec,
> > +		  NULL, 0, cont.buf, cont.len);
> > +
> > +	cont.flushed = true;
> > +}
> > +
> > +static bool cont_add(int facility, int level, const char *text, size_t len)
> > +{
> > +	if (cont.len && cont.flushed)
> > +		return false;
> > +
> > +	if (cont.len + len > sizeof(cont.buf)) {
> > +		cont_flush();
> > +		return false;
> > +	}
> > +
> > +	if (!cont.len) {
> > +		cont.facility = facility;
> > +		cont.level = level;
> > +		cont.owner = current;
> > +		cont.ts_nsec = local_clock();
> > +		cont.cons = 0;
> > +		cont.flushed = false;
> > +	}
> > +
> > +	memcpy(cont.buf + cont.len, text, len);
> > +	cont.len += len;
> > +	return true;
> > +}
> > +
> > +static size_t cont_print_text(char *text, size_t size)
> > +{
> > +	size_t textlen = 0;
> > +	size_t len;
> > +
> > +	if (cont.cons == 0) {
> > +		textlen += print_time(cont.ts_nsec, text);
> > +		size -= textlen;
> > +	}
> > +
> > +	len = cont.len - cont.cons;
> > +	if (len > 0) {
> > +		if (len+1 > size)
> > +			len = size-1;
> > +		memcpy(text + textlen, cont.buf + cont.cons, len);
> > +		textlen += len;
> > +		cont.cons = cont.len;
> > +	}
> > +
> > +	if (cont.flushed) {
> > +		text[textlen++] = '\n';
> > +		/* got everything, release buffer */
> > +		cont.len = 0;
> > +	}
> > +	return textlen;
> > +}
> > +
> >  asmlinkage int vprintk_emit(int facility, int level,
> >  			    const char *dict, size_t dictlen,
> >  			    const char *fmt, va_list args)
> >  {
> >  	static int recursion_bug;
> > -	static char cont_buf[LOG_LINE_MAX];
> > -	static size_t cont_len;
> > -	static int cont_level;
> > -	static struct task_struct *cont_task;
> >  	static char textbuf[LOG_LINE_MAX];
> >  	char *text = textbuf;
> >  	size_t text_len;
> > @@ -1348,7 +1442,8 @@ asmlinkage int vprintk_emit(int facility, int level,
> >  		recursion_bug = 0;
> >  		printed_len += strlen(recursion_msg);
> >  		/* emit KERN_CRIT message */
> > -		log_store(0, 2, NULL, 0, recursion_msg, printed_len);
> > +		log_store(0, 2, LOG_DEFAULT, 0,
> > +			  NULL, 0, recursion_msg, printed_len);
> >  	}
> >  
> >  	/*
> > @@ -1386,55 +1481,38 @@ asmlinkage int vprintk_emit(int facility, int level,
> >  	}
> >  
> >  	if (!newline) {
> > -		if (cont_len && (prefix || cont_task != current)) {
> > -			/*
> > -			 * Flush earlier buffer, which is either from a
> > -			 * different thread, or when we got a new prefix.
> > -			 */
> > -			log_store(facility, cont_level, NULL, 0, cont_buf, cont_len);
> > -			cont_len = 0;
> > -		}
> > -
> > -		if (!cont_len) {
> > -			cont_level = level;
> > -			cont_task = current;
> > -		}
> > +		/*
> > +		 * Flush the conflicting buffer. An earlier newline was missing,
> > +		 * or another task also prints continuation lines.
> > +		 */
> > +		if (cont.len && (prefix || cont.owner != current))
> > +			cont_flush();
> >  
> > -		/* buffer or append to earlier buffer from the same thread */
> > -		if (cont_len + text_len > sizeof(cont_buf))
> > -			text_len = sizeof(cont_buf) - cont_len;
> > -		memcpy(cont_buf + cont_len, text, text_len);
> > -		cont_len += text_len;
> > +		/* buffer line if possible, otherwise store it right away */
> > +		if (!cont_add(facility, level, text, text_len))
> > +			log_store(facility, level, LOG_DEFAULT, 0,
> > +				  dict, dictlen, text, text_len);
> >  	} else {
> > -		if (cont_len && cont_task == current) {
> > -			if (prefix) {
> > -				/*
> > -				 * New prefix from the same thread; flush. We
> > -				 * either got no earlier newline, or we race
> > -				 * with an interrupt.
> > -				 */
> > -				log_store(facility, cont_level,
> > -					  NULL, 0, cont_buf, cont_len);
> > -				cont_len = 0;
> > -			}
> > +		bool stored = false;
> >  
> > -			/* append to the earlier buffer and flush */
> > -			if (cont_len + text_len > sizeof(cont_buf))
> > -				text_len = sizeof(cont_buf) - cont_len;
> > -			memcpy(cont_buf + cont_len, text, text_len);
> > -			cont_len += text_len;
> > -			log_store(facility, cont_level,
> > -				  NULL, 0, cont_buf, cont_len);
> > -			cont_len = 0;
> > -			cont_task = NULL;
> > -			printed_len = cont_len;
> > -		} else {
> > -			/* ordinary single and terminated line */
> > -			log_store(facility, level,
> > -				  dict, dictlen, text, text_len);
> > -			printed_len = text_len;
> > +		/*
> > +		 * Flush the conflicting buffer. An earlier newline was missing,
> > +		 * or we race with a continuation line from an interrupt.
> > +		 */
> > +		if (cont.len && prefix && cont.owner == current)
> > +			cont_flush();
> > +
> > +		/* Merge with our buffer if possible; flush it in any case */
> > +		if (cont.len && cont.owner == current) {
> > +			stored = cont_add(facility, level, text, text_len);
> > +			cont_flush();
> >  		}
> 
> 
> I wonder if it would be better to do the following for the above two
> ifs:
> 
> 	if (cont.len && cont.owner == current) {
> 		if (!prefix)
> 			stored = cont_add(facility, level, text, text_len);
> 		cont_flush();
> 	}
> 
> If the prefix was true, then the cont.flush would be set when cont_add()
> is called, and the first thing that cont_add() does:
> 
> 	if (cont.len && cont.flushed)
> 		return false;
> 
> which would always be true (returning false) if prefix was set.
> 
> And the second cont_flush() is a nop due to it doing:
> 
> 	if (cont.flushed)
> 		return;

It might be "better", and this would be a nice optimization, but is it
needed right now?  In other words, I'd like to get this patch into
linux-next soon to get testing to get to Linus before 3.5-final comes
out, don't you?

thanks,

greg k-h
