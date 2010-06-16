Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab0FPLc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 07:32:57 -0400
Received: from science.horizon.com ([71.41.210.146]:13143 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758719Ab0FPLcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 07:32:55 -0400
Date: 16 Jun 2010 07:32:53 -0400
Message-ID: <20100616113253.24017.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: avi@redhat.com, mingo@elte.hu
Subject: Re: [PATCH 0/4] Really lazy fpu
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, npiggin@suse.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But on busy servers where most wakeups are IRQ based the chance of being on 
> the right CPU is 1/nr_cpus - i.e. decreasing with every new generation of 
> CPUs.

That doesn't seem right.  If the server is busy with FPU-using tasks, then
the FPU state has already been swapped out, and no IPI is necessary.

The worst-case seems to be a lot of non-FPU CPU hogs, and a few FPU-using tasks
that get bounced around the CPUs like pinballs.

It is an explicit scheduler goal to keep tasks on the same CPU across
schedules, so they get to re-use their cache state.  The IPI only happens
when that goal is not met, *and* the FPU state has not been forced out
by another FPU-using task.

Not completely trivial to arrange.


(An halfway version of this optimization whoch sould avoid the need for
an IPI would be *save* the FPU state, but mark it "clean", so the re-load
can be skipped if we're lucky.  If the code supported this as well as the
IPI alternative, you could make a heuristic guess at switch-out time
whether to save immediately or hope the odds of needing the IPI are less than
the fxsave/IPI cost ratio.)
