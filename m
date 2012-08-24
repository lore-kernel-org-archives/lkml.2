Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab2HXCEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:04:52 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39019 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2HXCEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:04:48 -0400
X-AuditID: b753bd60-96163ba000007c38-c7-5036e13e0eb0
X-AuditID: b753bd60-96163ba000007c38-c7-5036e13e0eb0
Message-ID: <5036E13A.6070901@hitachi.com>
Date: Fri, 24 Aug 2012 11:04:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: akhilesh kumar <kumarakhilesh479@gmail.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [Memory Leak] free kprobe before optimized_kprobe free
References: <CAG6PDMa6OR4eqckoUwuHcv7om2j5qsYx9mPx4_Z+Bzr8nxaMLA@mail.gmail.com>
In-Reply-To: <CAG6PDMa6OR4eqckoUwuHcv7om2j5qsYx9mPx4_Z+Bzr8nxaMLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/08/24 2:05), akhilesh kumar wrote:
> From a77438899c7295299b59cdca8d1816ea69d6ed8e Mon Sep 17 00:00:00 2001
> From: Akhilesh Kumar <akhilesh.lxr@gmail.com>
> Date: Fri, 10 Aug 2012 14:02:07 +0530
> Subject:[Memory Leak] free kprobe before optimized_kprobe free
> 
> Free *ap before *op otherwise ap pointer will be Dangling

Nack, since ap == op, this causes double free.

/*
 * Internal structure for direct jump optimized probe
 */
struct optimized_kprobe {
        struct kprobe kp;
        struct list_head list;  /* list for optimizing queue */
        struct arch_optimized_insn optinsn;
};

Please look into alloc_aggr_kprobe() which allocates
optimized_kprobe, and returns op->kp.

Thank you,

> 
> Signed-off-by: Akhilesh Kumar <akhilesh.lxr@gmail.com>
> ---
>  kernel/kprobes.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index c62b854..ff0a97b 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -767,6 +767,7 @@ static __kprobes void
> try_to_optimize_kprobe(struct kprobe *p)
>  	if (!arch_prepared_optinsn(&op->optinsn)) {
>  		/* If failed to setup optimizing, fallback to kprobe */
>  		arch_remove_optimized_kprobe(op);
> +		kfree(ap);
>  		kfree(op);
>  		return;
>  	}
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


