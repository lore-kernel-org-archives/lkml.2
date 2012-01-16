Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2APUjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:39:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36707 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656Ab2APUjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:39:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [Regression] Commit "tpm: Introduce function to poll for result of self test" breaks suspend
Date: Mon, 16 Jan 2012 21:42:33 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
References: <201201160022.07176.rjw@sisk.pl> <4F138AFB.8040601@linux.vnet.ibm.com>
In-Reply-To: <4F138AFB.8040601@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201162142.34096.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 16, 2012, Stefan Berger wrote:
> On 01/15/2012 06:22 PM, Rafael J. Wysocki wrote:
> > Hi Stefan,
> >
> Hi Rafael,
> > Unfortunately, the following commit from you:
> >
> > commit 68d6e6713fcb2ea6278661aaaf5f1c9c821b3751
> > Author: Stefan Berger<stefanb@linux.vnet.ibm.com>
> > Date:   Fri Nov 11 12:57:04 2011 -0500
> >
> >      tpm: Introduce function to poll for result of self test
> >
> >      This patch introduces a function that runs the TPM_ContinueSelfTest()
> >      function and then polls the TPM to check whether it finished the selftest
> >      and can receive new commands.
> >
> >      Signed-off-by: Stefan Berger<stefanb@linux.vnet.ibm.com>
> >
> > broke suspend on my Toshiba Portege R500.  It causes the tpm driver to
> > return an error code from .suspend() on every attempt to suspend the system.
> >
> 
> Can you show what the error output is?

I get:

[   96.103556] PM: Entering mem sleep
[   96.103606] Suspending console(s) (use no_console_suspend to debug)
[   96.107159] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   96.107548] sd 0:0:0:0: [sda] Stopping disk
[   96.108436] option: option_instat_callback: error -2
[   96.386200] tpm_inf_pnp 00:0a: saving TPM state
[   96.407630] tpm_inf_pnp 00:0a: Timeout while clearing FIFO
[   96.407634] tpm_inf_pnp 00:0a: error while saving TPM state
[   96.407646] legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -5
[   96.407656] PM: Device 00:0a failed to suspend: error -5
[   96.407662] PM: Some devices failed to suspend

100% of the time.

> Strange enough this function is not called during a suspend but during 
> boot and again during resume. Can you try the following after a boot
> 
> cd /sys/devices
> find -name pcrs | xargs cat
> 
> and see whether this displays 24 PCRs.

That doesn't produce any output.

> This sends a couple of commands to the TPM. Then try a suspend. Did this
> help anything?

Nope.  The result is the same as before.

> If yes, can you run above commands again?

It still doesn't produce any output.

> FYI: TPM_ContinueSelfTest is the only TPM function that triggers an 
> asynchronous action of the TPM, here the continuation of its self test. 
> To prevent subsequent commands sent to the TPM from failing due to the 
> ongoing self test, we are now waiting for this command to finish. None 
> of the machines that I tested it with had a TPM that actually did 
> anything during the TPM_ContinueSelfTest() but must have fully completed 
> their selftest during TPM_SelfTest() sent to it by the BIOS.
> 
> > Revertig this commit on top of the current Linus' tree fixes the problem for me.
> >
> > If necessary, I'll collect more information about this problem tomorrow.
> 
> The output of 'caps' would be interesting in the same dir as pcrs:
> 
> cd /sys/devices
> find -name caps | xargs cat

That doesn't show anything too.

However, after reverting the above commit I get:

$ find /sys/devices -name caps | xargs cat
Manufacturer: 0x49465800
TCG version: 1.2
Firmware version: 1.2

and system suspend works, although "find /sys/devices -name pcrs | xargs cat"
still doesn't show anything.

Thanks,
Rafael
