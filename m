Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1EPKdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:33:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:54790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab1EPKdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:33:23 -0400
Subject: Re: [patch 06/15] sched: accumulate per-cfs_rq cpu usage and
 charge against bandwidth
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110503092904.985285812@google.com>
References: <20110503092846.022272244@google.com>
	 <20110503092904.985285812@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 May 2011 12:32:59 +0200
Message-ID: <1305541979.2466.4119.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
>  static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int
> overrun)
>  {
> -       return 1;
> +       u64 quota, runtime = 0;
> +       int idle = 0;
> +
> +       raw_spin_lock(&cfs_b->lock);
> +       quota = cfs_b->quota;
> +
> +       if (quota != RUNTIME_INF) {
> +               runtime = quota;
> +               cfs_b->runtime = runtime;
> +
> +               idle = cfs_b->idle;
> +               cfs_b->idle = 1;
> +       }
> +       raw_spin_unlock(&cfs_b->lock);
> +
> +       return idle;
>  } 

Shouldn't that also return 'idle' when quota is INF? No point in keeping
that timer ticking when there's no actual accounting anymore.
