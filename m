Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab1I2Vbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 17:31:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59163 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab1I2Vbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 17:31:32 -0400
Date: Thu, 29 Sep 2011 14:31:29 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kmod: prevent kmod_loop_msg overflow in
 __request_module()
Message-Id: <20110929143129.e7c3c7e2.akpm00@gmail.com>
In-Reply-To: <alpine.LNX.2.00.1109291749000.24692@pobox.suse.cz>
References: <alpine.LNX.2.00.1109291749000.24692@pobox.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 17:50:45 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> Due to post-decrement

(post-increment)

> in condition of kmod_loop_msg in __request_module(),
> the system log can be spammed by much more than 5 instances of the 'runaway
> loop' message if the number of events triggering it makes the kmod_loop_msg
> to overflow.
> 
> Fix that by making sure we never increment it past the threshold.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  kernel/kmod.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index ddc7644..a4bea97 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -114,10 +114,12 @@ int __request_module(bool wait, const char *fmt, ...)
>  	atomic_inc(&kmod_concurrent);
>  	if (atomic_read(&kmod_concurrent) > max_modprobes) {
>  		/* We may be blaming an innocent here, but unlikely */
> -		if (kmod_loop_msg++ < 5)
> +		if (kmod_loop_msg < 5) {
>  			printk(KERN_ERR
>  			       "request_module: runaway loop modprobe %s\n",
>  			       module_name);
> +			kmod_loop_msg++;
> +		}
>  		atomic_dec(&kmod_concurrent);
>  		return -ENOMEM;
>  	}

Well, it will take two billion passes through here to cause the
overflow.  I really hope you found this problem by inspection!

