Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1EKAve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 20:51:34 -0400
Received: from mail.perches.com ([173.55.12.10]:1472 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab1EKAvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 20:51:33 -0400
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
From: Joe Perches <joe@perches.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <1305073386-4810-3-git-send-email-john.stultz@linaro.org>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
	 <1305073386-4810-3-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 17:51:30 -0700
Message-ID: <1305075090.19586.189.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 17:23 -0700, John Stultz wrote:
> Acessing task->comm requires proper locking. However in the past
> access to current->comm could be done without locking. This
> is no longer the case, so all comm access needs to be done
> while holding the comm_lock.
> 
> In my attempt to clean up unprotected comm access, I've noticed
> most comm access is done for printk output. To simpify correct
> locking in these cases, I've introduced a new %ptc format,
> which will safely print the corresponding task's comm.

Hi John.

Couple of tyops for Accessing and simplify in your commit message
and a few comments on the patch.

Could misuse of %ptc (not using current) cause system lockup?

> Example use:
> printk("%ptc: unaligned epc - sending SIGBUS.\n", current);
 

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index bc0ac6b..b9c97b8 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -797,6 +797,26 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
>  	return string(buf, end, uuid, spec);
>  }
>  
> +static noinline_for_stack
> +char *task_comm_string(char *buf, char *end, u8 *addr,
> +			 struct printf_spec spec, const char *fmt)

addr should be void * not u8 *

> +{
> +	struct task_struct *tsk = (struct task_struct *) addr;

no cast.

Maybe it'd be better to use current inside this routine and not
pass the pointer at all.

static noinline_for_stack
char *task_comm_string(char *buf, char *end,
		       struct printf_spec spec, const char *fmt)

> +	char *ret;
> +	unsigned long seq;
> +
> +	do {
> +		seq = read_seqbegin(&tsk->comm_lock);
> +
> +		ret = string(buf, end, tsk->comm, spec);
> +
> +	} while (read_seqretry(&tsk->comm_lock, seq));


> @@ -864,6 +884,12 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  	}
>  
>  	switch (*fmt) {
> +	case 't':
> +		switch (fmt[1]) {
> +		case 'c':
> +			return task_comm_string(buf, end, ptr, spec, fmt);

maybe
			return task_comm_string(buf, end, spec, fmt);


