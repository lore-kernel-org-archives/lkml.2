Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2C0QW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:22:56 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:46733 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750796Ab2C0QWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:22:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ahGljHkVM1kHOCb_aDqQ8gyXjsm80PesPSVZH8rGwZoQIzw
 rKHFJgQAhKKJXVsT4VestdmCfl859.lFev3eunewEOv0B1kFrsJsqh4SoIC_
 4Ut5n19a8WaLQK.mNh8u1mVGPYibYL0_TXqyxr7SqN9rCEzgA6eYqXdrUaYY
 dKcnouZFURS_MY88NbswBewoassZfTYjhzWPS1rzak.S0LbTyVoy7DRJD4zD
 8Cvf4R4v0aXRH.Gg7_EHTPvv9Fhn3u.ZslbsnuIwAX1P4zE6cdps8aQg8ljR
 GLpJQBPLncH9_jHfJgytbFy6tTU7Rsbv_L9.KwUNN5MhDyP8hx5quPNg51fZ
 dHI6W1u71uFPr3OQ9UqwkniaoRgCTA0ceDbR1XRU_uABhxDt8J8qOw8a3C0f
 2
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 27 Mar 2012 11:22:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
In-Reply-To: <CAOtvUMc5Cx8yv6=CcQ6iJzWC0yhPzp+OsH3aU1VFzWOuaKfcww@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1203271116370.1170@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com> <CAOtvUMf0Zp9C-jT=ymEo6oyxnsgkvSiGDUs5V_56v4Ai2QyBJQ@mail.gmail.com> <CAOtvUMeTHbW3qJRVndhZ4mZ57xG=XGtef_OinZ=wca2n14OTbw@mail.gmail.com>
 <CAOtvUMc5Cx8yv6=CcQ6iJzWC0yhPzp+OsH3aU1VFzWOuaKfcww@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Gilad Ben-Yossef wrote:

> +static void vmstat_update(struct work_struct *w)
> +{
> +	int cpu, this_cpu = smp_processor_id();
> +	int sleepy_cpu_counter = 0;
> +	static spinlock_t lock;
> +
> +	if(spin_trylock(&lock)) {

Trylock would cause cache bouncing between vmstat runs on various
processors. The reason that vmstat_update exists is to avoid these cache
bounces. Please no exclusive cacheline acquisiton by all cpus by default.

The best method would be to assign a sacrifical lamb cpu and check if we
are running on that cpu. That way taking a lock can be avoided.

