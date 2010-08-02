Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab0HBNxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:53:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab0HBNx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:53:28 -0400
Date: Mon, 2 Aug 2010 15:50:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Roland McGrath <roland@redhat.com>
Subject: Re: [RFC PATCH V2] core_pattern: fix long parameters was truncated
	by core_pattern handler
Message-ID: <20100802135013.GA5877@redhat.com>
References: <20100729130707.GA31154@shamino.rdu.redhat.com> <1280751836-1826-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280751836-1826-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Xiaotian Feng wrote:
>
> @@ -1466,78 +1496,126 @@ static int format_corename(char *corename, long signr)
>  				goto out;
>  			/* Double percent, output one percent */
>  			case '%':
> -				if (out_ptr == out_end)
> -					goto out;
>  				*out_ptr++ = '%';

Hmm. Not sure I understand why we do not need to check the space here.

> -				rc = snprintf(out_ptr, out_end - out_ptr,
> -					      "%d", task_tgid_vnr(current));
> -				if (rc > out_end - out_ptr)
> -					goto out;
> +				rc = snprintf(NULL, 0, "%d",
> +					      task_tgid_vnr(current));
> +				if (rc > out_end - out_ptr) {
> +					ret = expand_corename(corename,
> +							      &out_end,
> +							      &out_ptr, &size);
> +					if (ret)
> +						return ret;
> +				}
> +				rc = snprintf(out_ptr, rc + 1, "%d",
> +					      task_tgid_vnr(current));

Probably it makes sense to factor out this code?

Roughly, something like:

	struct core_name {
		char *corename;
		int len, free;
	};

	static bool cn_printf(struct core_name *cn, const char *fmt, ...)
	{
		char *cur;
		int need;
		va_list ap;

	retry:
		cur = cn->corename + (cn->len - cn->free);
		need = vsnprintf(cur, cn->free, fmt, ap);

		if (likely(need < free)) {
			free -= need;
			return true;
		}

		increase ->len, realloc ->corename or return false;
		goto retry;

	}


Then format_corename() can just do

	if (!cn_printf(&cn, ...))
		return -ENOMEM;

consistently.



Also. Not sure this really makes sense, but if we ever need to expand the
string, perhaps it makes sense to remeber this fact so that the next time
we start with len > CORENAME_MAX_SIZE. In any case, I think this needs a
separate patch.

Oleg.

