Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0C3EoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 00:44:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44070 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0C3EoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 00:44:06 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-acpi@vger.kernel.org, Iranna D Ankad <iranna.ankad@in.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: [PATCH 12/14] x86 ioapic: Simplify probe_nr_irqs_gsi.
References: <m1r5n2wwah.fsf_-_@fess.ebiederm.org>
	<1269904825-27462-12-git-send-email-ebiederm@xmission.com>
	<86802c441003291916u3381aae7r5cd76c754871421@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 29 Mar 2010 21:43:54 -0700
In-Reply-To: <86802c441003291916u3381aae7r5cd76c754871421@mail.gmail.com> (Yinghai Lu's message of "Mon\, 29 Mar 2010 19\:16\:10 -0700")
Message-ID: <m17houwh9x.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: yinghai@kernel.org, protasnb@gmail.com, garyhade@us.ibm.com, iranna.ankad@in.ibm.com, linux-acpi@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com, len.brown@intel.com, suresh.b.siddha@intel.com, trenn@suse.de, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Mon, Mar 29, 2010 at 4:20 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>>
>> Use the global gsi_end value now that all ioapics have
>> valid gsi numbers instead of a combination of acpi_probe_gsi
>> and walking all of the ioapics and couting their number of
>> entries by hand if acpi_probe_gsi gave us an answer we did
>> not like.
>>
>> This fixes a small bug in probe_nr_irqs_gsi.  Previously
>> acpi_probe_gsi unnecessarily added 1 to the maximum
>> gsi_end value.  gsi_end is already one past the end of
>> the number of gsi's so the additional increment was
>> superfluous.
>>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>>  arch/x86/include/asm/mpspec.h  |    6 ------
>>  arch/x86/kernel/acpi/boot.c    |   23 -----------------------
>>  arch/x86/kernel/apic/io_apic.c |   17 +++--------------
>>  3 files changed, 3 insertions(+), 43 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
>> index 29994f0..c82868e 100644
>> --- a/arch/x86/include/asm/mpspec.h
>> +++ b/arch/x86/include/asm/mpspec.h
>> @@ -105,12 +105,6 @@ extern void mp_config_acpi_legacy_irqs(void);
>>  struct device;
>>  extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
>>                                 int active_high_low);
>> -extern int acpi_probe_gsi(void);
>> -#else /* !CONFIG_ACPI: */
>> -static inline int acpi_probe_gsi(void)
>> -{
>> -       return 0;
>> -}
>>  #endif /* CONFIG_ACPI */
>>
>>  #define PHYSID_ARRAY_SIZE      BITS_TO_LONGS(MAX_APICS)
>> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
>> index 9c48e99..0e514a1 100644
>> --- a/arch/x86/kernel/acpi/boot.c
>> +++ b/arch/x86/kernel/acpi/boot.c
>> @@ -875,29 +875,6 @@ static int __init acpi_parse_madt_lapic_entries(void)
>>  extern int es7000_plat;
>>  #endif
>>
>> -int __init acpi_probe_gsi(void)
>> -{
>> -       int idx;
>> -       int gsi;
>> -       int max_gsi = 0;
>> -
>> -       if (acpi_disabled)
>> -               return 0;
>> -
>> -       if (!acpi_ioapic)
>> -               return 0;
>> -
>> -       max_gsi = 0;
>> -       for (idx = 0; idx < nr_ioapics; idx++) {
>> -               gsi = mp_gsi_routing[idx].gsi_end;
>> -
>> -               if (gsi > max_gsi)
>> -                       max_gsi = gsi;
>> -       }
>> -
>> -       return max_gsi + 1;
>> -}
>> -
>>  static void assign_to_mp_irq(struct mpc_intsrc *m,
>>                                    struct mpc_intsrc *mp_irq)
>>  {
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index 996cf8f..b57b7a3 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -3837,22 +3837,11 @@ int __init io_apic_get_redir_entries (int ioapic)
>>
>>  void __init probe_nr_irqs_gsi(void)
>>  {
>> -       int nr = 0;
>> +       int nr;
>>
>> -       nr = acpi_probe_gsi();
>> -       if (nr > nr_irqs_gsi) {
>> +       nr = gsi_end;
>
> you may need +1 here

As documented in my comment that extra +1 has every appearance of a
bug.  Nothing is at gsi_end.  gsi_end is already at 1 past the last in
use gsi.  Therefore an extra +1 puts us two past the end for no
apparent reason.

Eric
