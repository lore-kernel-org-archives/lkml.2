Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386Ab2CNR6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:58:15 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41274 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761183Ab2CNR6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:58:14 -0400
MIME-Version: 1.0
In-Reply-To: <1331709454-27966-1-git-send-email-daniel@numascale-asia.com>
References: <1331680589.18900.76.camel@sbsiddha-desk.sc.intel.com>
	<1331709454-27966-1-git-send-email-daniel@numascale-asia.com>
Date: Wed, 14 Mar 2012 10:58:13 -0700
X-Google-Sender-Auth: pA5UjjRkEBqfuLviQ_u0HmW_ox0
Message-ID: <CAE9FiQX_o8GXqi1A+LTE4pseb81d1Aj5zR49NBvJiyAx24yYfw@mail.gmail.com>
Subject: Re: [PATCH] Move APIC ID validity check into platform APIC code
From: Yinghai Lu <yinghai@kernel.org>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Steffen Persvold <sp@numascale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 12:17 AM, Daniel J Blueman
<daniel@numascale-asia.com> wrote:
> Move APIC ID validity check into platform APIC code, so it can be
> overridden when needed. For NumaChip systems, always trust MADT,
> as it's constructed with high APIC IDs.
>
> Behaviour verifies on standard x86 systems and on NumaChip systems
> with this, and compile-tested with allyesconfig.
>
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> Reviewed-by: Steffen Persvold <sp@numascale.com>
>
> ---
>  arch/x86/include/asm/apic.h           |    6 ++++++
>  arch/x86/kernel/apic/apic_flat_64.c   |    2 ++
>  arch/x86/kernel/apic/apic_noop.c      |    1 +
>  arch/x86/kernel/apic/apic_numachip.c  |   10 +++++++++-
>  arch/x86/kernel/apic/bigsmp_32.c      |    1 +
>  arch/x86/kernel/apic/es7000_32.c      |    2 ++
>  arch/x86/kernel/apic/numaq_32.c       |    1 +
>  arch/x86/kernel/apic/probe_32.c       |    1 +
>  arch/x86/kernel/apic/summit_32.c      |    1 +
>  arch/x86/kernel/apic/x2apic_cluster.c |    1 +
>  arch/x86/kernel/apic/x2apic_phys.c    |    1 +
>  arch/x86/kernel/apic/x2apic_uv_x.c    |    1 +
>  arch/x86/kernel/smpboot.c             |    2 +-
>  13 files changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 3ab9bdd..a9371c9 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -288,6 +288,7 @@ struct apic {
>
>        int (*probe)(void);
>        int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
> +       int (*apic_id_valid)(int apicid);
>        int (*apic_id_registered)(void);
>
>        u32 irq_delivery_mode;
> @@ -532,6 +533,11 @@ static inline unsigned int read_apic_id(void)
>        return apic->get_apic_id(reg);
>  }
>
> +static inline int default_apic_id_valid(int apicid)
> +{
> +       return x2apic_mode || (apicid < 255);
> +}
> +
>  extern void default_setup_apic_routing(void);
>
>  extern struct apic apic_noop;
> diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
> index 8c3cdde..359b689 100644
> --- a/arch/x86/kernel/apic/apic_flat_64.c
> +++ b/arch/x86/kernel/apic/apic_flat_64.c
> @@ -180,6 +180,7 @@ static struct apic apic_flat =  {
>        .name                           = "flat",
>        .probe                          = flat_probe,
>        .acpi_madt_oem_check            = flat_acpi_madt_oem_check,
> +       .apic_id_valid                  = default_apic_id_valid,
>        .apic_id_registered             = flat_apic_id_registered,
>
>        .irq_delivery_mode              = dest_LowestPrio,
> @@ -337,6 +338,7 @@ static struct apic apic_physflat =  {
>        .name                           = "physical flat",
>        .probe                          = physflat_probe,
>        .acpi_madt_oem_check            = physflat_acpi_madt_oem_check,
> +       .apic_id_valid                  = default_apic_id_valid,
>        .apic_id_registered             = flat_apic_id_registered,
>
>        .irq_delivery_mode              = dest_Fixed,
> diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
> index 775b82b..634ae6c 100644
> --- a/arch/x86/kernel/apic/apic_noop.c
> +++ b/arch/x86/kernel/apic/apic_noop.c
> @@ -124,6 +124,7 @@ struct apic apic_noop = {
>        .probe                          = noop_probe,
>        .acpi_madt_oem_check            = NULL,
>
> +       .apic_id_valid                  = default_apic_id_valid,
>        .apic_id_registered             = noop_apic_id_registered,
>
>        .irq_delivery_mode              = dest_LowestPrio,
> diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
> index 09d3d8c..d9ea5f3 100644
> --- a/arch/x86/kernel/apic/apic_numachip.c
> +++ b/arch/x86/kernel/apic/apic_numachip.c
> @@ -56,6 +56,12 @@ static unsigned int read_xapic_id(void)
>        return get_apic_id(apic_read(APIC_ID));
>  }
>
> +static int numachip_apic_id_valid(int apicid)
> +{
> +       /* Trust what bootloader passes in MADT */
> +       return 1;
> +}
> +
>  static int numachip_apic_id_registered(void)
>  {
>        return physid_isset(read_xapic_id(), phys_cpu_present_map);
> @@ -223,10 +229,11 @@ static int __init numachip_system_init(void)
>  }
>  early_initcall(numachip_system_init);
>
> -static int numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
> +static int __cpuinit numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>  {
>        if (!strncmp(oem_id, "NUMASC", 6)) {
>                numachip_system = 1;
> +               setup_force_cpu_cap(X86_FEATURE_X2APIC);
>                return 1;
>        }

can you check if you can update

!cpu_has_x2apic && (apic_id >= 0xff) && enabled

in arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic()

to use some kind of apic_id_valid()

so you could avoid setting that feature bit.

the checking in SRAT could be removed.

Yinghai
