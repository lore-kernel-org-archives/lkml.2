Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2DHF7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:59:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36614 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab2DHF7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:59:05 -0400
Subject: Re: [PATCH] clocksource: Load the ACPI PM clocksource asynchronously
Date: Sun, 08 Apr 2012 05:58:31 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>,
        Arjan van de Ven <arjanvandeven@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <717f591b21b34ebea5793c6206b8a2b8-mfwitten@gmail.com>
In-Reply-To: <20120130205120.652aa64f@infradead.org>
References: <20120130205120.652aa64f@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 20:51:20 -0800, Arjan van de Ven wrote:

> ...
>
> The ACPI clocksource takes quite some time to initialize,
> and this increases the boot time of the kernel for a
> double digit percentage. This while almost all modern
> systems will be using the HPET already anyway.
>
> This patch turns the clocksource loading into an asynchronous
> operation; which means it won't hold up the boot while
> still becoming available normally.
>
> To make this work well, an udelay() had to be turned into an
> usleep_range() so that on UP systems, we yield the CPU to
> regular boot tasks instead of spinning.
>
> ...

This patch became the following commit:

  commit b519508298e0292e1771eecf14aaf67755adc39d
  Author:     Arjan van de Ven <arjan@linux.intel.com>
  AuthorDate: Mon Jan 30 20:23:30 2012 -0800
  Commit:     John Stultz <john.stultz@linaro.org>
  CommitDate: Wed Feb 1 18:39:46 2012 -0800

to which I bisected as the culprit for very strange load balance
behavior on my machine.

With this patch in place, my CPU is constantly being pegged at 100%
(and my CPU monitor sometimes registers NaN%), regardless of the
active governor and under conditions when my computer would normally
be idling quite placidly.

Reverting this commit does indeed remove the problem from previously
problematic builds.

Sincerely,
Michael Witten

Some probably useless information:

  * Dell Latitude D810 (from about 2005/2006)

      * BIOS Version A05

  * /proc/cpuinfo:

      processor       : 0
      vendor_id       : GenuineIntel
      cpu family      : 6
      model           : 13
      model name      : Intel(R) Pentium(R) M processor 2.13GHz
      stepping        : 8
      microcode       : 0x20
      cpu MHz         : 800.000
      cache size      : 2048 KB
      fdiv_bug        : no
      hlt_bug         : no
      f00f_bug        : no
      coma_bug        : no
      fpu             : yes
      fpu_exception   : yes
      cpuid level     : 2
      wp              : yes
      flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx bts est tm2
      bogomips        : 1596.47
      clflush size    : 64
      cache_alignment : 64
      address sizes   : 32 bits physical, 32 bits virtual
      power management:
