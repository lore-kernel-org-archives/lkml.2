Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030673Ab2CUKJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:09:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:35273 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab2CUKJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:09:43 -0400
Date: Wed, 21 Mar 2012 11:09:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sasikantha babu <sasikanth.v19@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] setitimer : Return -EFAULT if the user pointer
 "value" is NULL
In-Reply-To: <1332255115-13036-1-git-send-email-sasikanth.v19@gmail.com>
Message-ID: <alpine.LFD.2.02.1203201812260.2542@ionos>
References: <1332255115-13036-1-git-send-email-sasikanth.v19@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012, Sasikantha babu wrote:

> Return -EFAULT if user  pointer "value" is  NULL.

In principle I agree, though this might break exisiting user space as
this behaviour has been there since Linux 1.1.52

So the right thing to do is to add a WARN_ONCE() in the else path and
schedule the removal of this "feature" for v3.6

> diff --git a/kernel/itimer.c b/kernel/itimer.c
> index 22000c3..f356bdf 100644
> --- a/kernel/itimer.c
> +++ b/kernel/itimer.c
> @@ -279,19 +279,18 @@ SYSCALL_DEFINE3(setitimer, int, which, struct itimerval __user *, value,
>  		struct itimerval __user *, ovalue)
>  {
>  	struct itimerval set_buffer, get_buffer;
> -	int error;
> +	int error = -EFAULT;

Instead of ripping the whole thing apart, it's way simpler to just do

	if (!value)
		return -EFAULT;

Thanks,

	tglx
