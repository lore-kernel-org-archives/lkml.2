Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab0I1K7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:59:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55698 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0I1K7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:59:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arthur Kepner <akepner@sgi.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
References: <20100927203448.GC30050@sgi.com>
	<alpine.LFD.2.00.1009272236430.2416@localhost6.localdomain6>
	<20100927220113.GD30050@sgi.com>
	<alpine.LFD.2.00.1009280003300.2416@localhost6.localdomain6>
	<m1hbhalo1o.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.1009280957150.2416@localhost6.localdomain6>
Date: Tue, 28 Sep 2010 03:59:33 -0700
In-Reply-To: <alpine.LFD.2.00.1009280957150.2416@localhost6.localdomain6>
	(Thomas Gleixner's message of "Tue, 28 Sep 2010 10:08:52 +0200
	(CEST)")
Message-ID: <m1eicennfu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
Subject: Re: [RFC/PATCHv2] x86/irq: round-robin distribution of irqs to cpus w/in node
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Mon, 27 Sep 2010, Eric W. Biederman wrote:
>> > On Mon, 27 Sep 2010, Arthur Kepner wrote:
>> The deep bug is that create_irq_nr allocates a vector (which it does
>> because at the time there was no better way to mark an irq in use on
>> x86).  In the case of msi-x we really don't know the node that irq is
>> going to be used on until we get a request irq.  We simply know which
>> node the device is on.
>
> Bah. So the whole per node allocation business is completely useless
> at this point.

Probably.

>> If you want to see what is going follow the call trace looks like.
>> pci_enable_msix 
>>   arch_setup_msi_irqs
>>     create_irq_nr
>> 
>> After pci_enable_msix is finished then the driver goes and makes all
>> of the irqs per cpu irqs.
>> 
>> There are goofy things that happen when hardware asks for 1 irq per cpu.
>> But since msi can ask for up to 4096 irqs (assuming the hardware
>> supports it) I can totally see putting all 256 of those irqs on a single
>> cpu, before you go to user space and let user space or something
>> reassign all of those irqs in a per cpu way.
>> 
>> My gut feel says that the real answer is to delay assigning a vector
>> to an irq until request_irq().  At which point we will know that someone
>> at least wants to use the irq.
>
> Right. So the solution would be:
>
> create_irq allocates an irq number + irq descriptor, nothing else
>
> chip->startup() will setup the vector and chip->shutdown releases
> it. That requires to change the return value of chip->startup to int,
> so we can return an error code, but that can be done in course of the
> overhaul I'm working on. 
>
> Right now I prefer not to add more crap to io_apic.c, it's horrible
> enough already. I'll fix that with the cleanup.

Understood.  It has taken a couple of years before this bug finally
bit anyone waiting a release or two to get it fixed properly seems
reasonable.

pci_enable_msix all in it's own way is fixable, but it has
few enough callers < 80 that it is also fixable.

drivers/pci/msi.c and drivers/pci/htirq.c are interesting in
that they are arch independent users of the generiq layer.  Which
is why msi_desc needed a new field.

Eric


