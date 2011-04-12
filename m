Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab1DLOHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:07:41 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:62751 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755258Ab1DLOHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:07:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAKpbpE1Ld/sX/2dsb2JhbAAMhD+rUagJkTKBKYFYgXV4BJQK
X-IronPort-AV: E=Sophos;i="4.64,195,1301889600"; 
   d="scan'208";a="106078858"
Message-ID: <4DA45CA7.9040102@teksavvy.com>
Date: Tue, 12 Apr 2011 10:07:35 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bruce Stenning <b.stenning@indigovision.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com> <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com> <4D9CD275.9000002@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com> <4D9FACC9.7020200@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-12 06:30 AM, Bruce Stenning wrote:
>
> I have reproduced the issue with the 2.6.32 kernel.

Perfect.  This means that it probably wasn't broken by somebody else
since I last looked at the code two years ago.  :)
>
> In case it is of use, the silicon is rev 09 (i.e. C0 stepping) and I am using
> gcc 4.4.2 to build the kernel and modules.

"C0" is *good*.

> I am currently inserting tracing into 2.6.38.2 to try to work out what is going
> on.  From mv_write_main_irq_mask I can see that the IRQ for each port is still
> enabled, even when ports stop responding.  I see interrupts generated when I
> hotplug or unplug disks on ports that are not locked up, but no interrupt is
> generated at all for the ports that are locked (this is from tracing in
> asm_do_IRQ in arch/arm/kernel/irq.c)
> 
> One thing I noticed was that there is no spinlock around the
> mv_save_cached_regs/mv_edma_cfg in mv_hardreset (unlike mv_port_start and
> mv_port_stop); why is this?

The mv_hardreset path is run from a libata-eh thread,
and it assumes it has exclusive access to the hardware.

But by all means, stuff the spinlock around that pair of calls,
just to eliminate any possibility of my mis-thinking it there.

I'm going to take a few minutes now and try to re-understand
how hot-plug gets "armed" for use, and see if anything cries out at me.

Cheers
