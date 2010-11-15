Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab0KOCG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 21:06:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932351Ab0KOCG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 21:06:57 -0500
Date: Sun, 14 Nov 2010 18:06:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Message-Id: <20101114180643.593d19ac.akpm@linux-foundation.org>
In-Reply-To: <20101114092533.GB5323@albatros>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com>
	<20101112120834.33062900.akpm@linux-foundation.org>
	<8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
	<20101114092533.GB5323@albatros>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010 12:25:33 +0300 Vasiliy Kulikov <segoon@openwall.com> wrote:

> On some architectures __kernel_suseconds_t is int.  On these archs
> struct timeval has padding bytes at the end.  This struct is copied to
> userspace with these padding bytes uninitialized.  This leads to leaking
> of contents of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Patch v1 used memset(), it was waste of cycles on almost all archs.
> 
>  Compile tested.
> 
>  fs/select.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/select.c b/fs/select.c
> index b7b10aa..43d4805 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -288,7 +288,6 @@ static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
>  				      int timeval, int ret)
>  {
>  	struct timespec rts;
> -	struct timeval rtv;
>  
>  	if (!p)
>  		return ret;
> @@ -306,8 +305,10 @@ static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
>  		rts.tv_sec = rts.tv_nsec = 0;
>  
>  	if (timeval) {
> -		rtv.tv_sec = rts.tv_sec;
> -		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
> +		struct timeval rtv = {
> +			.tv_sec = rts.tv_sec,
> +			.tv_usec = rts.tv_nsec / NSEC_PER_USEC
> +		};
>  
>  		if (!copy_to_user(p, &rtv, sizeof(rtv)))
>  			return ret;

Please check the assembly code - this will still leave four bytes of
uninitalised stack data in 'rtv', surely.

