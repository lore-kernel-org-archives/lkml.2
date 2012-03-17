Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab2CQGje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 02:39:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38393 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2CQGjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 02:39:32 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.50.212]
In-Reply-To: <4F6354E4.8030704@monstr.eu>
References: <1330589497-4139-1-git-send-email-ohad@wizery.com>
 <1330589497-4139-2-git-send-email-ohad@wizery.com> <4F6354E4.8030704@monstr.eu>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 17 Mar 2012 08:39:08 +0200
Message-ID: <CAK=Wgbbbi4GnuHedSh6cR1LhkZr8c9q6i=_TLSL252LpPB8Xsw@mail.gmail.com>
Subject: Re: [PATCH 1/7] remoteproc: resource table overhaul
To: monstr@monstr.eu
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Brian Swetland <swetland@google.com>,
        Iliyan Malchev <malchev@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Guzman Lugo Fernando <fernando.lugo@ti.com>,
        Anna Suman <s-anna@ti.com>, Clark Rob <rob@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kieran Bingham <kieranbingham@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Fri, Mar 16, 2012 at 4:57 PM, Michal Simek <monstr@monstr.eu> wrote:
> In previous version I had carverout first which means that code was copyied
> to physical address 0x0 and then vrigns were allocated. Current code
> allocate vring first and then RTOS is not able to run from zero address.

In general, depending on specific allocation ordering is error prone
and you shouldn't do it.

For a given device, we treat memory allocated with
dma_alloc_coherent() as homogeneous. We care about its utilization and
alignments of allocations rather than their specific location in the
total region.

If that's not the case, and there's special memory you want assigned
with a specific purpose, than it's recommended to let the code make
sure it happens explicitly, and not rely on implicit order of
allocation.

Today there's no way to assign several memory regions with a specific
device, but a reasonable workaround that's being used is creating
several sub-devices with the special memory, and then looking them up
with stuff like device_for_each_child() or device_find_child().

About your specific issue: the current allocation scheme was chosen
for simplicity, but I do plan to change it back by postponing the
vring dma allocation until a remote processor is really powered on.
It's not a lot of memory, but this way we'd only allocate it when
really needed (so if it's CMA, others could use it).

IOW: you can probably just wait a bit until this patch is ready and
take it into your tree. It will most likely bring back the behavior you
need :)

Ohad.
