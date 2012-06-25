Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab2FYN4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:56:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50381 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab2FYN4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:56:16 -0400
Date: Mon, 25 Jun 2012 15:56:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "kay.sievers" <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v2] printk: Have printk() never buffer its data
Message-ID: <20120625135611.GA1301@gmail.com>
References: <1340630505.27036.294.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340630505.27036.294.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [...]
> 
> The printk() state of the last print is kept around to know 
> how to print the new lines. If the printk does not have a new 
> line, the state is stored in msg_print_text() and if a prefix 
> is to be printed next, it forces a newline. This keeps the new 
> behavior when multiple partial prints are happening across 
> CPUs. Each one will have its own line (like it does today).
> 
> I hooked onto the 'facility' infrastructure and used '0x1ffc' 
> (the max number) as a way to communicate printk() commands to 
> the msg_print_text() which is performed at a later time 
> (console_unlock()).
> 
> I tested this out, and now the lockup shows:
> 
> [    9.018231] Kprobe smoke test passed successfully
> [    9.023084] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_hold
> off=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
> [    9.066065] Testing tracer function:

Ok, this is *much* better behavior, out of box.

A couple of comments:

> @@ -836,14 +854,45 @@ static size_t msg_print_text(const struct log *msg, bool syslog,
>  		}
>  
>  		if (buf) {
> -			if (print_prefix(msg, syslog, NULL) +
> -			    text_len + 1>= size - len)
> -				break;
> +			static bool last_newline = true;

I'd suggest to move this last_newline flag up to the logbuf_lock 
block of global variables - it belongs there. Statics are easily 
overlooked and maybe something else running under the 
logbuf_lock will want to access this variable in the future.

> +			bool newline = true;
> +			bool prefix = true;
> +			int facility = msg->level >> 3;
> +
> +			/*
> +			 * The kernel sends some commands via the facility.
> +			 * To do so, a high number mask is used (LOG_KERNEL)
> +			 * and the low bits of the mask hold the command bits
> +			 * that the kernel printk() will use to state how the
> +			 * msg will be printed.
> +			 */
> +			if ((facility & LOG_KERNEL) == LOG_KERNEL) {
> +				if (facility & LOG_NOPREFIX_SET)
> +					prefix = false;
> +				if (facility & LOG_NONL_SET)
> +					newline = false;
> +			}

I suspect using a separate command flag and passing it along 
would be somewhat cleaner - but no strong objections against 
this approach either.

> +			if (prefix) {
> +				/*
> +				 * Force newline, for last line if this line
> +				 * is printing out a prefix.
> +				 */
> +				if (!last_newline)
> +					buf[len++] = '\n';
> +
> +				if (print_prefix(msg, syslog, NULL) +
> +				    text_len + 1 >= size - len)
> +					break;
> +
> +				len += print_prefix(msg, syslog, buf + len);
> +			}

Just a side note, this is a problem that exists in the new 
devkmsg_user code, message size limit handling of 
devkmsg_user->buf[] is non-existent and conditions for and 
protections against triggering overflow are unclear - right now 
it's probably addressed by making the buffer excessively large:

struct devkmsg_user {
        u64 seq;
        u32 idx;
        struct mutex lock;
        char buf[8192];
};

but this may eventually have to be addressed - various things 
like newline insertion or automatic escaping can enlargen the 
buffer - if an attacker ever has control over a large enough 
printk'ed text then this is a potential root hole.

>  
> -			len += print_prefix(msg, syslog, buf + len);
>  			memcpy(buf + len, text, text_len);
>  			len += text_len;
> -			buf[len++] = '\n';
> +			if (newline)
> +				buf[len++] = '\n';
> +			last_newline = newline;
>  		} else {
>  			/* SYSLOG_ACTION_* buffer size only calculation */
>  			len += print_prefix(msg, syslog, NULL);
> @@ -1267,6 +1316,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	static char cont_buf[LOG_LINE_MAX];
>  	static size_t cont_len;
>  	static int cont_level;
> +	static bool cont_prefix;
>  	static struct task_struct *cont_task;
>  	static char textbuf[LOG_LINE_MAX];


argh. So the vprintk_emit() muck introduced its own large set of 
function local statics? Taste fail, really ...

>  	char *text = textbuf;
> @@ -1275,8 +1325,12 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	int this_cpu;
>  	bool newline = false;
>  	bool prefix = false;
> +	bool flush;
>  	int printed_len = 0;
>  
> +	/* output from printk() always flush to console (no line buffering) */
> +	flush = facility == 0;

While your code is correct, this pattern is easily mistaken for 
the 'a = b = c' pattern, so I'd suggest writing it as:

	flush = (facility == 0);

Anyway, bike shed painting aside, the patch looks like a 
workable solution to me.

Thanks,

	Ingo
