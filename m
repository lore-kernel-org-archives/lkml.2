Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab0KLUJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:09:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756777Ab0KLUJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:09:10 -0500
Date: Fri, 12 Nov 2010 12:08:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: select: fix information leak to userspace
Message-Id: <20101112120834.33062900.akpm@linux-foundation.org>
In-Reply-To: <1289421483-23907-1-git-send-email-segooon@gmail.com>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 23:38:02 +0300
Vasiliy Kulikov <segooon@gmail.com> wrote:

> On some architectures __kernel_suseconds_t is int.

On sparc and parisc.  On all other architectures this patch is a waste
of cycles.

>  On these archs
> struct timeval has padding bytes at the end.  This struct is copied to
> userspace with these padding bytes uninitialized.  This leads to leaking
> of contents of kernel stack memory.
> 
> This bug was added with v2.6.27-rc5-286-gb773ad4.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  fs/select.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/select.c b/fs/select.c
> index b7b10aa..32cf018 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -306,6 +306,7 @@ static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
>  		rts.tv_sec = rts.tv_nsec = 0;
>  
>  	if (timeval) {
> +		memset(&rtv, 0, sizeof(rtv));
>  		rtv.tv_sec = rts.tv_sec;
>  		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;

How about this?

--- a/fs/select.c~fs-select-fix-information-leak-to-userspace-fix
+++ a/fs/select.c
@@ -306,7 +306,8 @@ static int poll_select_copy_remaining(st
 		rts.tv_sec = rts.tv_nsec = 0;
 
 	if (timeval) {
-		memset(&rtv, 0, sizeof(rtv));
+		if (sizeof(rtv) > sizeof(rtv.tv_sec) + sizeof(rtv.tv_usec))
+			memset(&rtv, 0, sizeof(rtv));
 		rtv.tv_sec = rts.tv_sec;
 		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
 
_


The `if' gets eliminated at compile time.  With this approach we add
four bytes of text to the sparc64 build and zero bytes of text to the
x86_64 build.


