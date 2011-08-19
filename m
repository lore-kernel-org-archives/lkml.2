Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab1HSUbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 16:31:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab1HSUbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 16:31:03 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: tom.leiming@gmail.com
Subject: Re: [PATCH 3/3] trace points: power: remove 'cpu_id' from trace_cpu_idle
Date: Fri, 19 Aug 2011 22:31:01 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: rostedt@goodmis.org, fweisbec@gmail.com, jean.pihet@newoldbits.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com> <1313766244-22313-3-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1313766244-22313-3-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
X-Length: 2008
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201108192231.02665.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 19, 2011 05:04:04 PM tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch removes the 'cpu_id' parameter of the cpu_idle
> trace point, based on the ideas below:
> 
> - the cpu_id which is passed to trace point is always the current
>   cpu
Are you sure this will always be true?

> - the current cpu info has been included into the trace result
>   already
> - smp_processor_id() can't be used safely in preemptible context.

The cpuid has been added to idle events on purpose for example to be 
able to pass C-state dependencies.
2 cores may only enter a deeper sleep state if the 2nd core enters it
as well.
There may be architectures where you could trigger a sleep state on
a foreign cpu.

This may not be used now, but if the kernel does want to use it, you do
not want to adjust a dozen userspace apps.

Not sure how to quickly solve the:
"smp_processor_id() can't be used safely in preemptible context."
problem, though.
A convention could be declared that if -1 is passed, it's the same cpu
entering the sleep state as the running one. This will probably
break userspace apps as well...

Best would be to clean up x86 and let idle routines always be entered
from cpuidle subsystem which knows the cpu id already and eliminate
all idle functions in arch/x86/kernel/process.c.

   Thomas

PS: I do not care about patch 1 and 2 as these events are ARM specific
afaik. But I vote against this one.
