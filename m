Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab2DTXMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:12:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64363 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab2DTXL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120420122120.097464672@linutronix.de>
References: <20120420122120.097464672@linutronix.de>
Date: Fri, 20 Apr 2012 16:11:56 -0700
Message-ID: <CABeCy1Y0HTtVvRC0bqaHbhqpumek+dERTY6EH_qO2neP6U8U_A@mail.gmail.com>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
From: Venki Pallipadi <venki@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 6:05 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Dear all,
>
> I'm working on refactoring the SMP boot and CPU hotplug implementation.
>
> The current code has evolved over time into a conglomerate of
> warts. My main goals are to:
>
>  - reduce the architecture code by moving repeating constructs to the
>   core
>
>  - redesigning the handling of per cpu threads. There is no point to
>   tear down the threads just to create them again.
>
>  - restructuring the notifier facility into a proper tree with
>   dependencies to avoid the gazillion of callbacks and moving
>   setup/teardown code into the context of the upcoming/dying cpu
>
> The motivation behind this work is the cpu hotplug nightmare which we
> are facing in the RT kernel and the requests from several groups
> (e.g. ARM) to make hotplug more lightweight and faster.
>
> This first part moves the idle thread management for non-boot cpus
> into the core. fork_idle() is called in a workqueue as it is
> implemented in a few architectures already. This is necessary when not
> all cpus are brought up by the early boot code as otherwise we would
> take a ref on the user task VM of the thread which brings the cpu up
> via the sysfs interface.
>

I had sent out a patchset that did this cleanup here:
https://lkml.org/lkml/2012/3/6/466

This patchset is clean and more exhaustive than what I had. So,

Acked-by: Venkatesh Pallipadi <venki@google.com>

> This converts all architectures except m32r, mn10300, tile and UM to
> the new core facility. These architecture are calling fork_idle() in
> the very early boot code in smp_prepare_cpus() for unknown reasons.
> I haven't analyzed yet, whether this is on purpose or can be moved
> over to the generic facility. It'd be nice if the responsible maintainers
> could look into that as well.
>
> Thanks,
>
>        tglx
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
