Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1EFHyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:54:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48845 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab1EFHyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:54:17 -0400
Date: Fri, 6 May 2011 09:54:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Kaywinnit L. Frye" <kaywinnit.lee.frye.2497@gmail.com>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Subject: Re: [PATCH] wait: include linux/sched.h
Message-ID: <20110506075408.GI23166@elte.hu>
References: <1304372042-12098-1-git-send-email-kaywinnit.lee.frye.2497@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304372042-12098-1-git-send-email-kaywinnit.lee.frye.2497@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kaywinnit L. Frye <kaywinnit.lee.frye.2497@gmail.com> wrote:

> signal_pending(), schedule*() and TASK_* are used in various macros in
> wait.h and all defined in linux/sched.h
> 
> Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Kaywinnit L. Frye <kaywinnit.lee.frye.2497@gmail.com>
> ---
>  include/linux/wait.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index 3efc9f3..667a3d7 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -22,6 +22,7 @@
>  #include <linux/list.h>
>  #include <linux/stddef.h>
>  #include <linux/spinlock.h>
> +#include <linux/sched.h>
>  #include <asm/system.h>
>  #include <asm/current.h>

I'm quite sure this will break the build all around the place, because sched.h 
itself uses wait.h primitives.

To fix these super-headers like sched.h and to make wait.h self-sufficient the 
right and cleanest approach would be to split data types and primitive accessor 
functions from higher level helper methods (which inevitably mix different 
domains) and put them into two separate files.

We have a few such split files in the kernel tree, spinlock_types.h and 
spinlock_api.h, and this concept works reasonably well.

So here we'd need wait_types.h and wait_api.h and of course sched_types.h and 
sched_api.h.

For simplicity of migration wait_api.h could be wait.h itself and sched_api.h 
could be sched.h itself.

That way we'd stop the exponential explosion of header file inter-dependencies 
at its source and would create a clean hierarchy of data types (the *_types.h 
files, which never include *_api.h files), plus the real *_api.h files that .c 
files would use.

As a result we'd probably have faster build times and we could also remove a 
lot of CPP macro hell which is currently used to work around dependency 
spaghetti bugs.

Thanks,

	Ingo
