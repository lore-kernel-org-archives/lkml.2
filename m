Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab1GDWQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 18:16:54 -0400
Received: from wnohang.net ([178.79.154.173]:53185 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1GDWQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 18:16:53 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 1E42DF0009
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 59A0CF0003
Date: Tue, 5 Jul 2011 03:46:46 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, jeremy.fitzhardinge@citrix.com,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] Modpost section mismatch fix
Message-ID: <20110704221646.GB4490@Xye>
References: <20110703232508.GB4440@Xye>
 <1309769388.634.51.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1309769388.634.51.camel@zakaz.uk.xensource.com>
X-Operating-System: Arch linux x86_64 3.0.0-rc5-LYM
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* On Mon, Jul 04, 2011 at 09:49:48AM +0100, Ian Campbell <ijc@hellion.org.uk> wrote:
>On Mon, 2011-07-04 at 04:55 +0530, Raghavendra D Prabhu wrote:
>> [Sorry if duplicate, one earlier was corrupt]

>> Hi,
>>      I got section mismatches reported by modpost in latest build. It got
>>      reported for xen_register_pirq and xen_unplug_emulated_devices
>>      functions.
>
>
>>  xen_register_pirq makes reference to
>>      acpi_sci_override_gsi in init.data section; marking
>>      xen_register_pirq with __init is not feasible since calls are made
>>      to it from acpi_register_gsi in non-init contexts. So marking it
>>      __refdata based on assumption that when acpi_sci_override_gsi is
>>      referenced, it is in  early stages where it is alive.
>
>I don't think this assumption holds, since xen_register_pirq can be
>called at any time and basically unconditionally references
>acpi_sci_override_gsi.

Yeah, that has been my guess as well, however I am not privy to the
inner workings of Xen, so was not sure.
>
>If we don't want to remove the __init from acpi_sci_override_gsi then
>perhaps xen_setup_acpi_sci needs to stash it somewhere?
>
>Or maybe xen_register_pirq could take an "int force_irq" which, if not
>-1, would force a particular IRQ. The callsite in xen_setup_acpi_sci
>(actually via xen_register_gsi so the param would need to be propagated
>there) would be the only actual user?

xen_register_gsi and hence, xen_register_pirq are called from
init (with xen_setup_acpi_sci) and non-init (with
acpi_register_gsi_xen); since xen_set_acpi_sci calls it with gsi ==
acpi_sci_override_gsi and is marked __init, the best way would be to
call xen_register_gsi and xen_register_pirq with a boolean argument like
sci_override to obviate the need to use acpi_sci_override_gsi in
register_pirq. I will send the patch with this change if it looks good.


>
>The xen_unplug_emulated_devices change looks correct to me since
>xen_unplug_emulated_devices is called from xen_arch_hvm_post_suspend.
>
>Ian.
>


>> --------------------------
>> Raghavendra Prabhu
>> GPG Id : 0xD72BE977
>> Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
>> www: wnohang.net
>> _______________________________________________
>> Virtualization mailing list
>> Virtualization@lists.linux-foundation.org
>> https://lists.linux-foundation.org/mailman/listinfo/virtualization
