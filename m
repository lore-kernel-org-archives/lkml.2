Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0HTJga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:36:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0HTJg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:36:26 -0400
Message-ID: <4C6E4C66.6070202@redhat.com>
Date: Fri, 20 Aug 2010 17:35:34 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Xiaotian Feng <dfeng@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Roland McGrath <roland@redhat.com>
Subject: Re: [RFC PATCH v3] core_pattern: fix long parameters was truncated
 by core_pattern handler
References: <20100803105941.GA2996@hmsreliant.think-freely.org> <1282296167-2263-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1282296167-2263-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 05:22 PM, Xiaotian Feng wrote:
> We met a parameter truncated issue, consider following:
>> echo "|/root/core_pattern_pipe_test %p /usr/libexec/blah-blah-blah \
> %s %c %p %u %g 11 12345678901234567890123456789012345678 %t">  \
> /proc/sys/kernel/core_pattern
>
> This is okay because the strings is less than CORENAME_MAX_SIZE.
> "cat /proc/sys/kernel/core_pattern" shows the whole string. but
> after we run core_pattern_pipe_test in man page, we found last
> parameter was truncated like below:
>          argc[10]=<12807486>
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
>
> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
> Cc: Alexander Viro<viro@zeniv.linux.org.uk>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Cc: Oleg Nesterov<oleg@redhat.com>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Neil Horman<nhorman@tuxdriver.com>
> Cc: Roland McGrath<roland@redhat.com>
> ---
>   fs/exec.c |  181 +++++++++++++++++++++++++++++++++++++++++--------------------
>   1 files changed, 121 insertions(+), 60 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 2d94552..e2fe568 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -65,6 +65,12 @@ char core_pattern[CORENAME_MAX_SIZE] = "core";
>   unsigned int core_pipe_limit;
>   int suid_dumpable = 0;
>
> +struct core_name {
> +	char *corename;
> +	int used, size;
> +};
> +static atomic_t call_count = ATOMIC_INIT(1);
> +
>   /* The maximal length of core_pattern is also specified in sysctl.c */
>
>   static LIST_HEAD(formats);
> @@ -1440,106 +1446,147 @@ void set_binfmt(struct linux_binfmt *new)
>
>   EXPORT_SYMBOL(set_binfmt);
>
> +static int expand_corename(struct core_name *cn)
> +{
> +	char *old_corename = cn->corename;
> +
> +	cn->size = CORENAME_MAX_SIZE * atomic_inc_return(&call_count);
> +	cn->corename = krealloc(old_corename, cn->size, GFP_KERNEL);
> +
> +	if (!cn->corename) {
> +		kfree(old_corename);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static int cn_printf(struct core_name *cn, const char *fmt, ...)
> +{
> +	char *cur;
> +	int need;
> +	int ret;
> +	va_list arg;
> +
> +	cur = cn->corename + cn->used;
> +
> +	va_start(arg, fmt);
> +	need = vsnprintf(NULL, 0, fmt, arg);
> +	va_end(arg);
> +
> +	if (likely(need<  cn->size - cn->used))
> +		goto out_printf;
> +
> +	ret = expand_corename(cn);
> +	if (ret)
> +		goto expand_fail;
> +
> +out_printf:
> +	va_start(arg, fmt);
> +	vsnprintf(cur, need + 1, fmt, arg);
> +	va_end(arg);
> +	cn->used += need;
> +	return 0;
> +
> +expand_fail:
> +	va_end(arg);

oops, this line should be removed, please ignore this mail, I'll send an 
updated patch.

Thanks
Xiaotian
