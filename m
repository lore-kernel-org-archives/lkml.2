Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1CPPFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:05:04 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:41199
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446Ab1CPPFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:05:00 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI5OK2-02-MF9-02
X-M-MSG: 
Date: Wed, 16 Mar 2011 16:04:51 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] oprofile: Allow setting EDGE/INV/CMASK for Intel
 counter events
Message-ID: <20110316150450.GO31407@erda.amd.com>
References: <1299870748-13319-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1299870748-13319-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.03.11 14:12:28, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> For some performance events it's useful to set the EDGE and INV
> bits and the CMASK mask in the counter control register. The list
> of predefined events Intel releases for each CPU has some events which
> require these settings to get more "natural" to use higher level events.
> 
> oprofile currently doesn't allow this.
> 
> This patch adds new extra configuration fields for them, so that
> they can be specified in oprofilefs.
> 
> An updated oprofile daemon can then make use of this to set them.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/oprofile/nmi_int.c    |    4 ++++
>  arch/x86/oprofile/op_counter.h |    1 +
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index e2b7b0c..bace252 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -49,6 +49,9 @@ u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
>  	val |= counter_config->user ? ARCH_PERFMON_EVENTSEL_USR : 0;
>  	val |= counter_config->kernel ? ARCH_PERFMON_EVENTSEL_OS : 0;
>  	val |= (counter_config->unit_mask & 0xFF) << 8;
> +	val |= counter_config->extra & (ARCH_PERFMON_EVENTSEL_INV|
> +					ARCH_PERFMON_EVENTSEL_EDGE|
> +					ARCH_PERFMON_EVENTSEL_CMASK);

I would like to write the actual value back so that userland may read
it:

	counter_config->extra &= (ARCH_PERFMON_EVENTSEL_INV|
                         ARCH_PERFMON_EVENTSEL_EDGE|
                         ARCH_PERFMON_EVENTSEL_CMASK);
	val |= counter_config->extra;

The value will not be updated emmediately but at least after profiling
was started.

As an alternative, maybe we better put this extra bits in the
unit_mask, e.g. in bits [31:16] of the unit mask for bits [31:16] of
PerfEvtSel? Then, we simply could use the current userland to set it
up.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

