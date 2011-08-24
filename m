Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1HXQfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 12:35:25 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:43893
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993Ab1HXQfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:35:22 -0400
X-SpamScore: 1
X-BigFish: VPS1(zz98dKzz1202h1082kzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQFY1B-01-E32-02
X-M-MSG: 
Date: Wed, 24 Aug 2011 18:33:54 +0200
From: Borislav Petkov <bp@amd64.org>
To: Julia Lawall <julia@diku.dk>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        <kernel-janitors@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/x86/kernel/microcode_core.c: add missing
 platform_device_unregister
Message-ID: <20110824163354.GC21066@gere.osrc.amd.com>
References: <1314198652-10333-1-git-send-email-julia@diku.dk>
 <20110824153611.GB21066@gere.osrc.amd.com>
 <Pine.LNX.4.64.1108241742480.25172@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108241742480.25172@ask.diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 05:44:08PM +0200, Julia Lawall wrote:
> That seems like a fairly big change.  Is it desirable to move the calls to 
> sysdev_driver_register and microcode_dev_init up over the get_online_cpus 
> ... put_online_cpus sequence?

Well, you need microcode_pdev for request_firmware() which happens
when you do sysdev_driver_register() so it has to run after
platform_device_register_simple().

And the microcode_dev_init() thing got moved further
down in 871b72dd1e12afc3f024479531d25a9339d2e3f9 but its
counterpart microcode_dev_exit() is mistakenly called if
platform_device_register_simple() fails which is clearly another bug.

And frankly, microcode_dev_init() is strictly needed only for the
CONFIG_MICROCODE_OLD_INTERFACE. And on the driver destroy path
microcode_exit() is calling microcode_dev_exit() first so it could be
that 871b72dd1e12afc3f024479531d25a9339d2e3f9 mistakenly moved the
microcode_dev_init() call down.

I guess you could move the microcode_dev_init() call up, before
platform_device_register_simple() but this needs testing on Intel
because they still can do microcode loading over the old interface using
microcode_ctl userspace helper...

Or, you can do a bit cleaner version of the goto-with-labels thing by
adding a helper like this:

static void __microcode_sysdev_unregister(void)
{
        get_online_cpus();
        mutex_lock(&microcode_mutex);

        sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);

        mutex_unlock(&microcode_mutex);
        put_online_cpus();
}

and call it both on the error-out path in microcode_init(), and in
microcode_exit().

Oh boy, the rabbit hole turns out to be pretty deep once you go down
into it :-).

Btw, I totally understand if you've lost all desire to fix that properly
after all this :-).

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

