Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0CURgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 13:36:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269Ab0CURgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 13:36:11 -0400
Date: Sun, 21 Mar 2010 10:31:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Peter Zijlstra <peterz@infradead.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression, post-2.6.34-rc1][PATCH] x86 / perf: Fix suspend to
 RAM on HP nx6325
In-Reply-To: <201003202148.01312.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1003211029480.18017@i5.linux-foundation.org>
References: <201003201507.15358.rjw@sisk.pl> <1269106609.9440.529.camel@laptop> <alpine.LFD.2.00.1003201043530.18017@i5.linux-foundation.org> <201003202148.01312.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Mar 2010, Rafael J. Wysocki wrote:
>
> The appended patch fixes the breakage for me too.

Please don't use a 'goto' for something like this.

>  	raw_spin_lock(&amd_nb_lock);
>  
> +	if (!cpuhw->amd_nb)
> +		goto unlock;
> +
>  	if (--cpuhw->amd_nb->refcnt == 0)
>  		kfree(cpuhw->amd_nb);
>  
>  	cpuhw->amd_nb = NULL;
>  
> + unlock:
>  	raw_spin_unlock(&amd_nb_lock);
>  }

Just do

	raw_spin_lock(&amd_nb_lock);
	if (cpuhw->amd_nb) {
		if (!--cpuhw->amd_nb->refcnt)
			kfree(cpuhw->amd_nb);
		cpuhw->amd_nb = NULL;
	}
	raw_spin_unlock(&amd_nb_lock);

instead. Much more readable.

Let's keep 'goto' for cases where we have error returns that we don't want 
to nest, not trivial stuff like this.

		Linus
