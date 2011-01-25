Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1AYUMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:12:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:50642 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1AYUMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:12:24 -0500
Subject: Re: [PATCH 16/16] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1295985756.15920.33.camel@mothafucka.localdomain>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-17-git-send-email-glommer@redhat.com>
	 <1295893920.28776.468.camel@laptop>
	 <1295895083.15920.9.camel@mothafucka.localdomain>
	 <1295898690.28776.472.camel@laptop>
	 <1295985756.15920.33.camel@mothafucka.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 21:13:06 +0100
Message-ID: <1295986386.28776.1101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 18:02 -0200, Glauber Costa wrote:

> I fail to see how does clock_task influence cpu power.
> If we also have to touch clock_task for better accounting of other
> stuff, it is a separate story.
> But for cpu_power, I really fail. Please enlighten me.

static void update_rq_clock_task(struct rq *rq, s64 delta)
{
        s64 irq_delta;

        irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;

        if (irq_delta > delta)
                irq_delta = delta;

        rq->prev_irq_time += irq_delta;
        delta -= irq_delta;
        rq->clock_task += delta;

        if (irq_delta && sched_feat(NONIRQ_POWER))
                sched_rt_avg_update(rq, irq_delta);
}

its done through that sched_rt_avg_update() (should probably rename
that), it computes a floating average of time not spend on fair tasks.


