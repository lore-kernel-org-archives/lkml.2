Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab0FAPxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:53:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755601Ab0FAPxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:53:36 -0400
Date: Tue, 1 Jun 2010 08:49:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.35-rc1, patch] fix cpu_chain section mismatch...
In-Reply-To: <AANLkTilnTVvZOw-bIpcKS0VwhlpYWnnxvOevNv67hnga@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006010842350.3637@i5.linux-foundation.org>
References: <AANLkTilnTVvZOw-bIpcKS0VwhlpYWnnxvOevNv67hnga@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Daniel J Blueman wrote:
>
> In 2.6.35-rc1, __cpu_notify access cpu_chain, which shouldn't be
> marked __cpuinitdata (via section mismatch warning).

Hmm. Does this section mismatch go away if you instead mark cpu_notify(), 
__cpu_notify() and cpu_notify_nofail as "inline"? Or alternatively, maybe 
they should all be marked as __ref?

I think the section mismatch started happening when those wrapper 
functions were created, but all the callers seem to be __ref or __cpuinit. 

Or maybe we should just make that variable be non-cpuinitdata like your 
patch suggests.

Does anybody have strong preferences (patch appended for reference)?

		Linus
---
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 8b92539..97d1b42 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -34,7 +34,7 @@ void cpu_maps_update_done(void)
>  	mutex_unlock(&cpu_add_remove_lock);
>  }
> 
> -static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
> +static RAW_NOTIFIER_HEAD(cpu_chain);
> 
>  /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
>   * Should always be manipulated under cpu_add_remove_lock
> -- 
> Daniel J Blueman
> 
