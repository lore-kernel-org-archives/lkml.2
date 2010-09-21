Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab0IUXO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:14:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754822Ab0IUXO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:14:27 -0400
Date: Tue, 21 Sep 2010 16:13:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] printk: Declare printk_ratelimit_state in
 ratelimit.h
Message-Id: <20100921161345.cc89e283.akpm@linux-foundation.org>
In-Reply-To: <1284825182-32588-5-git-send-email-namhyung@gmail.com>
References: <1284825182-32588-1-git-send-email-namhyung@gmail.com>
	<1284825182-32588-5-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Sep 2010 00:53:02 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> Adding declaration of printk_ratelimit_state in ratelimit.h removes
> potential build breakage and following sparse warning:
> 
>  kernel/printk.c:1426:1: warning: symbol 'printk_ratelimit_state' was not declared. Should it be static?
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  include/linux/ratelimit.h |    4 ++++
>  kernel/sysctl.c           |    2 --
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
> index 8f69d09..55e1bbc 100644
> --- a/include/linux/ratelimit.h
> +++ b/include/linux/ratelimit.h
> @@ -36,6 +36,10 @@ static inline void ratelimit_state_init(struct ratelimit_state *rs,
>  	rs->begin = 0;
>  }
>  
> +#ifdef CONFIG_PRINTK
> +extern struct ratelimit_state printk_ratelimit_state;
> +#endif
> +

We don't actually need the ifdefs there.

If we remove them then it adds a risk that someone will discover their
error at link-timer rather than at compile-time.  On the other hand,
removing the ifdefs deuglifies the code for everyone, for ever. 
Personally I prefer to not have the ifdefs.

--- a/include/linux/ratelimit.h~printk-declare-printk_ratelimit_state-in-ratelimith-fix
+++ a/include/linux/ratelimit.h
@@ -36,9 +36,7 @@ static inline void ratelimit_state_init(
 	rs->begin = 0;
 }
 
-#ifdef CONFIG_PRINTK
 extern struct ratelimit_state printk_ratelimit_state;
-#endif
 
 extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define __ratelimit(state) ___ratelimit(state, __func__)
diff -puN kernel/sysctl.c~printk-declare-printk_ratelimit_state-in-ratelimith-fix kernel/sysctl.c
_


