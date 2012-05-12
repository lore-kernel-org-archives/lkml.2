Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab2ELXOC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 19:14:02 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55476 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab2ELXOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 19:14:00 -0400
Date: Sat, 12 May 2012 18:13:49 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Lars Boegild Thomsen <lth@cow.dk>,
        Andreas Wallberg <andreas.wallberg@gmail.com>,
        Robert Scott <bugs@humanleg.org.uk>
Subject: Re: [regression] Ideapad S10-3 does not wake up from suspend
Message-ID: <20120512231349.GA17443@burratino>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <20110829041532.GA22087@elie.gateway.2wire.net>
 <625BA99ED14B2D499DC4E29D8138F15063048B864D@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F15063048B864D@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

In September, Kevin Tian wrote:
>> Lars Boegild Thomsen writes[1]:

>>> After update from 2.6 kernel to 3.0 my Idepad S10-3 will not wake up after
>>> sleep.  Back to latest 2.6 kernel works fine.
> > [...]
>>> Upon wakeup, the power light go from slow flashing to on, the battery light
>>> goes from off to on, the hdd light blink once and then everything is dead.
[...]
>>> 983bbf1af0664b78689612b247acb514300f62c7 is the first bad commit
>> [...]
>>> I also tried to go back to HEAD and manually change arch/x86/irq.c revert this
>>> particular commit and it works.
[...]
> fixup_irqs is invoked in suspend path. The only impact this change may
> bring to resume path is the interrupt line state, which is saved later
> in suspend and then restored in resume. w/ above change after resume
> given interrupt line is always masked, while w/o it there may be at least
> one interrupt raising. If this does matter to make your ideapad working,
> I'd think there may have other bugs which are hidden originally, e.g. by
> triggering a reschedule from that interrupt though the handler itself
> does nothing except masking the interrupt line.
>
> So... above commit is not important which can be easily reverted. My
> only concern is whether other severe issues are just hidden.
>
> btw, any serial output you may capture?

Sorry for the slow response.  Result from reporters is:

 - 3.4-rc2 is affected as well
 - this only affects suspend-to-RAM --- suspend-to-disk works fine
 - all five pm_test modes for suspend-to-RAM work fine
 - this netbook doesn't have a serial port.  Netconsole gives:

| [  745.161322] PM: Syncing filesystems ... done.
| [  747.088247] PM: Preparing system for mem sleep
| [  747.187932] Freezing user space processes ... (elapsed 0.01 seconds) done.
| [  747.204325] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
| [  747.220416] PM: Entering mem sleep
| [  747.221085] sd 1:0:0:0: [sda] Synchronizing SCSI cache
| [  747.222247] sd 1:0:0:0: [sda] Stopping disk
| 
| (then nothing)

   Serial console via a USB-to-serial converter gives:

| [  814.016541] PM: Syncing filesystems ... done.
| [  814.018516] PM: Preparing system for mem sleep
| [  814.100393] Freezing user space processes ... (elapsed 0.01 se
|
| before it goes to sleep, and it doesn't output anything on (attempted) wakeup.

 - passing parameters "hpet=disable highres=off nohz=off" helps some
   people if I understand correctly, but I might have misunderstood.[2]

I'd be interested to hear whether the same problem occurs when trying
to suspend from the minimal initramfs environment.  (On systems like
Debian that use initramfs-tools, that means passing the kernel command
line parameter "break=top", booting, loading some appropriate minimal
collection of modules --- maybe none ---, and then running
"echo mem >/sys/power/state".  initramfs-tools(8) has details.)

Hope that helps,
Jonathan

>> [1] http://bugs.debian.org/635575
[2] https://bugzilla.kernel.org/show_bug.cgi?id=41932
