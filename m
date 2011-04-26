Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1DZUHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:07:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389Ab1DZUHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:07:32 -0400
Date: Tue, 26 Apr 2011 13:07:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Subject: Re: (resend) [PATCH] vmscan,memcg: memcg aware swap token
Message-Id: <20110426130724.f2ae18e3.akpm@linux-foundation.org>
In-Reply-To: <20110426170146.F396.A69D9226@jp.fujitsu.com>
References: <20110426170146.F396.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 16:59:19 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> @@ -75,3 +76,19 @@ void __put_swap_token(struct mm_struct *mm)
>  		swap_token_mm = NULL;
>  	spin_unlock(&swap_token_lock);
>  }
> +
> +int has_swap_token_memcg(struct mm_struct *mm, struct mem_cgroup *memcg)
> +{
> +	if (memcg) {
> +		struct mem_cgroup *swap_token_memcg;
> +
> +		/*
> +		 * memcgroup reclaim can disable swap token only if token task
> +		 * is in the same cgroup.
> +		 */
> +		swap_token_memcg = try_get_mem_cgroup_from_mm(swap_token_mm);
> +		return ((mm == swap_token_mm) && (memcg == swap_token_memcg));
> +	} else
> +		return (mm == swap_token_mm);
> +}

Seems to be missing a css_put()?

Either I'm mistaken or that's a bug.  Perhaps neither of these would
have happened if we'd bothered to document
try_get_mem_cgroup_from_mm().

