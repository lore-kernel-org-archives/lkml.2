Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab2FQIUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 04:20:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36149 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2FQIUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 04:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXiU_Pz2qZkisF34TBepbRW4iJ4ytLLfiEmuJpCHxUwWvA@mail.gmail.com>
References: <CANQmPXip+fKaSYsKaY5TF3Rax=XFFgyh=+BY61snVsgpReL7RA@mail.gmail.com>
	<1339914285.7349.75.camel@marge.simpson.net>
	<CANQmPXiU_Pz2qZkisF34TBepbRW4iJ4ytLLfiEmuJpCHxUwWvA@mail.gmail.com>
Date: Sun, 17 Jun 2012 16:20:06 +0800
Message-ID: <CANQmPXi=p0WvJ0GofWFSG8Um6trHw3ejwR-TazZyoXm9g-trJQ@mail.gmail.com>
Subject: Re: [PATCH][ANNOUNCE]RIFS-ES Scheduling V1 release.
From: Chen <hi3766691@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 2:24 PM, Mike Galbraith <efault@gmx.de> wrote:
> Destroys may be a bit strong, but it does have it's problems, one being:
> as resource contention increases, so does total sleep.

Sleeper feature(I mean the re-designed sleeper fairness) give too much
resources to the sleep task. They need to wake up with smaller latency
but if they were given too much priority it will be harmful to the
other interactive tasks eg. X. Under high IO load the sleeper fairness
feature can causes music lag or X lag. We can't remove it since there
is no any tuning to turn this off from 2.6.31.

CFS can still be simplified and optimised.

RIFS-ES uses different way to do this.

				if((p->state != TASK_RUNNING) || (p->tick_used >= MAX_TICK_USED)) {
					p->tick_used /= 2;
				}

Here, an cpu intensive task won't be punished too heavy. also this can
improve the wake up latency of 50+% CPU_BOUND tasks.

				if(p->sleep_cnt < MAX_SLEEP_COUNT)
					p->sleep_cnt++;

If a task sleep the sleep_cnt increase.

				#define prio_raisable(p) (	\
					p->prio > ((p->static_prio - reverse(MAX_TICK_USED, p->tick_used)) + \
							(p->sleep_cnt / 3)))
	
Priority of a task that is going to sleep is decided by its time spent
on running. sleep_cnt is the sleep rate of a task.

				if(prio_raisable(p))
					p->prio--;
				if(sleep_jiffy != p->sleep_jiffy)
					p->sleep_cnt /= 2;
				p->sleep_jiffy = sleep_jiffy;

With this, if the sleep rate of a task is low, the sleep rate will be
divide by 2 and it can wake up with a lower latency.
That is the reason why I call this scheduler RIFS-ES.(RIFS and
enhancement of Unix System V scheduling).
