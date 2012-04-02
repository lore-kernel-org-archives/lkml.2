Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2DBQNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:13:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45865 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2DBQNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <1a022e3f1be11730bd8747b1af96a0274bf6356e.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
	<1333102459-23750-1-git-send-email-lenb@kernel.org>
	<1a022e3f1be11730bd8747b1af96a0274bf6356e.1333101989.git.len.brown@intel.com>
Date: Mon, 2 Apr 2012 09:13:46 -0700
Message-ID: <CA+8MBbLROfbyfAGZ0xn1tZVHsndeTUNrn=-gHhsfzkocBLh=iQ@mail.gmail.com>
Subject: Re: [PATCH 58/76] idle, x86: Allow off-lined CPU to enter deeper C states
From: Tony Luck <tony.luck@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 3:14 AM, Len Brown <lenb@kernel.org> wrote:
> From: Boris Ostrovsky <boris.ostrovsky@amd.com>

This bit breaks ia64 build:

> +
> +/**
> + * acpi_idle_play_dead - enters an ACPI state for long-term idle (i.e. off-lining)
> + * @dev: the target CPU
> + * @index: the index of suggested state
> + */
> +static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
> +{
> +       struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
> +       struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
> +
> +       ACPI_FLUSH_CPU_CACHE();
> +
> +       while (1) {
> +
> +               if (cx->entry_method == ACPI_CSTATE_HALT)
> +                       halt();
> +               else if (cx->entry_method == ACPI_CSTATE_SYSTEMIO) {
> +                       inb(cx->address);
> +                       /* See comment in acpi_idle_do_entry() */
> +                       inl(acpi_gbl_FADT.xpm_timer_block.address);
> +               } else
> +                       return -ENODEV;
> +       }

drivers/acpi/processor_idle.c: In function 'acpi_idle_play_dead':
drivers/acpi/processor_idle.c:789: error: implicit declaration of
function 'halt'

So the initial compiler complaint is just about "halt()" - but those "inb()" and
"inl()" parts don't look very ia64 compatible either.

-Tony
