Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab1G2NCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:02:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:4222 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362Ab1G2NCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:02:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,287,1309762800"; 
   d="scan'208";a="31803520"
Subject: Re: [PATCH 3/8] vfork: make it killable
From: Matt Fleming <matt.fleming@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110727163254.GC23793@redhat.com>
References: <20110727163159.GA23785@redhat.com>
	 <20110727163254.GC23793@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 14:02:10 +0100
Message-ID: <1311944530.21232.67.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 18:32 +0200, Oleg Nesterov wrote:

[...]
 
>  static long clone_vfork_finish(struct task_struct *child,
>  				struct completion *vfork_done, long pid)
>  {
> -	freezer_do_not_count();
> -	wait_for_completion(vfork_done);
> -	freezer_count();
> +	int killed = wait_for_completion_killable(vfork_done);
> +
> +	if (killed) {
> +		struct completion *steal = xchg(&child->vfork_done, NULL);
> +		/* if we race with complete_vfork_done() we have to wait */
> +		if (unlikely(!steal))
> +			wait_for_completion(vfork_done);
> +
> +		return -EINTR;
> +	}

Hmm.. isn't this inherently racy anyway? Why go to the trouble of trying
to handle this race at all?

