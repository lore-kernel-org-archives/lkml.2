Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab0JNI6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 04:58:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:36762 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0JNI6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 04:58:41 -0400
Subject: Re: [PATCH v3 2/7] sched: accumulate per-cfs_rq cpu usage
From: Peter Zijlstra <peterz@infradead.org>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20101012075109.GC9893@in.ibm.com>
References: <20101012074910.GA9893@in.ibm.com>
	 <20101012075109.GC9893@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Oct 2010 10:57:30 +0200
Message-ID: <1287046650.29097.159.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 13:21 +0530, Bharata B Rao wrote:
> +static u64 tg_request_cfs_quota(struct task_group *tg)
> +{
> +       struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
> +       u64 delta = 0;
> +
> +       if (cfs_b->runtime > 0 || cfs_b->quota == RUNTIME_INF) {
> +               raw_spin_lock(&cfs_b->lock);
> +               /*
> +                * it's possible a bandwidth update has changed the global
> +                * pool.
> +                */
> +               if (cfs_b->quota == RUNTIME_INF)
> +                       delta = sched_cfs_bandwidth_slice();
> +               else {
> +                       delta = min(cfs_b->runtime,
> +                                       sched_cfs_bandwidth_slice());
> +                       cfs_b->runtime -= delta;
> +               }
> +               raw_spin_unlock(&cfs_b->lock);
> +       }
> +       return delta;
> +} 

Since you check cfs_b->quote outside of cfs_b->lock anyway, you might as
well avoid taking the lock in that case and directly return slice.

Also, you possibly evaluate sched_cfs_bandwidth_slice() twice.
