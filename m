Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1DKLBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 07:01:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:33187 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1DKLBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 07:01:07 -0400
Subject: Re: [tip:sched/urgent] sched: Fix sched-domain avg_load calculation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kenchen@google.com, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-b0432d8f162c7d5d9537b4cb749d44076b76a783@git.kernel.org>
References: <20110408002322.3A0D812217F@elm.corp.google.com>
	 <tip-b0432d8f162c7d5d9537b4cb749d44076b76a783@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Apr 2011 13:00:48 +0200
Message-ID: <1302519648.2388.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 10:46 +0000, tip-bot for Ken Chen wrote:
> Commit-ID:  b0432d8f162c7d5d9537b4cb749d44076b76a783
> Gitweb:     http://git.kernel.org/tip/b0432d8f162c7d5d9537b4cb749d44076b76a783
> Author:     Ken Chen <kenchen@google.com>
> AuthorDate: Thu, 7 Apr 2011 17:23:22 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 11 Apr 2011 11:08:54 +0200
> 
> sched: Fix sched-domain avg_load calculation
> 
> In function find_busiest_group(), the sched-domain avg_load isn't
> calculated at all if there is a group imbalance within the domain. This
> will cause erroneous imbalance calculation.
> 
> The reason is that calculate_imbalance() sees sds->avg_load = 0 and it
> will dump entire sds->max_load into imbalance variable, which is used
> later on to migrate entire load from busiest CPU to the puller CPU.
> 
> This has two really bad effect:
> 
> 1. stampede of task migration, and they won't be able to break out
>    of the bad state because of positive feedback loop: large load
>    delta -> heavier load migration -> larger imbalance and the cycle
>    goes on.
> 
> 2. severe imbalance in CPU queue depth.  This causes really long
>    scheduling latency blip which affects badly on application that
>    has tight latency requirement.
> 
> The fix is to have kernel calculate domain avg_load in both cases. This
> will ensure that imbalance calculation is always sensible and the target
> is usually half way between busiest and puller CPU.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: <stable@kernel.org>
> Link: http://lkml.kernel.org/r/20110408002322.3A0D812217F@elm.corp.google.com
> Signed-off-by: Ingo Molnar <mingo@elte.hu> 

This was caused by 866ab43ef (sched: Fix the group_imb logic) which is
only in .39-rc.
