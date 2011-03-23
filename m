Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1CWOQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:16:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37077 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab1CWOQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:16:30 -0400
Date: Wed, 23 Mar 2011 15:16:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RESEND 1/2] vsprintf: introduce %pT format specifier
Message-ID: <20110323141624.GB18093@elte.hu>
References: <20110323131213.GA25467@elte.hu>
 <1300886997-30781-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300886997-30781-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@gmail.com> wrote:

> The %pT format specifier is for stack backtrace. Its handler
> sprint_trace() does symbol lookup using (address-1) to ensure
> the address will not point outside of the function.
> 
> If there is a tail-call to the function marked "noreturn",
> gcc optimized out the code after the call then causes saved
> return address points outside of the function (i.e. the start
> of the next function), so pollutes call trace somewhat.
> This patch will fix it.
> 
> before:
> [   18.345923] Call Trace:
> [   18.346001]  [<ffffffff812a8502>] panic+0x8c/0x18d
> [   18.346257]  [<ffffffffa000012a>] deep01+0x0/0x38 [test_panic]  <--- bad
> [   18.346347]  [<ffffffff81104666>] proc_file_write+0x73/0x8d
> [   18.346432]  [<ffffffff811000b3>] proc_reg_write+0x8d/0xac
> [   18.346516]  [<ffffffff810c7d32>] vfs_write+0xa1/0xc5
> [   18.346603]  [<ffffffff810c7e0f>] sys_write+0x45/0x6c
> [   18.346801]  [<ffffffff8f02943b>] system_call_fastpath+0x16/0x1b
> 
> after:
> [   22.224483] Call Trace:
> [   22.224569]  [<ffffffff812bce69>] panic+0x8c/0x18d
> [   22.224848]  [<ffffffffa000012a>] panic_write+0x20/0x20 [test_panic]  <--- ok
> [   22.224979]  [<ffffffff81115fab>] proc_file_write+0x73/0x8d
> [   22.225089]  [<ffffffff81111a5f>] proc_reg_write+0x8d/0xac
> [   22.225199]  [<ffffffff810d90ee>] vfs_write+0xa1/0xc5
> [   22.225304]  [<ffffffff810d91cb>] sys_write+0x45/0x6c
> [   22.225408]  [<ffffffff812c07fb>] system_call_fastpath+0x16/0x1b

Ok, this looks really useful - we really want 100% perfect backtraces, kernel 
developers are looking at hundreds of thousands of call traces per year, so 
every little detail helps in the long run!

[ Nit: please omit the timestamp prefixes from the changelog, they add no 
  information and just clutter the git log. ]

The implementation could be done a bit cleaner:

> +/**
> + * sprint_trace - Look up a kernel trace symbol and return it in a text buffer
> + * @buffer: buffer to be stored
> + * @address: address to lookup
> + *
> + * This function is for stack trace and does the same thing as sprint_symbol()
> + * but with modified/decreased @address. If there is a tail-call to the
> + * function marked "noreturn", gcc optimized out code after the call so that
> + * the stack-saved return address could point outside of the caller. This
> + * function ensures that kallsyms will find the original caller by decreasing
> + * @address and then adjusts the result by increasing offset.
> + *
> + * This function returns the number of bytes stored in @buffer.
> + */
> +int sprint_trace(char *buffer, unsigned long address)
> +{
> +	char *modname;
> +	const char *name;
> +	unsigned long offset, size;
> +	int len;
> +
> +	name = kallsyms_lookup(address-1, &size, &offset, &modname, buffer);
> +	if (!name)
> +		return sprintf(buffer, "0x%lx", address);
> +
> +	if (name != buffer)
> +		strcpy(buffer, name);
> +	len = strlen(buffer);
> +	buffer += len;
> +	offset++;
> +
> +	if (modname)
> +		len += sprintf(buffer, "+%#lx/%#lx [%s]",
> +						offset, size, modname);

[ Nit: please do not break the line there, it makes the code less readable. 
  (ignore checkpatch in this case) ]

> +	else
> +		len += sprintf(buffer, "+%#lx/%#lx", offset, size);
> +
> +	return len;
> +}

This is really just a trivial variant of sprint_symbol() AFAICS, to make 
function return lookups more reliable. You look up address-1 then fix up the 
resulting offset.

I'd suggest to introduce __sprint_symbol() internal helper function, with a 
'symbol_offset' parameter to it.

That way sprint_symbol() can be implemented as a __sprint_symbol(..., 0) call, 
while sprint_trace() can be implemented as a __sprint_symbol(.., -1) call.

Also, while at it, please rename sprint_trace() to something better. This is 
not about tracing per se, this is about *backtraces* - and in particular this 
is about return addresses to noreturn functions pointing outside the kallsyms 
symbol of that function.

So a better name would be sprint_backtrace() or so?

> @@ -949,6 +951,7 @@ int kptr_restrict = 1;
>   * - 'f' For simple symbolic function names without offset
>   * - 'S' For symbolic direct pointers with offset
>   * - 's' For symbolic direct pointers without offset
> + * - 'T' For backtraced symbolic direct pointers with offset

[ Nit: 'B' might be a better abbreviation for 'backtrace'. ]

	Ingo
