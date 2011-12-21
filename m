Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1LUTmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:42:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35339 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1LUTm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:42:29 -0500
MIME-Version: 1.0
In-Reply-To: <4EF2352C.3060102@linux.intel.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
	<4EF1A0B4.5080307@linux.intel.com>
	<CAMbhsRRP7s9xsHqxhb=iMfHAJFcqAea-6CDORZS34RCPNo+UWw@mail.gmail.com>
	<4EF1AA8A.8060304@linux.intel.com>
	<CAMbhsRSNTUvou9Gf6T4Ggq=jfxsWUcn7M2yNsKQz6aNrt6gLDg@mail.gmail.com>
	<4EF1CD49.9020800@linux.intel.com>
	<CAMbhsRRnKoR3YPWrZzVynVe+dcuU5v0siYvmp2vbBcS1hquC7Q@mail.gmail.com>
	<4EF2352C.3060102@linux.intel.com>
Date: Wed, 21 Dec 2011 11:42:28 -0800
X-Google-Sender-Auth: -uR5NR1Kn_E2YtHb-IJqmzh2S_0
Message-ID: <CAMbhsRSPCo9MSGp57Fv0sRdYUFcdwx8jEz1-CfX8LdKf8X4MVg@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/3] coupled cpuidle state support
From: Colin Cross <ccross@android.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, Amit Kucheria <amit.kucheria@linaro.org>,
        linux-tegra@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 11:36 AM, Arjan van de Ven
<arjan@linux.intel.com> wrote:
>>>
>>> .. or it enters WFI, and a physical device sends it an interrupt,
>>> at which point it exits.
>>
>> None of the cpus will return to the idle loop until all cpus have
>> decremented the ready counter back to 0, so they can't wrap around
>> again.
>
>
> yikes, so you IPI all the cpus on the first exit.
> that must burn power ;-(

No, you're not understanding the point of this series.

If your cpus can go in and out of idle independently, you don't use
this code at all.  Each cpu can call WFI and come back out without
talking to the other cpu.

However, if you have two cpus that share some part of the SoC that can
be turned off in idle, like the L2 cache controller or the system bus,
the two cpus need to go to idle together, and they will both boot
together when either one receives an interrupt (although one will
likely immediately go back to a shallower state that doesn't require
coordination with the other cpu).  There is no way around this, it's
how the hardware works on some ARM platforms.
