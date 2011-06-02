Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1FBVqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:46:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42101 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab1FBVqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:46:44 -0400
MIME-Version: 1.0
Message-ID: <1af7a43d-84fa-47c4-a145-409e5bac585b@default>
Date: Thu, 2 Jun 2011 14:46:23 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] "mustnotsleep"
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090209.4DE804C4.0034:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In development of RAMster, I have frequently been bitten
by indirect use of existing kernel subsystems that
unexpectedly sleep.  As such, I have hacked the
following "debug" code fragments for use where I need to
ensure that doesn't happen.

DEFINE_PER_CPU(int, mustnotsleep_count);

void mustnotsleep_start(void)
{
	int cpu = smp_processor_id();
	per_cpu(mustnotsleep_count, cpu)++;
}

void mustnotsleep_done(void)
{
	int cpu = smp_processor_id();
	per_cpu(mustnotsleep_count, cpu)--;
}

and in schedule.c in schedule():

if (per_cpu(mustnotsleep_count))
	panic("scheduler called in mustnotsleep code");

This has enabled me to start identifying code that
is causing me problems.  (I know this is a horrible
hack, but that's OK right now.)

Rather than panic, an alternative would be for the
scheduler to check mustnotsleep_count and simply
always schedule the same thread (i.e. instantly wake).
I wasn't sure how to do that.

I know this is unusual, but still am wondering if there
is already some existing kernel mechanism for doing this?

Rationalization: Historically, CPUs were king and an OS
was designed to ensure that, if there was any work to do,
kernel code should yield (sleep) to ensure that those
precious CPUs are free to do the work.  With modern many-core
CPUs and inexpensive servers, it is often the case that CPU
availability is no longer the bottleneck, and some other
resource is.

The design of Transcendent Memory ("tmem") makes the
assumption that RAM is the bottleneck and that CPU cycles are
abundant and can be wasted as necessary.  Specifically, tmem
interfaces are assumed to be synchronous... a CPU that is
performing a tmem operation (e.g. in-kernel compression,
access to hypervisor memory, or access to RAM on a different
physical machine) must NOT sleep and so must busy-wait
(in some cases with irqs and bottom-halfs enabled) for events
to occur.

Comments welcome!
Dan

---

Thanks... for the memory!
I really could use more / my throughput's on the floor
The balloon is flat / my swap disk's fat / I've OOM's in store
Overcommitted so much
(with apologies to Bob Hope)

