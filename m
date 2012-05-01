Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab2EAVDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 17:03:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2EAVDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 17:03:17 -0400
Date: Tue, 1 May 2012 14:03:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH RESEND] memcg: Free spare array to avoid memory leak
Message-Id: <20120501140314.1d7312fb.akpm@linux-foundation.org>
In-Reply-To: <1334825690-9065-1-git-send-email-handai.szj@taobao.com>
References: <1334825690-9065-1-git-send-email-handai.szj@taobao.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012 16:54:50 +0800
Sha Zhengju <handai.szj@gmail.com> wrote:

> From: Sha Zhengju <handai.szj@taobao.com>
> 
> When the last event is unregistered, there is no need to keep the spare
> array anymore. So free it to avoid memory leak.

How serious is this leak?  Is there any way in which it can be used to
consume unbounded amounts of memory?

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4412,6 +4412,12 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
>  swap_buffers:
>  	/* Swap primary and spare array */
>  	thresholds->spare = thresholds->primary;
> +	/* If all events are unregistered, free the spare array */
> +	if (!new) {
> +		kfree(thresholds->spare);
> +		thresholds->spare = NULL;
> +	}
> +
>  	rcu_assign_pointer(thresholds->primary, new);
>  

The resulting code is really quite convoluted.  Try to read through it
and follow the handling of ->primary and ->spare.  Head spins.

What is the protocol here?  If ->primary is NULL then ->spare must also
be NULL?


I'll apply the patch, although I don't (yet) have sufficient info to
know which kernels it should be applied to.  Perhaps someone could
revisit this code and see if it can be made more straightforward.

