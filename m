Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab1CRP2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:28:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab1CRP15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:27:57 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=XYJHFtupD_QA:10 a=0yipNvEmL7AA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=Mrj0Ng_IeibfWjPRZbgA:9 a=rwtR-2v25s7Icsd_nzUA:7 a=l2wfqJU3OWXfPH2k_FBT5JmGl3AA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=Ibtw8p6mkMgQSDSW:21 a=TeEtoJJuIGjG1Z4Z:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 18 Mar 2011 11:27:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/2] vsprintf: introduce %pT format specifier
Message-ID: <20110318152754.GI14675@home.goodmis.org>
References: <1300447278-2073-1-git-send-email-namhyung@gmail.com>
 <1300447278-2073-2-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300447278-2073-2-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 08:21:17PM +0900, Namhyung Kim wrote:
> The %pT format specifier is for stack backtrace. Its handler
> sprint_trace() does symbol lookup using (offset-1) to ensure
> the offset will not point outside of the function.
> 
> If there is a tail-call to the function marked "noreturn",
> gcc optimized out the code after the call then causes saved
> return address points outside of the function (i.e. the start
> of the next function), so messes up a call trace entry.
> This patch will fix it.

This looks uselful.

>  kernel/kallsyms.c        |   26 ++++++++++++++++++++++++++
>  lib/vsprintf.c           |    7 ++++++-
>  3 files changed, 39 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> index d8e9b3d1c23c..4964ed2021cc 100644
> --- a/include/linux/kallsyms.h
> +++ b/include/linux/kallsyms.h
> @@ -36,6 +36,7 @@ const char *kallsyms_lookup(unsigned long addr,
> 
>  /* Look up a kernel symbol and return it in a text buffer. */
>  extern int sprint_symbol(char *buffer, unsigned long address);
> +extern int sprint_trace(char *buffer, unsigned long address);
> 
>  /* Look up a kernel symbol and print it to the kernel messages. */
>  extern void __print_symbol(const char *fmt, unsigned long address);
> @@ -79,6 +80,12 @@ static inline int sprint_symbol(char *buffer, unsigned long addr)
>  	return 0;
>  }
> 
> +static inline int sprint_trace(char *buffer, unsigned long addr)
> +{
> +	*buffer = '\0';
> +	return 0;
> +}
> +
>  static inline int lookup_symbol_name(unsigned long addr, char *symname)
>  {
>  	return -ERANGE;
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 6f6d091b5757..2e43200cdc79 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -368,6 +368,32 @@ int sprint_symbol(char *buffer, unsigned long address)
>  }
>  EXPORT_SYMBOL_GPL(sprint_symbol);
>

This desperately needs a comment. Please add a kernel doc style header
to this. (ie.:)

/**
 * sprint_trace - one line description
 * @buffer: what is the buffer
 * @address: what is the address
 *
 * describe why this function exists and how to use it.
 *
 * Returns: what are the return values.
 */

-- Steve

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
> +	else
> +		len += sprintf(buffer, "+%#lx/%#lx", offset, size);
> +
> +	return len;
> +}
> +
>  /* Look up a kernel symbol and print it to the kernel messages. */
>  void __print_symbol(const char *fmt, unsigned long address)
>  {
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index d3023df8477f..c9c56a54cc42 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -574,7 +574,9 @@ char *symbol_string(char *buf, char *end, void *ptr,
>  	unsigned long value = (unsigned long) ptr;
>  #ifdef CONFIG_KALLSYMS
>  	char sym[KSYM_SYMBOL_LEN];
> -	if (ext != 'f' && ext != 's')
> +	if (ext == 'T')
> +		sprint_trace(sym, value);
> +	else if (ext != 'f' && ext != 's')
>  		sprint_symbol(sym, value);
>  	else
>  		kallsyms_lookup(value, NULL, NULL, NULL, sym);
> @@ -949,6 +951,7 @@ int kptr_restrict = 1;
>   * - 'f' For simple symbolic function names without offset
>   * - 'S' For symbolic direct pointers with offset
>   * - 's' For symbolic direct pointers without offset
> + * - 'T' For backtraced symbolic direct pointers with offset
>   * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
>   * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
>   * - 'M' For a 6-byte MAC address, it prints the address in the
> @@ -1008,6 +1011,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  		/* Fallthrough */
>  	case 'S':
>  	case 's':
> +	case 'T':
>  		return symbol_string(buf, end, ptr, spec, *fmt);
>  	case 'R':
>  	case 'r':
> @@ -1279,6 +1283,7 @@ qualifier:
>   * %ps output the name of a text symbol without offset
>   * %pF output the name of a function pointer with its offset
>   * %pf output the name of a function pointer without its offset
> + * %pT output the name of a trace symbol with its offset
>   * %pR output the address range in a struct resource with decoded flags
>   * %pr output the address range in a struct resource with raw flags
>   * %pM output a 6-byte MAC address with colons
> --
> 1.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
