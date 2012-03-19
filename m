Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032719Ab2CSTTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:19:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:8225 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759275Ab2CSTTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:19:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="130657059"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>
Subject: RE: [PATCH 2/2] tboot: Add return values for tboot_sleep
Thread-Topic: [PATCH 2/2] tboot: Add return values for tboot_sleep
Thread-Index: AQHM/u+iuJVs8cIq8U2CVrRM2wJEkpZyDIDQ
Date: Mon, 19 Mar 2012 19:19:31 +0000
Message-ID: <9F57BF860713DF4BA3EFA4F8C6DFEDAC46026B2F@ORSMSX101.amr.corp.intel.com>
References: <1331405526-25952-1-git-send-email-konrad.wilk@oracle.com>
 <1331405526-25952-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1331405526-25952-3-git-send-email-konrad.wilk@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Joseph Cihula <joseph.cihula@intel.com>

> -----Original Message-----
> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: Saturday, March 10, 2012 10:52 AM
> To: linux-kernel@vger.kernel.org; x86@kernel.org; tglx@linutronix.de; mingo@redhat.com;
> hpa@zytor.com; linux-acpi@vger.kernel.org; lenb@kernel.org
> Cc: rjw@sisk.pl; Cihula, Joseph; Konrad Rzeszutek Wilk
> Subject: [PATCH 2/2] tboot: Add return values for tboot_sleep
> 
> . as appropiately. As tboot_sleep now returns values.
> remove tboot_sleep_wrapper.
> 
> Suggested-by: "Rafael J. Wysocki" <rjw@sisk.pl>
> Acked-by: Joseph Cihula <joseph.cihula@intel.com>
> [v1: Return -1/0/+1 instead of ACPI_xx values]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/kernel/tboot.c |   13 ++++---------
>  1 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c index 1a4ab7d..6410744 100644
> --- a/arch/x86/kernel/tboot.c
> +++ b/arch/x86/kernel/tboot.c
> @@ -272,7 +272,7 @@ static void tboot_copy_fadt(const struct acpi_table_fadt *fadt)
>  		offsetof(struct acpi_table_facs, firmware_waking_vector);  }
> 
> -void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
> +static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32
> +pm1b_control)
>  {
>  	static u32 acpi_shutdown_map[ACPI_S_STATE_COUNT] = {
>  		/* S0,1,2: */ -1, -1, -1,
> @@ -281,7 +281,7 @@ void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
>  		/* S5: */ TB_SHUTDOWN_S5 };
> 
>  	if (!tboot_enabled())
> -		return;
> +		return 0;
> 
>  	tboot_copy_fadt(&acpi_gbl_FADT);
>  	tboot->acpi_sinfo.pm1a_cnt_val = pm1a_control; @@ -292,15 +292,10 @@ void tboot_sleep(u8
> sleep_state, u32 pm1a_control, u32 pm1b_control)
>  	if (sleep_state >= ACPI_S_STATE_COUNT ||
>  	    acpi_shutdown_map[sleep_state] == -1) {
>  		pr_warning("unsupported sleep state 0x%x\n", sleep_state);
> -		return;
> +		return -1;
>  	}
> 
>  	tboot_shutdown(acpi_shutdown_map[sleep_state]);
> -}
> -static int tboot_sleep_wrapper(u8 sleep_state, u32 pm1a_control,
> -			       u32 pm1b_control)
> -{
> -	tboot_sleep(sleep_state, pm1a_control, pm1b_control);
>  	return 0;
>  }
> 
> @@ -352,7 +347,7 @@ static __init int tboot_late_init(void)
>  	atomic_set(&ap_wfs_count, 0);
>  	register_hotcpu_notifier(&tboot_cpu_notifier);
> 
> -	acpi_os_set_prepare_sleep(&tboot_sleep_wrapper);
> +	acpi_os_set_prepare_sleep(&tboot_sleep);
>  	return 0;
>  }
> 
> --
> 1.7.7.5

