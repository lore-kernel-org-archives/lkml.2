Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2FIQ6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 12:58:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2FIQ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 12:57:58 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_41qGextLBQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=yPCof4ZbAAAA:8 a=xkiObRbeV-6RiUeizzEA:9 a=PUjeQqilurYA:10 a=7DSvI1NPTFQA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339261076.13377.90.camel@gandalf.stny.rr.com>
Subject: Re: [patch] ftrace: clear bits properly in reset_iter_read()
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sat, 09 Jun 2012 12:57:56 -0400
In-Reply-To: <20120609161027.GD6488@elgon.mountain>
References: <20120609161027.GD6488@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-09 at 19:10 +0300, Dan Carpenter wrote:
> There is a typo here where '&' is used instead of '|' and it turns the
> statement into a noop.  The original code is equivalent to:
> 
> 	iter->flags &= ~((1 << 2) & (1 << 4));
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is a static checker fix and I'm not super familiar with ftrace.
> Please review carefully.
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index a008663..97da2dc 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2358,7 +2358,7 @@ static void reset_iter_read(struct ftrace_iterator *iter)
>  {
>  	iter->pos = 0;
>  	iter->func_pos = 0;
> -	iter->flags &= ~(FTRACE_ITER_PRINTALL & FTRACE_ITER_HASH);
> +	iter->flags &= ~(FTRACE_ITER_PRINTALL | FTRACE_ITER_HASH);

Thanks! This is a real minor bug, but as it is a simple fix I will
probably queue it up for 3.5 and stable. The reason that it has gone
unnoticed for so long is that this would only show up if you did a lseek
on the function list file. Which is not a common operation to do.

I checked the code and if someone were to do an lseek with these flags
set then they would just get the hash list again (and not the function
list). It's a bug, yes, but not a big one.

I'll queue it up on Monday.

-- Steve


>  }
>  
>  static void *t_start(struct seq_file *m, loff_t *pos)


