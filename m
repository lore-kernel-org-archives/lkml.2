Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab0EUUcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 16:32:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494Ab0EUUcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 16:32:09 -0400
Date: Fri, 21 May 2010 13:31:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] ipc: increase IPCMNI_MAX
Message-Id: <20100521133136.d0e282df.akpm@linux-foundation.org>
In-Reply-To: <20100520070741.GI2516@laptop>
References: <20100520065911.GG2516@laptop>
	<20100520070741.GI2516@laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 17:07:41 +1000
Nick Piggin <npiggin@suse.de> wrote:

> Just wondering whether there is a good reason to have a full 16 bits of
> sequence in ipc ids? 32K indexes is pretty easy to overflow, if only in
> stress tests for now. I was doing some big aim7 stress testing, which
> required this patch, but it's not exactly a realistic workload :) 
> 
> But the sequence seems like it just helps slightly with buggy apps, and
> if the app is buggy then it can by definition mess up its own ids
> anyway? So I don't see that such amount of seq is required.
> 
> Index: linux-2.6/ipc/util.h
> ===================================================================
> --- linux-2.6.orig/ipc/util.h
> +++ linux-2.6/ipc/util.h
> @@ -14,7 +14,16 @@
>  #include <linux/err.h>
>  
>  /* IPCMNI_MAX should be <= MAX_INT, absolute limit for ipc arrays */
> -#define IPCMNI_MAX_SHIFT	15
> +/*
> + * IPC ids consist of an index into the idr, which allocates from the bottom
> + * up, and a sequence number which is continually incremented. Valid indexes
> + * are from 0..IPCMNI_MAX (or further constrained by sysctls or other limits).
> + * The sequence number prevents ids from being reused quickly. The sequence
> + * number resides in the top part of the 'int' after IPCMNI_MAX.
> + *
> + * Increasing IPCMNI_MAX reduces the sequence wrap interval.
> + */
> +#define IPCMNI_MAX_SHIFT	20
>  #define IPCMNI_MAX		(1 << IPCMNI_MAX_SHIFT)
>  
>  #define SEQ_SHIFT		IPCMNI_MAX_SHIFT

Some anaylsis of the worst-case memory consumption would be mollifying.

I took the absence of Signed-off-by:'s to mean "rfc" and wandered away.
