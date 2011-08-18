Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1HRJiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 05:38:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab1HRJiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 05:38:11 -0400
Date: Thu, 18 Aug 2011 11:38:00 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
Message-ID: <20110818093800.GA2268@redhat.com>
References: <1313650253-21794-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313650253-21794-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 11:50:53PM -0700, Greg Thelen wrote:
> Both mem_cgroup_charge_statistics() and mem_cgroup_move_account() were
> unnecessarily disabling preemption when adjusting per-cpu counters:
>     preempt_disable()
>     __this_cpu_xxx()
>     __this_cpu_yyy()
>     preempt_enable()
> 
> This change does not disable preemption and thus CPU switch is possible
> within these routines.  This does not cause a problem because the total
> of all cpu counters is summed when reporting stats.  Now both
> mem_cgroup_charge_statistics() and mem_cgroup_move_account() look like:
>     this_cpu_xxx()
>     this_cpu_yyy()

Note that on non-x86, these operations themselves actually disable and
reenable preemption each time, so you trade a pair of add and sub on
x86

-	preempt_disable()
	__this_cpu_xxx()
	__this_cpu_yyy()
-	preempt_enable()

with

	preempt_disable()
	__this_cpu_xxx()
+	preempt_enable()
+	preempt_disable()
	__this_cpu_yyy()
	preempt_enable()

everywhere else.
