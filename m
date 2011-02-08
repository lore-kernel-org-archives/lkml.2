Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab1BHXl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:41:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752924Ab1BHXl0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:41:26 -0500
MIME-Version: 1.0
In-Reply-To: <201102082220.25240.rjw@sisk.pl>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110208122159.GA8284@elte.hu> <201102082218.28015.rjw@sisk.pl> <201102082220.25240.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Feb 2011 15:40:33 -0800
Message-ID: <AANLkTinAZphXC=7FParFnxDPQvpB1ic=FwTe7u4Txy5o@mail.gmail.com>
Subject: Re: [PATCH 1/5] ACPI / PM: Move references to pm_flags into sleep.c
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 1:20 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> If direct references to pm_flags are moved from bus.c to sleep.c,
> CONFIG_ACPI will not need to depend on CONFIG_PM any more.

The patch may _work_, but I really hate it. That function naming is insane:

>  #ifdef CONFIG_ACPI_SLEEP
>  #else
> +static inline bool acpi_pm_enabled(void) { return true; }

acpi_pm_enabled() returns true if ACPI_SLEEP is _not_ enabled? That's
just crazy.

... followed by more crazy:

> +bool acpi_pm_enabled(void)
> +{
> +       if (!(pm_flags & PM_APM)) {
> +               pm_flags |= PM_ACPI;
> +               return true;
> +       }
> +       return false;
> +}

IOW, that function doesn't do anything _remotely_ like what the naming
indicates.

Any sane person would expect that a function called
'acpi_pm_enabled()' would return true if ACPI PM was enabled, and
false otherwise. But it's not what it does at all. Instead, what it
does is to say "if APM isn't enabled, let's enable ACPI and return
true". Except then for the non-ACPI sleep case, we just return true
regardless, which still looks damn odd, wouldn't you say?

That isn't good. Maybe it all does what you want it to do, but from a
code readability standpoint, it's just one honking big "WTF?". Please
don't do that. Call it something else. Make the naming actually follow
what the semantics are. Appropriate naming should also make it
sensible to return "true" when ACPI_SLEEP is disabled, and should make
the caller look sane.

Now, I don't know what that particular naming might be, but maybe it
would be about APM being enabled. Which is what the caller actually
seems to care about and talks about for the failure case. Maybe you
need separate functions for the "is APM enabled" case for the naming
to make sense. Hmm?

                              Linus
