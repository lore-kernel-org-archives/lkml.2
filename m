Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab2DJTLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:11:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759062Ab2DJTLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:11:30 -0400
Date: Tue, 10 Apr 2012 21:10:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2] mm: correctly synchronize rss-counters at exit/exec
Message-ID: <20120410191059.GA5678@redhat.com>
References: <20120409200336.8368.63793.stgit@zurg> <20120410170732.18750.64274.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410170732.18750.64274.stgit@zurg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Konstantin Khlebnikov wrote:
>
> This patch moves sync_mm_rss() into mm_release(), and moves mm_release() out of
> do_exit() and calls it earlier. After mm_release() there should be no page-faults.

Can't prove, but I feel there should be a simpler fix...

Anyway, this patch is not exactly correct.

> @@ -959,9 +959,10 @@ void do_exit(long code)
>  				preempt_count());
>
>  	acct_update_integrals(tsk);
> -	/* sync mm's RSS info before statistics gathering */
> -	if (tsk->mm)
> -		sync_mm_rss(tsk->mm);
> +
> +	/* Release mm and sync mm's RSS info before statistics gathering */
> +	mm_release(tsk, tsk->mm);

This breaks kthread_stop() at least.

The exiting kthread shouldn't do complete_vfork_done() until it
sets ->exit_code.

Oleg.

