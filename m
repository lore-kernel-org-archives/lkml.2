Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1ACVT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:19:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab1ACVTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:19:25 -0500
Date: Mon, 3 Jan 2011 13:19:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] compat: fix use of an uninitialized variable in
 compat_sys_io_setup()
Message-Id: <20110103131911.c1c2adf6.akpm@linux-foundation.org>
In-Reply-To: <1293182186-23462-1-git-send-email-namhyung@gmail.com>
References: <1293182186-23462-1-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Dec 2010 18:16:26 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> The upper bytes of ctx64 might contain garbages because it was
> set by get_user() which copied only lower 4 bytes as its second
> argument points to. Since sys_io_setup() requires its argumet
> is properly initialized to 0 we should set it explicitly.
> 
> On x86, this was not a problem since its implementation of
> get_user() does a C assignment so that it can fill upper bytes
> with 0's. But other archs that use __get_user_asm() or something
> might have a problem.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> ---
>  fs/compat.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/compat.c b/fs/compat.c
> index 4376e07febbb..b074e9f79148 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -526,7 +526,7 @@ asmlinkage long
>  compat_sys_io_setup(unsigned nr_reqs, u32 __user *ctx32p)
>  {
>  	long ret;
> -	aio_context_t ctx64;
> +	aio_context_t ctx64 = 0;
>  
>  	mm_segment_t oldfs = get_fs();
>  	if (unlikely(get_user(ctx64, ctx32p)))

Well.  What _should_ a get_user(some_u64, some_u32*) do to `some_u64'?

I don't recall it coming up before but I'd say that the sane, expected
and certainly *safe* behaviour would be for the implementation to zero
out the upper 32 bits of `some_u64'.

If that's the rule then those architectures need fixing.  Did you have
any architectures in mind?

