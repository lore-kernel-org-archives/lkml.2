Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab1JGSFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:05:43 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42750 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1JGSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:05:41 -0400
Date: Fri, 7 Oct 2011 20:05:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@amd64.org>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH RESEND] Freezer, CPU hotplug, x86 Microcode: Fix
 task freezing failures
Message-ID: <20111007180534.GA671@aftab>
References: <201110052226.58373.rjw@sisk.pl>
 <4E8CC8FA.2090100@linux.vnet.ibm.com>
 <201110060043.19583.rjw@sisk.pl>
 <4E8D4FC6.1080204@linux.vnet.ibm.com>
 <20111006083439.GA21575@aftab>
 <4E8DCDA6.8030802@linux.vnet.ibm.com>
 <4E8E1125.4050701@linux.vnet.ibm.com>
 <20111006221334.GB7085@google.com>
 <20111006223438.GA27702@aftab>
 <4E8F2D51.9020207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8F2D51.9020207@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 12:48:17PM -0400, Srivatsa S. Bhat wrote:
> Boris, it is only now (after you explained) that I really understood why you
> saw value in this patch (even though it was not the proper fix). So actually
> this patch is just a good-to-have cpu hotplug optimization, but the real fix
> would be the exclusion approach. More than that, this patch has got nothing
> intentional to do with freezer, but its motivation is just to avoid doing
> something needless in the cpu hotplug path. And an entirely different patch
> (having the exclusion stuff) is needed to properly fix the problem we are
> facing. This is what you mean right?
> 
> If so, then in a way we are trying to reposition why we need this patch. And
> since we don't want to position this as a fix to this problem, I should
> probably submit this patch with a different patch description and subject,
> to explain the new usecase/motivation for this patch. Am I right?

Absolutely, right on the money. Just write a short commit message
explaining why it does what it does and send it to x86 guys. Thanks for
that.

> By the way, even I believe that the exclusion approach is the best fix to the
> problem. (I have been mulling about this in some of my previous mails as well).
> At least we can see 3 call paths that get into trouble when racing with
> freezer:
> 1. CPU hotplug.
> 2. Microcode module load/unload.
> 3. Reloading the microcode by controlling the sysfs file
> /sys/devices/system/cpu/cpu*/microcode/reload. See below for log for this new
> scenario.

Please note that microcode is not supposed to be reloaded that often and
the box suspended at the same time as your test does. So I don't really
consider it relevant case - normally, you either update your microcode
XOR hibernate the box. Besides, microcode is not something you get on a
monthly basis to require such often updates.

> At least this is what I got from looking at the microcode call paths that
> involve a call to request_firmware.
> 
> I am still working on implementing the mutual exclusion at appropriate
> places. However, since any of this would involve locking, with the
> freezer/suspend involved as well (and especially since cpu hotplug is
> used by the suspend code itself), I am trying to tread cautiously
> (read: needing more time) to ensure that I don't introduce incorrect locking
> scenarios and hence task freezing failures myself, while intending to fix it.

IMO, you should concentrate on fixing _your_ use case and where your
testing fails instead of trying to cover all hypothetical failure
scenarios. Let's say that that's impossible, and also, doing the ucode
loading through the boot loader should take care of all those later.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
