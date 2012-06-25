Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab2FYO0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:26:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33447 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab2FYO0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:26:10 -0400
X-Authority-Analysis: v=2.0 cv=bpjO9Tmi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=hVM6Fzsi8tMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=v9HWPl1dLNoSqlwmXssA:9 a=PUjeQqilurYA:10 a=FTuAzMP7tzV-YEzQ:21 a=g3tJHKKZX46_oYKo:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340634366.27036.324.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2] printk: Have printk() never buffer its data
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "kay.sievers" <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 25 Jun 2012 10:26:06 -0400
In-Reply-To: <20120625135611.GA1301@gmail.com>
References: <1340630505.27036.294.camel@gandalf.stny.rr.com>
	 <20120625135611.GA1301@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 15:56 +0200, Ingo Molnar wrote:

> > @@ -836,14 +854,45 @@ static size_t msg_print_text(const struct log *msg, bool syslog,
> >  		}
> >  
> >  		if (buf) {
> > -			if (print_prefix(msg, syslog, NULL) +
> > -			    text_len + 1>= size - len)
> > -				break;
> > +			static bool last_newline = true;
> 
> I'd suggest to move this last_newline flag up to the logbuf_lock 
> block of global variables - it belongs there. Statics are easily 
> overlooked and maybe something else running under the 
> logbuf_lock will want to access this variable in the future.

Will do.

> 
> > +			bool newline = true;
> > +			bool prefix = true;
> > +			int facility = msg->level >> 3;
> > +
> > +			/*
> > +			 * The kernel sends some commands via the facility.
> > +			 * To do so, a high number mask is used (LOG_KERNEL)
> > +			 * and the low bits of the mask hold the command bits
> > +			 * that the kernel printk() will use to state how the
> > +			 * msg will be printed.
> > +			 */
> > +			if ((facility & LOG_KERNEL) == LOG_KERNEL) {
> > +				if (facility & LOG_NOPREFIX_SET)
> > +					prefix = false;
> > +				if (facility & LOG_NONL_SET)
> > +					newline = false;
> > +			}
> 
> I suspect using a separate command flag and passing it along 
> would be somewhat cleaner - but no strong objections against 
> this approach either.

Yeah, I hate passing info via the facility, but I didn't want to bloat
the struct log any more. As the msg_print_text() is run separately from
printk, via the console_unlock(), the struct log is the only way to send
information from printk_emit() to msg_print_text().

Right now we have:

struct log {
	u64 ts_nsec;		/* timestamp in nanoseconds */
	u16 len;		/* length of entire record */
	u16 text_len;		/* length of text buffer */
	u16 dict_len;		/* length of dictionary buffer */
	u16 level;		/* syslog level + facility */
};

This is actually saved on the printk buffer (just not printed). Maybe a
better idea would be to break up the level more formally:

instead of:

	msg->level = (facility << 3) | (level & 7);

we could do:

	msg->level = (flags << 12) | ((facility & 0x1ff) << 3) | (level & 7);

and pass in the flags separately.

Yeah, I think this may be a cleaner solution.


> 
> > +			if (prefix) {
> > +				/*
> > +				 * Force newline, for last line if this line
> > +				 * is printing out a prefix.
> > +				 */
> > +				if (!last_newline)
> > +					buf[len++] = '\n';
> > +
> > +				if (print_prefix(msg, syslog, NULL) +
> > +				    text_len + 1 >= size - len)
> > +					break;
> > +
> > +				len += print_prefix(msg, syslog, buf + len);
> > +			}
> 
> Just a side note, this is a problem that exists in the new 
> devkmsg_user code, message size limit handling of 
> devkmsg_user->buf[] is non-existent and conditions for and 
> protections against triggering overflow are unclear - right now 
> it's probably addressed by making the buffer excessively large:
> 
> struct devkmsg_user {
>         u64 seq;
>         u32 idx;
>         struct mutex lock;
>         char buf[8192];
> };
> 
> but this may eventually have to be addressed - various things 
> like newline insertion or automatic escaping can enlargen the 
> buffer - if an attacker ever has control over a large enough 
> printk'ed text then this is a potential root hole.

Agreed, this part made me a little nervous about buffer overflow too.

> 
> >  
> > -			len += print_prefix(msg, syslog, buf + len);
> >  			memcpy(buf + len, text, text_len);
> >  			len += text_len;
> > -			buf[len++] = '\n';
> > +			if (newline)
> > +				buf[len++] = '\n';
> > +			last_newline = newline;
> >  		} else {
> >  			/* SYSLOG_ACTION_* buffer size only calculation */
> >  			len += print_prefix(msg, syslog, NULL);
> > @@ -1267,6 +1316,7 @@ asmlinkage int vprintk_emit(int facility, int level,
> >  	static char cont_buf[LOG_LINE_MAX];
> >  	static size_t cont_len;
> >  	static int cont_level;
> > +	static bool cont_prefix;
> >  	static struct task_struct *cont_task;
> >  	static char textbuf[LOG_LINE_MAX];
> 
> 
> argh. So the vprintk_emit() muck introduced its own large set of 
> function local statics? Taste fail, really ...
> 
> >  	char *text = textbuf;
> > @@ -1275,8 +1325,12 @@ asmlinkage int vprintk_emit(int facility, int level,
> >  	int this_cpu;
> >  	bool newline = false;
> >  	bool prefix = false;
> > +	bool flush;
> >  	int printed_len = 0;
> >  
> > +	/* output from printk() always flush to console (no line buffering) */
> > +	flush = facility == 0;
> 
> While your code is correct, this pattern is easily mistaken for 
> the 'a = b = c' pattern, so I'd suggest writing it as:
> 
> 	flush = (facility == 0);

Yeah, that looks better. Will fix.

> 
> Anyway, bike shed painting aside, the patch looks like a 
> workable solution to me.

Great! Lets hope Kay feels the same way.

-- Steve


