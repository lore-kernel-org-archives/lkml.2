Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1AaMZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:25:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46050 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1AaMZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:25:17 -0500
Date: Mon, 31 Jan 2011 13:24:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>
Cc: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2] x86, acpi: Handle xapic/x2apic entries in MADT at
 same time
Message-ID: <20110131122447.GA30149@elte.hu>
References: <4D423360.6080408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D423360.6080408@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> One system have mixing xapic and x2apic entries in MADT and SRAT.
> BIOS guys insist that ACPI 4.0 SPEC said so, if apic id < 255, even
> the cpus are with x2apic mode pre-enabled, still need to use xapic entries
> instead of x2apic entries.
> 
> on 8 socket system with x2apic pre-enabled, will get out of order sequence:
> CPU0: socket0, core0, thread0.
> CPU1 - CPU 40: socket 4 - socket 7, thread 0
> CPU41 - CPU 80: socket 4 - socket 7, thread 1
> CPU81 - CPU 119: socket 0 - socket 3, thread 0
> CPU120 - CPU 159: socket 0 - socket 3, thread 1
> 
> so max_cpus=80 will not get all thread0 now.
> 
> Need to handle every entry in MADT at same time with xapic and x2apic.
> so we can honor sequence in MADT.
> 
> We can use max_cpus= command line to use thread0 in every core,
> because recent MADT always have all thread0 at first.
> Also it could make the cpu to node mapping more sane.
> 
> after patch will get
> CPU0 - CPU 79: socket 0 - socket 7, thread 0
> CPU80 - CPU 159: socket 0 - socket 7, thread 1
> 
> -v2: update some comments, and change to pass array pointer.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/acpi/boot.c |   30 ++++++++++++++++-------
>  drivers/acpi/numa.c         |   16 +++++++++---
>  drivers/acpi/tables.c       |   57 +++++++++++++++++++++++++++++++++-----------
>  include/linux/acpi.h        |    9 ++++++
>  4 files changed, 86 insertions(+), 26 deletions(-)

Seems useful - we can queue it up and can get it tested in the x86 tree if Len acks 
the principle and the ACPI approach.

Thanks,

	Ingo
