Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1FMS4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:56:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:38184 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FMSz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=yRPmyJjIU5vwi+W5hFhJYj3AGhV8JJ/r0r95mHCfWSwaHnRXDd1t6v4czRc2Ej5UpZ
         grDEmTTD6f63E/NQ+YOA==
MIME-Version: 1.0
In-Reply-To: <201106132037.49009.rjw@sisk.pl>
References: <1307925825-28566-1-git-send-email-ccross@android.com>
	<201106132037.49009.rjw@sisk.pl>
Date: Mon, 13 Jun 2011 11:55:40 -0700
X-Google-Sender-Auth: SFN8_x_JZpjrHwcmMTyCysgZ_jM
Message-ID: <BANLkTi=zTVPkgDO1xXPhypn5Fz6c0PTp79Wq2a6s4jrz3WrJyQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] CPU PM notifiers
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 11:37 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, June 13, 2011, Colin Cross wrote:
>> This patch set tries to address Russell's concerns with platform
>> pm code calling into the driver for every block in the Cortex A9s
>> during idle, hotplug, and suspend.  The first patch adds cpu pm
>> notifiers that can be called by platform code, the second uses
>> the notifier to save and restore the GIC state, and the third
>> saves the VFP state.
>>
>> The notifiers are used for two types of events, CPU PM events and
>> CPU complex PM events.  CPU PM events are used to save and restore
>> per-cpu context when a single CPU is preparing to enter or has
>> just exited a low power state.  For example, the VFP saves the
>> last thread context, and the GIC saves banked CPU registers.
>>
>> CPU complex events are used after all the CPUs in a power domain
>> have been prepared for the low power state.  The GIC uses these
>> events to save global register state.
>>
>> Platforms that call the cpu_pm APIs must select
>> CONFIG_ARCH_USES_CPU_PM
>>
>> L2 cache is not covered by this patch set, as the determination
>> of when the L2 is reset and when it is retained is
>> platform-specific, and most of the APIs necessary are already
>> present.
>>
>>  arch/arm/Kconfig              |    7 ++
>>  arch/arm/common/gic.c         |  212 +++++++++++++++++++++++++++++++++++++++++
>>  arch/arm/include/asm/cpu_pm.h |   54 +++++++++++
>>  arch/arm/kernel/Makefile      |    1 +
>>  arch/arm/kernel/cpu_pm.c      |  181 +++++++++++++++++++++++++++++++++++
>
> Is there any reason why this has to be ARM-specific?  There are other
> architectures where this kind of feature might make sense (SH and
> powerpc at least).

Nothing other than there are currently no adaptations for any drivers
besides ARM, but I can move it somewhere outside ARM.  Any suggestions
where?

> Besides, is there any overlap between this feature and the CPU hotplug
> notifiers?

I don't think so - the hotplug notifiers are used when a CPU is being
removed from the system, so no saving and restoring is necessary - the
CPU will be rebooted from scratch.  They are used by systems outside
the CPU that need to know that a CPU no longer exists.

CPU PM notifiers are used when a CPU is going through reset in a way
that should be transparent to most of the system.  Only drivers within
the CPU itself need a notification.  Note that both ARM drivers I
modified did not have a register_cpu_notifier call.

> Rafael
>
