Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450Ab2EKSmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:42:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37390 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab2EKSmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:42:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205111352330.3231@ionos>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
	<1336666614-21090-5-git-send-email-fenghua.yu@intel.com>
	<alpine.LFD.2.02.1205111352330.3231@ionos>
Date: Fri, 11 May 2012 11:42:18 -0700
X-Google-Sender-Auth: Xj8QClfHXiEQzgbBU6FON-uOknU
Message-ID: <CA+8MBbJbEWTR2Tawa2SzcJ-mZSPzZ12a9usR5eQu=PhArZwXLA@mail.gmail.com>
Subject: Re: [PATCH v6 04/12] x86/smpboot.c: Don't offline CPU0 if any irq can
 not be migrated out of it and remove CPU0 check in smp_callin()
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 5:05 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> +     if (cpuid == 0)
>> +             identify_boot_cpu_online();
>
> No, this is not how we do things.
>
> If this is required, then hell we do it at boot time and not at a
> random place in the cpu hotplug code.

Open to better suggestions for placement.  Sometimes we do need
special cases because on x86 the system isn't symmetrical, cpu0
really is treated differently by h/w and f/w and we have to live with this.
Biggest code impact of that is the extra code to bring cpu0 back online
using NMI instead of INIT. We can't use INIT because if cpu0 gets one,
it just resets the whole machine :-(  But obviously we'd like to avoid
special cases where there is a sane way to do so.

> This is as fricking wrong as it gets. We already know that at boot
> time when we initialize the irq chips. There is no need to iterate
> over the whole irq descriptors just to figure that out.

We *knew* it at boot time ... but that information will be stale if
we hot plugged new devices and bound their interrupts to cpu0.

Do we need to maintain some parallel table of this information, or
is there a better way to check this?

-Tony
