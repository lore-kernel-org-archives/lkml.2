Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1LVIgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:36:00 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:33034 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753215Ab1LVIf6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:35:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAMbhsRSPCo9MSGp57Fv0sRdYUFcdwx8jEz1-CfX8LdKf8X4MVg@mail.gmail.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
 <4EF1A0B4.5080307@linux.intel.com> <CAMbhsRRP7s9xsHqxhb=iMfHAJFcqAea-6CDORZS34RCPNo+UWw@mail.gmail.com>
 <4EF1AA8A.8060304@linux.intel.com> <CAMbhsRSNTUvou9Gf6T4Ggq=jfxsWUcn7M2yNsKQz6aNrt6gLDg@mail.gmail.com>
 <4EF1CD49.9020800@linux.intel.com> <CAMbhsRRnKoR3YPWrZzVynVe+dcuU5v0siYvmp2vbBcS1hquC7Q@mail.gmail.com>
 <4EF2352C.3060102@linux.intel.com> <CAMbhsRSPCo9MSGp57Fv0sRdYUFcdwx8jEz1-CfX8LdKf8X4MVg@mail.gmail.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 22 Dec 2011 14:05:36 +0530
Message-ID: <CAMQu2gxws83BUdj_eMbF0xpA1Mo_OA_MswE7KUm5pvbn3YbMuQ@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/3] coupled cpuidle state support
To: Colin Cross <ccross@android.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-tegra@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 1:12 AM, Colin Cross <ccross@android.com> wrote:
> On Wed, Dec 21, 2011 at 11:36 AM, Arjan van de Ven
> <arjan@linux.intel.com> wrote:
>>>>
>>>> .. or it enters WFI, and a physical device sends it an interrupt,
>>>> at which point it exits.
>>>
>>> None of the cpus will return to the idle loop until all cpus have
>>> decremented the ready counter back to 0, so they can't wrap around
>>> again.
>>
>>
>> yikes, so you IPI all the cpus on the first exit.
>> that must burn power ;-(
>
> No, you're not understanding the point of this series.
>
> If your cpus can go in and out of idle independently, you don't use
> this code at all.  Each cpu can call WFI and come back out without
> talking to the other cpu.
>
Indeed. The SOCs, Arch's which does support low power
state independently and doesn't need any co-ordination between CPU's
will continue to work same way as before with this series.

> However, if you have two cpus that share some part of the SoC that can
> be turned off in idle, like the L2 cache controller or the system bus,
> the two cpus need to go to idle together, and they will both boot
> together when either one receives an interrupt (although one will
> likely immediately go back to a shallower state that doesn't require
> coordination with the other cpu).  There is no way around this, it's
> how the hardware works on some ARM platforms.

Apart from shared peripherals which Colin pointed out, OMAP also
brings in the security software state which is kind of executing in
parallel with linux. This state is lost in certain deeper low power
states and since the security software is affine to only master CPU
(because of OMAP security architecture), the co-ordination is
mandatory to achieve those low power states.

So this additional CPU co-ordination logic for such C-states
really helps to solve the issue in most generic way.

Regards
Santosh
