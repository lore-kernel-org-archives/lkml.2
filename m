Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0LHALM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:11:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871Ab0LHALK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:11:10 -0500
Date: Tue, 7 Dec 2010 16:10:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Greg KH <greg@kroah.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC] add BUG_ON_MAPPABLE_NULL macro
Message-Id: <20101207161054.d502fae8.akpm@linux-foundation.org>
In-Reply-To: <1291543563-5655-1-git-send-email-ohad@wizery.com>
References: <1291543563-5655-1-git-send-email-ohad@wizery.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  5 Dec 2010 12:06:03 +0200
Ohad Ben-Cohen <ohad@wizery.com> wrote:

> Introduce BUG_ON_MAPPABLE_NULL in order to eliminate redundant BUG_ON
> code, checking for NULL addresses, on architectures where the zero
> address can never be mapped.
> 
> Originally proposed by Russell King <linux@arm.linux.org.uk>
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
> Compile tested on ARM and x86-64.
> 
> Relevant threads:
> 1. Original proposal by Russell - http://lkml.org/lkml/2010/1/21/238
> 2. Recent discussion - https://lkml.org/lkml/2010/11/26/78
> 
> Notes:
> * Implementation still feels hacky, especially since we don't care about the len param of arch_mmap_check.
> * Just like BUG_ON, this new macro is compiled out on !CONFIG_BUG. We might want to add a CONFIG_BUG commentary, so users will at least be aware of the security implications of compiling this out.
> * To get an (extremely!) rough upper bound of the profit of this macro, I did:
> 
> 1. find . -name '*.[ch]' | xargs sed -i 's/BUG_ON(!/BUG_ON_MAPPABLE_NULL(!/'
> 2. removed some obviously bogus sed hits
> 
> With omap2plus_defconfig, uImage shrank by ~4Kb (obviously this doesn't include the potential gain in modules)
> 

Every time someone sends me a patch with text after the "---", I decide
it was good changelog material and I promote it to above the "---". 
How's about you save us the effort :)

The changelog is a bit vague really, but the code comment explains it
all, and that's a good place to explain things.

> +/**
> + * BUG_ON_MAPPABLE_NULL() - BUG_ON(condition) only if address 0 is mappable
> + * @condition:	condition to check, should contain a NULL check
> + *
> + * In general, NULL dereference Oopses are not desirable, since they take down
> + * the system with them and make the user extremely unhappy. So as a general
> + * rule drivers should avoid dereferencing NULL pointers by doing a simple

s/drivers/code/

> + * check (when appropriate), and just return an error rather than crash.
> + * This way the system, despite having reduced functionality, will just keep
> + * running rather than immediately reboot.
> + *
> + * _Critical_ kernel code, OTOH, that should not (/cannot) keep running when
> + * given an unexpected NULL pointer, should just crash. On some architectures,
> + * a NULL dereference will always reliably produce an Oops. On others, where
> + * the zero address can be mmapped, an Oops is not guaranteed. Relying on
> + * NULL dereference Oopses to happen on these architectures might lead to
> + * data corruptions (system will keep running despite a critical bug and
> + * the results will be horribly undefined). In addition, these situations
> + * can also have security implications - we have seen several privilege
> + * escalation exploits with which an attacker gained full control over the
> + * system due to NULL dereference bugs.

yup.

> + * This macro will BUG_ON if @condition is true on architectures where the zero
> + * address can be mapped. On other architectures, where the zero address
> + * can never be mapped, this macro is compiled out. It only makes sense to
> + * use this macro if @condition contains a NULL check, in order to optimize that
> + * check out on architectures where the zero address can never be mapped.
> + * On such architectures, those checks are not necessary, since the code
> + * itself will reliably reproduce an Oops as soon as the NULL address will
> + * be dereferenced.
> + *
> + * As with BUG_ON, use this macro only if @condition cannot be tolerated.
> + * If proceeding with degraded functionality is an option, it's much
> + * better to just simply check for @condition and return some error code rather
> + * than crash the system.
> + */
> +#define BUG_ON_MAPPABLE_NULL(cond) do { \
> +	if (arch_mmap_check(0, 1, MAP_FIXED) == 0) \
> +		BUG_ON(cond); \
> +} while (0)

- arch_mmap_check() didn't have any documentation.  Please fix?

- arch_mmap_check() is a pretty poor identifier (identifiers which
  include the word "check" are usually poor ones).  Maybe
  arch_address_accessible()?

- I worry about arch_mmap_check().  Is it expected that it will
  perform a runtime check, like probe_kernel_address()?  Spell out the
  expectations, please.

- BUG_ON_MAPPABLE_NULL() will evaluate arch_mmap_check() even if
  CONFIG_BUG=n.  Seems bad, depending on what those unspelled-out
  expectations are!

- BUG_ON_MAPPABLE_NULL() is a mouthful.  I can't immedaitely think of
  anythinjg nicer :(

- Is BUG_ON_MAPPABLE_NULL() really the interface you want?  Or do we
  just want an interface which checks a pointer for nearly-nullness?


