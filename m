Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab1DHLQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 07:16:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32902 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1DHLQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 07:16:03 -0400
Subject: Re: [PATCH] sched: fix sched-domain avg_load calculation.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ken Chen <kenchen@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20110408002322.3A0D812217F@elm.corp.google.com>
References: <20110408002322.3A0D812217F@elm.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 08 Apr 2011 13:15:50 +0200
Message-ID: <1302261350.9086.120.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 17:23 -0700, Ken Chen wrote:
> In function find_busiest_group(), the sched-domain avg_load isn't
> calculated at all if there is a group imbalance within the domain.
> This will cause erroneous imbalance calculation.  The reason is
> that calculate_imbalance() sees sds->avg_load = 0 and it will dump
> entire sds->max_load into imbalance variable, which is used later
> on to migrate entire load from busiest CPU to the puller CPU. It
> has two really bad effect:
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
> The fix is to have kernel calculate domain avg_load in both cases.
> This will ensure that imbalance calculation is always sensible and
> the target is usually half way between busiest and puller CPU.

Indeed so, it looks like I broke that in 866ab43efd32. Out of curiosity,
what kind of workload did you observe this on?

