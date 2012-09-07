Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2IGQ4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:56:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:38827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2IGQ4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:56:34 -0400
Message-ID: <1347036987.2124.3.camel@twins>
Subject: Re: [PATCH] perf, ibs: Check syscall attribute flags
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Sep 2012 18:56:27 +0200
In-Reply-To: <20120907164114.GJ8285@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
	 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
	 <20120906190238.GA29278@erda.amd.com> <5048F6BF.70106@gmail.com>
	 <20120906195645.GD8285@erda.amd.com> <20120907164114.GJ8285@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 18:41 +0200, Robert Richter wrote:
> From 1d037614edef576da441936bd8c917d31f57b179 Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Wed, 25 Jul 2012 19:12:45 +0200
> Subject: [PATCH] perf, ibs: Check syscall attribute flags
> 
> Current implementation simply ignores attribute flags. Thus, there is
> no notification to userland of unsupported features. Check syscall's
> attribute flags to let userland know if a feature is supported by the
> kernel. This is also needed to distinguish between future kernels what
> might support a feature.
> 
> Cc: <stable@vger.kernel.org> v3.5..
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_event_amd_ibs.c |   11 +++++++++++
>  include/linux/perf_event.h               |    2 ++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
> index 7bfb5be..0456061 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
> @@ -215,6 +215,14 @@ static int perf_ibs_init(struct perf_event *event)
>         struct perf_ibs *perf_ibs;
>         u64 max_cnt, config;
>         int ret;
> +       struct perf_event_attr notsupp = {

static const ?

> +               .exclude_user   = 1,
> +               .exclude_kernel = 1,
> +               .exclude_hv     = 1,
> +               .exclude_idle   = 1,
> +               .exclude_host   = 1,
> +               .exclude_guest  = 1,

Ideally we'd grow support for those using SVM entry/exit hooks though.

> +       };
>  
>         perf_ibs = get_ibs_pmu(event->attr.type);
>         if (perf_ibs) {
> @@ -229,6 +237,9 @@ static int perf_ibs_init(struct perf_event *event)
>         if (event->pmu != &perf_ibs->pmu)
>                 return -ENOENT;
>  
> +       if (perf_flags(&event->attr) & perf_flags(&notsupp))
> +               return -EINVAL;
> +
>         if (config & ~perf_ibs->config_mask)
>                 return -EINVAL;
>  
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 28f9cee..c36a04f 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -304,6 +304,8 @@ struct perf_event_attr {
>         __u32   __reserved_2;
>  };
>  
> +#define perf_flags(attr)       (*(&(attr)->read_format + 1))


Another anonymous union shouldn't hurt..

---
 include/linux/perf_event.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cc5e2cd..5df37a0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -236,7 +236,9 @@ struct perf_event_attr {
 	__u64			sample_type;
 	__u64			read_format;
 
-	__u64			disabled       :  1, /* off by default        */
+	union {
+		__u64		flags;
+		__u64		disabled       :  1, /* off by default        */
 				inherit	       :  1, /* children inherit it   */
 				pinned	       :  1, /* must always be on PMU */
 				exclusive      :  1, /* only group on PMU     */
@@ -272,6 +274,7 @@ struct perf_event_attr {
 				exclude_callchain_user   : 1, /* exclude user callchains */
 
 				__reserved_1   : 41;
+	};
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */

