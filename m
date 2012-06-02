Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326Ab2FBCIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 22:08:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22003 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab2FBCIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 22:08:00 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TZ4Pk1CgInwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=mDV3o1hIAAAA:8 a=5oHEXQPcu1oIOspzj0UA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338602877.13348.474.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH -tip  1/9] ftrace: Add pt_regs acceptable trace
 callback
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Fri, 01 Jun 2012 22:07:57 -0400
In-Reply-To: <20120529124857.9191.5868.stgit@localhost.localdomain>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
	 <20120529124857.9191.5868.stgit@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 21:48 +0900, Masami Hiramatsu wrote:

>  struct ftrace_ops {
> -	ftrace_func_t			func;
> +	union {
> +		ftrace_func_t			func;
> +		ftrace_regs_func_t		regs_func;
> +	};
>  	struct ftrace_ops		*next;
>  	unsigned long			flags;
>  	int __percpu			*disabled;
> @@ -164,6 +182,7 @@ static inline int ftrace_function_local_disabled(struct ftrace_ops *ops)
>  }

[..]

>  
>  static struct ftrace_ops global_ops = {
> -	.func			= ftrace_stub,
> +	.regs_func		= ftrace_regs_stub,
>  	.notrace_hash		= EMPTY_HASH,
>  	.filter_hash		= EMPTY_HASH,
> +	.flags			= FTRACE_OPS_FL_SAVE_REGS,
>  };
>  
>  static DEFINE_MUTEX(ftrace_regex_lock);
> @@ -3911,7 +3924,8 @@ void __init ftrace_init(void)
>  #else
>  
>  static struct ftrace_ops global_ops = {
> -	.func			= ftrace_stub,
> +	.regs_func		= ftrace_regs_stub,
> +	.flags			= FTRACE_OPS_FL_SAVE_REGS,
>  };
>  

Ug, this wont compile with some versions of gcc :-(

The one I stumbled on is gcc 4.5.1 (which I test builds against 4.5.1
and 4.6.0). Then I saw this BZ:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=10676

This can't be a union :-(  Then we can not initialize it.

I may go with my old approach and just change all callers to have a regs
parameter.

-- Steve


