Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0HXWsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:48:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932381Ab0HXWsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:48:14 -0400
Date: Tue, 24 Aug 2010 15:47:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, nhorman@tuxdriver.com,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH v4] core_pattern: fix long parameters was truncated by
 core_pattern handler
Message-Id: <20100824154745.779ed12b.akpm@linux-foundation.org>
In-Reply-To: <1282642966-2296-1-git-send-email-dfeng@redhat.com>
References: <20100823141843.f177bf1f.akpm@linux-foundation.org>
	<1282642966-2296-1-git-send-email-dfeng@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 17:42:46 +0800
Xiaotian Feng <dfeng@redhat.com> wrote:

> We met a parameter truncated issue, consider following:
> > > echo "|/root/core_pattern_pipe_test %p /usr/libexec/blah-blah-blah \
> %s %c %p %u %g 11 12345678901234567890123456789012345678 %t" > \
> /proc/sys/kernel/core_pattern
> 
> This is okay because the strings is less than CORENAME_MAX_SIZE.
> "cat /proc/sys/kernel/core_pattern" shows the whole string. but
> after we run core_pattern_pipe_test in man page, we found last
> parameter was truncated like below:
>         argc[10]=<12807486>
> 
> The root cause is core_pattern allows % specifiers, which need to be
> replaced during parse time, but the replace may expand the strings
> to larger than CORENAME_MAX_SIZE. So if the last parameter is %
> specifiers, the replace code is using snprintf(out_ptr, out_end - out_ptr, ...),
> this will write out of corename array.
> 
> Changes since v3:
> make handling of single char also uses cn_printf, suggested by Andrew Morton.
> 
> Changes since v2:
> Introduced generic function cn_printf and make format_corename remember the time
> has been expanded, suggested by Olg Nesterov and Neil Horman.
> 
> Changes since v1:
> This patch allocates corename at runtime, if the replace doesn't have enough
> memory, expand the corename dynamically, suggested by Neil Horman.
> 
> I've tested with some core_pattern strings, it works fine now.

cool, thanks.

> 
> ...
>
> -static int format_corename(char *corename, long signr)
> +static int format_corename(struct core_name *cn, long signr)
>  {
>  	const struct cred *cred = current_cred();
>  	const char *pat_ptr = core_pattern;
>  	int ispipe = (*pat_ptr == '|');
> -	char *out_ptr = corename;
> -	char *const out_end = corename + CORENAME_MAX_SIZE;
> -	int rc;
>  	int pid_in_pattern = 0;
> +	int err = 0;
> +
> +	cn->size = CORENAME_MAX_SIZE * atomic_read(&call_count);
> +	cn->corename = kmalloc(cn->size, GFP_KERNEL);
> +	cn->used = 0;
> +
> +	if (!cn->corename)
> +		return -ENOMEM;
>  
>  	/* Repeat as long as we have more pattern to process and more output
>  	   space */
>  	while (*pat_ptr) {
>  		if (*pat_ptr != '%') {
> -			if (out_ptr == out_end)
> -				goto out;
> -			*out_ptr++ = *pat_ptr++;
> +			err = cn_printf(cn, "%c", *pat_ptr++);
>  		} else {
>  			switch (*++pat_ptr) {
> +			/* single % at the end, drop that */
>  			case 0:
> +				err = cn_printf(cn, "%c", '\0');

Confused.  Doesn't this bit just add another \0 to the end of an
already-null-terminated string?  And then make cn->used get out of sync
with strlen(cn->corename)?

