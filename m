Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab1IHAHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:07:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756742Ab1IHAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:07:06 -0400
Date: Wed, 7 Sep 2011 17:06:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Mark Salter <msalter@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [PATCH][REPOST] Check maxlen on strnlen_user usage
Message-Id: <20110907170621.389b1314.akpm@linux-foundation.org>
In-Reply-To: <4E68042A.1050406@gmail.com>
References: <4E68042A.1050406@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Sep 2011 09:54:18 +1000
Ryan Mallon <rmallon@gmail.com> wrote:

> strnlen_user returns the length of the string including the nul 
> terminator. In the case where maxlen is reached strnlen_user returns 
> maxlen + 1. Most callsites already check for this condition. Fix the 
> call to strnlen_user in fs/exec.c to check for the maxlen case.
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 25dcbe5..e19588c 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -481,7 +481,7 @@ static int copy_strings(int argc, struct 
> user_arg_ptr argv,
>   			goto out;
> 
>   		len = strnlen_user(str, MAX_ARG_STRLEN);
> -		if (!len)
> +		if (!len || len>  MAX_ARG_STRLEN)
>   			goto out;
> 
>   		ret = -E2BIG;

The following call to vald_arg_len() already does this?

This change will cause copy_strings() to incorrectly return -EFAULT,
rather than -E2BIG.

Your email client is wordwrapping and space-stuffing the patches, btw.
