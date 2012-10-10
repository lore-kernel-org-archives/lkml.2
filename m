Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2JJUqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:46:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2JJUqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:46:47 -0400
Date: Wed, 10 Oct 2012 13:46:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH v2] fix stack memory content leak via UNAME26
Message-Id: <20121010134646.4e9bba55.akpm@linux-foundation.org>
In-Reply-To: <20121009225401.GA10219@www.outflux.net>
References: <20121009225401.GA10219@www.outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012 15:54:01 -0700
Kees Cook <keescook@chromium.org> wrote:

> Calling uname() with the UNAME26 personality set allows a leak of kernel
> stack contents. This fixes it by initializing the stack buffer to zero,
> defensively calculating the length of copy_to_user() call, and making
> the len argument unsigned.
> 
> ...
>
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1265,13 +1265,13 @@ DECLARE_RWSEM(uts_sem);
>   * Work around broken programs that cannot handle "Linux 3.0".
>   * Instead we map 3.x to 2.6.40+x, so e.g. 3.0 would be 2.6.40
>   */
> -static int override_release(char __user *release, int len)
> +static int override_release(char __user *release, size_t len)
>  {
>  	int ret = 0;
> -	char buf[65];
>  
>  	if (current->personality & UNAME26) {
> -		char *rest = UTS_RELEASE;
> +		const char *rest = UTS_RELEASE;
> +		char buf[65] = { 0 };
>  		int ndots = 0;
>  		unsigned v;
>  
> @@ -1283,7 +1283,9 @@ static int override_release(char __user *release, int len)
>  			rest++;
>  		}
>  		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
> -		snprintf(buf, len, "2.6.%u%s", v, rest);
> +		snprintf(buf, sizeof(buf), "2.6.%u%s", v, rest);
> +		if (sizeof(buf) < len)
> +			len = sizeof(buf);
>  		ret = copy_to_user(release, buf, len);
>  	}
>  	return ret;

This looks unecessarily complicated.  Is there a reason to be copying
all 65 bytes out to userspace?

If not, then couldn't we just do

	len = scnprintf(...);
	ret = copy_to_user(..., len + 1);

?

(This code is application #11,493 for the sprintf_user() which we don't have)
