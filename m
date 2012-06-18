Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2FRJXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:23:32 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37233 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab2FRJXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:23:31 -0400
MIME-Version: 1.0
In-Reply-To: <1339850780.15222.8.camel@twins>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	<1339741902-8449-7-git-send-email-zheng.z.yan@intel.com>
	<1339780730.2559.92.camel@twins>
	<CABPqkBTuBnFWo0wpcmg_YR_C0Q_BAMBqs7nrFTHnag=_RMPddA@mail.gmail.com>
	<1339850780.15222.8.camel@twins>
Date: Mon, 18 Jun 2012 11:23:29 +0200
Message-ID: <CABPqkBQYRs9F2U3LVWcxip3-2ijxAE8+szj2TY8MKwO2w7se1A@mail.gmail.com>
Subject: Re: [PATCH V6 06/13] perf: Add Nehalem and Sandy Bridge uncore support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 2:46 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Fri, 2012-06-15 at 20:46 +0200, Stephane Eranian wrote:
> > Yes, and let the parser be case insensitive.
>
> Right, I did the below on top..
>
> ---
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -179,22 +179,17 @@ static struct attribute *snbep_uncore_pc
>  };
>
>  static struct uncore_event_desc snbep_uncore_imc_events[] = {
> -       INTEL_UNCORE_EVENT_DESC(CLOCKTICKS, "config=0xffff"),
> -       /* read */
> -       INTEL_UNCORE_EVENT_DESC(CAS_COUNT_RD, "event=0x4,umask=0x3"),
> -       /* write */
> -       INTEL_UNCORE_EVENT_DESC(CAS_COUNT_WR, "event=0x4,umask=0xc"),
> +       INTEL_UNCORE_EVENT_DESC(clockticks,      "event=0xff,umask=0xff");

Just like for core, I would pick 0xff as the pseudo event code for
fixed uncore events
and use the umask value to determine which of the fixed events we want
to map to. There
is only one fixed counter so far. But more could be added later on, so
why not start with
umask=0x00 or umask=0x1 instead of umask=0xff?

> +       INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03"),
> +       INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c"),
>        { /* end: all zeroes */ },
>  };
>
>  static struct uncore_event_desc snbep_uncore_qpi_events[] = {
> -       INTEL_UNCORE_EVENT_DESC(CLOCKTICKS, "event=0x14"),
> -       /* outgoing data+nondata flits */
> -       INTEL_UNCORE_EVENT_DESC(TxL_FLITS_ACTIVE, "event=0x0,umask=0x6"),
> -       /* DRS data received */
> -       INTEL_UNCORE_EVENT_DESC(DRS_DATA, "event=0x2,umask=0x8"),
> -       /* NCB data received */
> -       INTEL_UNCORE_EVENT_DESC(NCB_DATA, "event=0x3,umask=0x4"),
> +       INTEL_UNCORE_EVENT_DESC(clockticks,       "event=0x14"),
> +       INTEL_UNCORE_EVENT_DESC(txl_flits_active, "event=0x0,umask=0x6"),
> +       INTEL_UNCORE_EVENT_DESC(drs_data,         "event=0x2,umask=0x8"),
> +       INTEL_UNCORE_EVENT_DESC(ncb_data,         "event=0x3,umask=0x4"),
>        { /* end: all zeroes */ },
>  };
>
> @@ -621,29 +616,15 @@ static struct attribute_group nhm_uncore
>  };
>
>  static struct uncore_event_desc nhm_uncore_events[] = {
> -       INTEL_UNCORE_EVENT_DESC(CLOCKTICKS, "config=0xffff"),
> -       /* full cache line writes to DRAM */
> -       INTEL_UNCORE_EVENT_DESC(QMC_WRITES_FULL_ANY,
> "event=0x2f,umask=0xf"),
> -       /* Quickpath Memory Controller normal priority read requests */
> -       INTEL_UNCORE_EVENT_DESC(QMC_NORMAL_READS_ANY,
> "event=0x2c,umask=0xf"),
> -       /* Quickpath Home Logic read requests from the IOH */
> -       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_IOH_READS,
> -                               "event=0x20,umask=0x1"),
> -       /* Quickpath Home Logic write requests from the IOH */
> -       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_IOH_WRITES,
> -                               "event=0x20,umask=0x2"),
> -       /* Quickpath Home Logic read requests from a remote socket */
> -       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_REMOTE_READS,
> -                               "event=0x20,umask=0x4"),
> -       /* Quickpath Home Logic write requests from a remote socket */
> -       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_REMOTE_WRITES,
> -                               "event=0x20,umask=0x8"),
> -       /* Quickpath Home Logic read requests from the local socket */
> -       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_LOCAL_READS,
> -                               "event=0x20,umask=0x10"),
> -       /* Quickpath Home Logic write requests from the local socket */
> -       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_LOCAL_WRITES,
> -                               "event=0x20,umask=0x20"),
> +       INTEL_UNCORE_EVENT_DESC(clockticks,
>  "event=0xff,umask=0xff"),
> +       INTEL_UNCORE_EVENT_DESC(qmc_writes_full_any,
> "event=0x2f,umask=0x0f"),
> +       INTEL_UNCORE_EVENT_DESC(qmc_normal_reads_any,
>  "event=0x2c,umask=0x0f"),
> +       INTEL_UNCORE_EVENT_DESC(qhl_request_ioh_reads,
> "event=0x20,umask=0x01"),
> +       INTEL_UNCORE_EVENT_DESC(qhl_request_ioh_writes,
>  "event=0x20,umask=0x02"),
> +       INTEL_UNCORE_EVENT_DESC(qhl_request_remote_reads,
>  "event=0x20,umask=0x04"),
> +       INTEL_UNCORE_EVENT_DESC(qhl_request_remote_writes,
> "event=0x20,umask=0x08"),
> +       INTEL_UNCORE_EVENT_DESC(qhl_request_local_reads,
> "event=0x20,umask=0x10"),
> +       INTEL_UNCORE_EVENT_DESC(qhl_request_local_writes,
>  "event=0x20,umask=0x20"),
>        { /* end: all zeroes */ },
>  };
>
>
