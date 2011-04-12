Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab1DLOz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:55:59 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:53050 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932069Ab1DLOz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:55:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAGBnpE1Ld/sX/2dsb2JhbAAMhD/TXZErgSmBWIF1eASUCg
X-IronPort-AV: E=Sophos;i="4.64,197,1301889600"; 
   d="scan'208";a="106111818"
Message-ID: <4DA467FB.6020905@teksavvy.com>
Date: Tue, 12 Apr 2011 10:55:55 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bruce Stenning <b.stenning@indigovision.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com> <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com> <4D9CD275.9000002@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com> <4D9FACC9.7020200@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com> <4DA45CA7.9040102@teksavvy.com>
In-Reply-To: <4DA45CA7.9040102@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-12 10:07 AM, Mark Lord wrote:
> On 11-04-12 06:30 AM, Bruce Stenning wrote:
..
>> I am currently inserting tracing into 2.6.38.2 to try to work out what is going
>> on.  From mv_write_main_irq_mask I can see that the IRQ for each port is still
>> enabled, even when ports stop responding.  I see interrupts generated when I
>> hotplug or unplug disks on ports that are not locked up, but no interrupt is
>> generated at all for the ports that are locked (this is from tracing in
>> asm_do_IRQ in arch/arm/kernel/irq.c)
>>
>> One thing I noticed was that there is no spinlock around the
>> mv_save_cached_regs/mv_edma_cfg in mv_hardreset (unlike mv_port_start and
>> mv_port_stop); why is this?
> 
> The mv_hardreset path is run from a libata-eh thread,
> and it assumes it has exclusive access to the hardware.


Mmm.. another suspect is sata_mv's ".sff_irq_clear" function.
I don't see any locking in libata-sff.c before calling that one.

Tejun -- should libata-sff grab ap->lock before calling .sff_irq_clear,
or is that up to the LLD to do?

Thanks.
