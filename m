Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0HWVTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:19:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965Ab0HWVTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:19:10 -0400
Date: Mon, 23 Aug 2010 14:18:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Roland McGrath <roland@redhat.com>
Subject: Re: [RFC PATCH v3] core_pattern: fix long parameters was truncated
 by core_pattern handler
Message-Id: <20100823141843.f177bf1f.akpm@linux-foundation.org>
In-Reply-To: <1282296958-2427-1-git-send-email-dfeng@redhat.com>
References: <20100803105941.GA2996@hmsreliant.think-freely.org>
	<1282296958-2427-1-git-send-email-dfeng@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 17:35:58 +0800
Xiaotian Feng <dfeng@redhat.com> wrote:

> We met a parameter truncated issue, consider following:
> > echo "|/root/core_pattern_pipe_test %p /usr/libexec/blah-blah-blah \
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
> Changes since v2:
> Introduced generic function cn_printf and make format_corename remember the time
> has been expanded.
> 
> Changes since v1:
> This patch allocates corename at runtime, if the replace doesn't have enough
> memory, expand the corename dynamically.


> +			if (cn->used == cn->size)
> +				if (expand_corename(cn))
> +					goto out_fail;
> +
> +			out_ptr = cn->corename + cn->used;
> +			*out_ptr = *pat_ptr++;
> +			cn->used++;


> -				if (out_ptr == out_end)
> -					goto out;
> -				*out_ptr++ = '%';
> +				if (cn->used == cn->size)
> +					if (expand_corename(cn))
> +						goto out_fail;
> +
> +				out_ptr = cn->corename + cn->used;
> +				*out_ptr = '%';
> +				cn->used++;


> +	out_ptr = cn->corename + cn->used;
> +	if (cn->used == cn->size)
> +		if (expand_corename(cn))
> +			goto out_fail;
> +
> +	out_ptr = cn->corename + cn->used;
>  	*out_ptr = 0;

Quite a bit of code duplication there.  A little helper function which
adds a single char to the output would tidy that up.

However I think that if the % and %% handers are converted to call
cn_printf() then the output is always null-terninated and the third
hunk of code above simply becomes unneeded?

Something like this, although I didn't try very hard.  Just a
suggestion to work with ;)



 fs/exec.c |   63 ++++++++++++++--------------------------------------
 1 file changed, 17 insertions(+), 46 deletions(-)

diff -puN fs/exec.c~core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-fix fs/exec.c
--- a/fs/exec.c~core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-fix
+++ a/fs/exec.c
@@ -1503,89 +1503,66 @@ static int format_corename(struct core_n
 	int ispipe = (*pat_ptr == '|');
 	char *out_ptr;
 	int pid_in_pattern = 0;
+	int err = 0;
 
 	cn->size = CORENAME_MAX_SIZE * atomic_read(&call_count);
 	cn->corename = kmalloc(cn->size, GFP_KERNEL);
 	cn->used = 0;
 
 	if (!cn->corename)
-		goto out_fail;
+		return -ENOMEM;
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
 	while (*pat_ptr) {
 		if (*pat_ptr != '%') {
-			if (cn->used == cn->size)
-				if (expand_corename(cn))
-					goto out_fail;
-
-			out_ptr = cn->corename + cn->used;
-			*out_ptr = *pat_ptr++;
-			cn->used++;
+			err = cn_printf(cn, "%c", *pat_ptr++);
 		} else {
 			switch (*++pat_ptr) {
 			case 0:
 				goto out;
 			/* Double percent, output one percent */
 			case '%':
-				if (cn->used == cn->size)
-					if (expand_corename(cn))
-						goto out_fail;
-
-				out_ptr = cn->corename + cn->used;
-				*out_ptr = '%';
-				cn->used++;
+				err = cn_printf(cn, "%%");
 				break;
 			/* pid */
 			case 'p':
 				pid_in_pattern = 1;
-				if (cn_printf(cn, "%d",
-					      task_tgid_vnr(current)))
-					goto out_fail;
+				err = cn_printf(cn, "%d",
+					      task_tgid_vnr(current));
 				break;
 			/* uid */
 			case 'u':
-				if (cn_printf(cn, "%d", cred->uid))
-					goto out_fail;
+				err = cn_printf(cn, "%d", cred->uid);
 				break;
 			/* gid */
 			case 'g':
-				if (cn_printf(cn, "%d", cred->gid))
-					goto out_fail;
+				err = cn_printf(cn, "%d", cred->gid);
 				break;
 			/* signal that caused the coredump */
 			case 's':
-				if (cn_printf(cn, "%ld", signr))
-					goto out_fail;
+				err = cn_printf(cn, "%ld", signr);
 				break;
 			/* UNIX time of coredump */
 			case 't': {
 				struct timeval tv;
 				do_gettimeofday(&tv);
-				if (cn_printf(cn, "%lu", tv.tv_sec))
-					goto out_fail;
+				err = cn_printf(cn, "%lu", tv.tv_sec);
 				break;
 			}
 			/* hostname */
 			case 'h':
 				down_read(&uts_sem);
-				if (cn_printf(cn, "%s",
-					      utsname()->nodename)) {
-					up_read(&uts_sem);
-					goto out_fail;
-				}
+				err = cn_printf(cn, "%s", utsname()->nodename);
 				up_read(&uts_sem);
 				break;
 			/* executable */
 			case 'e':
-				if (cn_printf(cn, "%s", current->comm))
-					goto out_fail;
+				err = cn_printf(cn, "%s", current->comm);
 				break;
 			/* core limit size */
 			case 'c':
-				if (cn_printf(cn, "%lu",
-					      rlimit(RLIMIT_CORE)))
-					goto out_fail;
+				err = cn_printf(cn, "%lu", rlimit(RLIMIT_CORE));
 				break;
 			default:
 				break;
@@ -1593,6 +1570,10 @@ static int format_corename(struct core_n
 			++pat_ptr;
 		}
 	}
+
+	if (err)
+		return err;
+
 	/* Backward compatibility with core_uses_pid:
 	 *
 	 * If core_pattern does not include a %p (as is the default)
@@ -1603,17 +1584,7 @@ static int format_corename(struct core_n
 			goto out_fail;
 	}
 out:
-	out_ptr = cn->corename + cn->used;
-	if (cn->used == cn->size)
-		if (expand_corename(cn))
-			goto out_fail;
-
-	out_ptr = cn->corename + cn->used;
-	*out_ptr = 0;
 	return ispipe;
-
-out_fail:
-	return -ENOMEM;
 }
 
 static int zap_process(struct task_struct *start, int exit_code)
_

