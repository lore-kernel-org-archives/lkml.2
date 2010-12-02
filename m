Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab0LBIhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 03:37:20 -0500
Received: from mail.perches.com ([173.55.12.10]:2143 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab0LBIhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 03:37:18 -0500
Subject: Re: [PATCH -v3 1/4] printk, Add pr_pfx for library functions
From: Joe Perches <joe@perches.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1291277105-31758-2-git-send-email-ying.huang@intel.com>
References: <1291277105-31758-1-git-send-email-ying.huang@intel.com>
	 <1291277105-31758-2-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 00:37:15 -0800
Message-ID: <1291279035.1761.58.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 16:05 +0800, Huang Ying wrote:
> For library functions doing printk, the log level and line prefix
> usually need to be specified by the caller. So this patch adds
> "pr_pfx" to make the life of these library functions easier.
[]
> +#define pr_pfx(pfx, fmt, ...) \
> +	printk("%s" fmt, pfx, ##__VA_ARGS__)

I think this would be a very error prone style.

pr_<foo> uses are log levels.

For an casual reader, is pfx a new log level or
is it a prefix or is it both?  I do understand
what you intend.

Mutability of the KERN_<level> is pretty unusual.
Most all of the uses are ?: style

Here are the first uses in each file that has them:
There aren't many.

$ grep -rP -m1 --include=*.[ch] "KERN_[A-Z]+\s*:\s*KERN" *
arch/avr32/mm/fault.c:			       is_global_init(tsk) ? KERN_EMERG : KERN_INFO,
arch/sparc/kernel/traps_64.c:	       (recoverable ? KERN_WARNING : KERN_CRIT), smp_processor_id(),
arch/sparc/mm/fault_64.c:	       task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
arch/sparc/mm/fault_32.c:	       task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
arch/x86/kernel/signal.c:		       task_pid_nr(current) > 1 ? KERN_INFO : KERN_EMERG,
arch/x86/mm/fault.c:		task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
arch/parisc/kernel/traps.c:	level = user ? KERN_DEBUG : KERN_CRIT;
drivers/pci/pcie/aer/aerdrv_errprint.c:		KERN_WARNING : KERN_ERR, dev_driver_string(&pdev->dev),	\
include/linux/arcdevice.h:            		: x < D_DURING ? KERN_INFO : KERN_DEBUG, \
mm/internal.h:		printk(level <= MMINIT_WARNING ? KERN_WARNING : KERN_DEBUG); \
sound/core/misc.c:	const char *pfx = level ? KERN_DEBUG : KERN_DEFAULT;

I don't see why you can't use something like that
with a simpler flag for level.

You also miss a chance to use pr_pfx in ghes_print_estatus:

+       if (__ratelimit(&ratelimit)) {
+               printk(
+       "%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
+       pfx, ghes->generic->header.source_id);
+               apei_estatus_print(pfx, ghes->estatus);
+

ghes_print_estatus is only called with a NULL first argument.
so the code use of pr_pfx seems dubious in any case.


