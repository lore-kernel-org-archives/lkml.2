Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab0G2Nbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:31:35 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59210 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab0G2Nbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:31:33 -0400
Date: Thu, 29 Jul 2010 09:31:22 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>
Subject: Re: [RFC PATCH] core_pattern: fix long parameters was truncated by
 core_pattern handler
Message-ID: <20100729130707.GA31154@shamino.rdu.redhat.com>
References: <1280407364-32466-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280407364-32466-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 08:42:44PM +0800, Xiaotian Feng wrote:
> We met a parameter truncated issue, consider following:
> > echo "|/root/core_pattern_pipe_test %p /usr/libexec/blah-blah-blah \
> %s %c %p %u %g %t 11 1234567890123456789012345678901234567890" > \
> /proc/sys/kernel/core_pattern
> 
> This is okay because the strings is less than CORENAME_MAX_SIZE.
> "cat /proc/sys/kernel/core_pattern" shows the whole string. but
> after we run core_pattern_pipe_test in man page, we found last
> parameter was truncated like below:
> 	argc[10]=<12345678901234567890123456789012345678>
> 
> The root cause is core_pattern allows % specifiers, which need to be
> replaced during parse time, but the replace may expand the strings
> to larger than CORENAME_MAX_SIZE.
> 
> This patch expands the size of parsing array, and makes the cursor
> out_end shift when we replace % specifiers.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Roland McGrath <roland@redhat.com>
> ---
Thanks for looking at this, its definately a problem.  I don't think though,
that just extending the size of the corename array to be bigger is really going
to solve the problem, you're just running away from it.  To really fix it what
we should probably do is:
1) Modify the corename argument to format_corename to be char **corename

2) Dynamically allocate an array for corename inside format_corename, of size
CORENAME_MAX_SIZE*n, where n is variable holding the maximum number of times we
had to increment our allocation size in any previous call to format_corename

3) for each iteration through the while (*pat_ptr) loop in format_corename,
check to see if the remaining size can hold the next argument to be parsed.  If
we're going to overrun, use krealloc to extend the size of the array to another
multiple or CORENAME_MAX_SIZE, and increment the variable n in (2) by 1.


That should give us a decent heuristic to determine the size of the corename
array, so that we never overrun.

Regards
Neil

>  fs/exec.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index e19de6a..e67e4b5 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1441,7 +1441,7 @@ EXPORT_SYMBOL(set_binfmt);
>  
>  /* format_corename will inspect the pattern parameter, and output a
>   * name into corename, which must have space for at least
> - * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
> + * CORENAME_MAX_SIZE * 3 bytes because of % specifiers.
>   */
>  static int format_corename(char *corename, long signr)
>  {
> @@ -1449,7 +1449,7 @@ static int format_corename(char *corename, long signr)
>  	const char *pat_ptr = core_pattern;
>  	int ispipe = (*pat_ptr == '|');
>  	char *out_ptr = corename;
> -	char *const out_end = corename + CORENAME_MAX_SIZE;
> +	char *out_end = corename + CORENAME_MAX_SIZE;
>  	int rc;
>  	int pid_in_pattern = 0;
>  
> @@ -1478,6 +1478,7 @@ static int format_corename(char *corename, long signr)
>  				if (rc > out_end - out_ptr)
>  					goto out;
>  				out_ptr += rc;
> +				out_end += rc - 2;
>  				break;
>  			/* uid */
>  			case 'u':
> @@ -1486,6 +1487,7 @@ static int format_corename(char *corename, long signr)
>  				if (rc > out_end - out_ptr)
>  					goto out;
>  				out_ptr += rc;
> +				out_end += rc - 2;
>  				break;
>  			/* gid */
>  			case 'g':
> @@ -1494,6 +1496,7 @@ static int format_corename(char *corename, long signr)
>  				if (rc > out_end - out_ptr)
>  					goto out;
>  				out_ptr += rc;
> +				out_end += rc - 2;
>  				break;
>  			/* signal that caused the coredump */
>  			case 's':
> @@ -1502,6 +1505,7 @@ static int format_corename(char *corename, long signr)
>  				if (rc > out_end - out_ptr)
>  					goto out;
>  				out_ptr += rc;
> +				out_end += rc - 2;
>  				break;
>  			/* UNIX time of coredump */
>  			case 't': {
> @@ -1512,6 +1516,7 @@ static int format_corename(char *corename, long signr)
>  				if (rc > out_end - out_ptr)
>  					goto out;
>  				out_ptr += rc;
> +				out_end += rc - 2;
>  				break;
>  			}
>  			/* hostname */
> @@ -1523,6 +1528,7 @@ static int format_corename(char *corename, long signr)
>  				if (rc > out_end - out_ptr)
>  					goto out;
>  				out_ptr += rc;
> +				out_end += rc - 2;
>  				break;
>  			/* executable */
>  			case 'e':
> @@ -1531,6 +1537,7 @@ static int format_corename(char *corename, long signr)
>  				if (rc > out_end - out_ptr)
>  					goto out;
>  				out_ptr += rc;
> +				out_end += rc - 2;
>  				break;
>  			/* core limit size */
>  			case 'c':
> @@ -1539,6 +1546,7 @@ static int format_corename(char *corename, long signr)
>  				if (rc > out_end - out_ptr)
>  					goto out;
>  				out_ptr += rc;
> +				out_end += rc - 2;
>  				break;
>  			default:
>  				break;
> @@ -1836,7 +1844,7 @@ static int umh_pipe_setup(struct subprocess_info *info)
>  void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  {
>  	struct core_state core_state;
> -	char corename[CORENAME_MAX_SIZE + 1];
> +	char corename[CORENAME_MAX_SIZE * 3];
>  	struct mm_struct *mm = current->mm;
>  	struct linux_binfmt * binfmt;
>  	const struct cred *old_cred;
> -- 
> 1.7.2
> 
> 
