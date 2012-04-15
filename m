Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab2DOOGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 10:06:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40286 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2DOOGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 10:06:35 -0400
Date: Sun, 15 Apr 2012 09:06:28 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>, mingo@redhat.com,
        hpa@zytor.com, Ian Campbell <Ian.Campbell@eu.citrix.com>,
        JBeulich@novell.com, xen-devel@lists.xensource.com,
        Lars Boegild Thomsen <lth@cow.dk>, Robert Scott <bugs@humanleg.org.uk>,
        e568b31a443d@6cc2cce7af2d.anonbox.net,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [regression] Ideapad S10-3 does not wake up from suspend
Message-ID: <20120415140628.GA4536@burratino>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <20110829041532.GA22087@elie.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829041532.GA22087@elie.gateway.2wire.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Quick summary and update.

> Lars Boegild Thomsen writes[1]:

>> After update from 2.6 kernel to 3.0 my Idepad S10-3 will not wake up after 
>> sleep.
[...]
>> 983bbf1af0664b78689612b247acb514300f62c7 is the first bad commit

983bbf1af06 is "x86: Don't unmask disabled irqs when migrating them",
2011-05-06, and looks like this:

>> --- a/arch/x86/kernel/irq.c
>> +++ b/arch/x86/kernel/irq.c
>> @@ -276,7 +276,8 @@ void fixup_irqs(void)
>>  		else if (!(warned++))
>>  			set_affinity = 0;
>>  
>> -		if (!irqd_can_move_in_process_context(data) && chip->irq_unmask)
>> +		if (!irqd_can_move_in_process_context(data) &&
>> +		    !irqd_irq_disabled(data) && chip->irq_unmask)
>>  			chip->irq_unmask(data);

Robert Scott found[1], using 3.2.12:

> I'm getting the same behaviour on my Lenovo Ideapad S10-3

An anonymous contributor[2] also reports the same problem in v3.3.

Lars, Robert, anon: can you try 3.4-rc2 or newer and let us know how
it goes?  I suspect v3.4-rc2~24^2~4 ("x86: Preserve lazy irq disable
semantics in fixup_irqs()") will fix this.

Liu Chuansheng et al: do you think that commit would be a good
candidate for inclusion in -stable kernels?

Thanks and hope that helps,
Jonathan

> [1] http://bugs.debian.org/635575
[2] https://bugzilla.kernel.org/show_bug.cgi?id=41932
