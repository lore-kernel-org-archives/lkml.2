Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab1FGGbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 02:31:47 -0400
Received: from demekin.fsr.com ([64.126.133.131]:48199 "EHLO demekin.fsr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1FGGbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 02:31:46 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jun 2011 02:31:45 EDT
From: Nathan Anderson <nathana@fsr.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jun 2011 23:26:24 -0700
Subject: PCI BAR address mismatch between kernel and module?
Thread-Topic: PCI BAR address mismatch between kernel and module?
Thread-Index: Acwk29rO0OrM1aLNTRypDQh+05i33g==
Message-ID: <C12CA40900F4E0448A2D4E66DFA6A59B13D1F328E8@Demekin.FSI.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, everybody,

If this isn't the right place for me to direct a question like this, please
accept my apology for the interruption, and feel free to ignore me or point
me in the direction of a more appropriate venue. :-)  

I need to build a working set of kernel modules (drivers for a PCI-bus disk
controller) for an embedded system I'm using that is built atop Linux, and
for which I don't have the .config for.  The idea is that I will replace
the initramfs archive with one that has the modules + a stripped-down
busybox, and write a shell script to load the modules before passing
control off to the original initramfs's 'init' (a binary) via exec. 
Building a new kernel from scratch for this system is, sadly, not an
option, and the .config is unobtainable (I checked: CONFIG_IKCONFIG was not
enabled for the build of this specific kernel).  I'm sure the task is
hopeless/not recommended/frowned upon, but that hasn't deterred me...yet.  

In fact, I feel like I've nearly got it.  I've matched the same kernel
version that they used (2.6.35.nothing; although, granted, I have no
knowledge of any patches they might have applied or direct changes to their
source tree that they might have made).  I have a build toolchain that
matches the one used to build the original kernel, down to the gcc version
(4.5.0, x86 arch).  I have even managed to churn out a set of modules for
the hardware device in question that match the version magic of the running
kernel, and which neither reference any symbols missing from this kernel,
nor do they generate OOPSen when insmod'ed (the latter turned out to be
tricky; after much trial-and-error, I discovered I needed to enable
CONFIG_UNUSED_SYMBOLS when building the modules in order for this kernel to
be happy with them).           

Only one problem (seemingly) remains: all of the modules I've built (and
I've tried building a couple of different ones for a couple of different
pieces of hardware) appear to have difficulty interacting with the PCI
subsystem of the kernel.   

Now, this embedded system I'm working with actually comes with two kernels:
one which is SMP-enabled (CONFIG_SMP + CONFIG_M686), and the other which is
not (CONFIG_M586).  I have built a separate set of modules for each kernel,
and both sets fail to work, but they do so in slightly different ways
between the two kernels.  Since I have a firmer grasp right now on what is
going on with the SMP kernel than I do with the non-SMP one, I'll
concentrate on the SMP one for the time being, in the hope that whatever
solution I find for the SMP kernel will help to shed some light on what
might be going on with the other one.        

Anyway, the crux of the matter: when the driver for either piece of
hardware tries to get the starting address of the very first BAR for the
PCI device in question, the driver gets back a value of 0.  From what I can
tell, the driver is able to read the correct starting addresses for the
other BARs; it is *only* the FIRST one that it gets back 0 for.  One driver
(mptbase + mptscsih + mptspi) appears not to check for this, tries to
access that memory address, and this causes the kernel to throw out a
"resource map sanity check conflict" before filling the screen up with what
looks like a stack trace.  The other driver (BusLogic) apparently checks
pci_dev.resource[0].flags for the device and if it's not the type of
resource it is expecting to see for that particular BAR, it 'printk's its
own error message and quits early.           

Now, the thing is that the kernel DOES know the correct address: if I look
at bus/pci/devices/blahblahblah/resource under sysfs, I see the right
starting and ending addresses for all BARs, including the first. 
Furthermore, all of the hardware works fine, too: if I build a complete
kernel, boot the system off of that, and try to load the very same module
binaries, they load up and initialize the hardware just fine.  But for some
reason, these modules can't when paired with this other kernel.      

A quick glance at pci-sysfs.c to see what it might be doing differently
than the drivers did reveal that the PCI sysfs code is not using the
pci_resource_start/end/flags macros, but is instead accessing the resource
struct directly and then calling pci_resource_to_user to get the values
(and on the x86 arch., that inline function doesn't look like it is being
overridden, so it seems to me that the result should be exactly the same). 

I admit that I am very much a novice at this stuff and am probably barking
up the wrong tree.  My hunch is that there is probably some obscure kernel
configuration/build option that is mismatched between the modules I'm
building and the kernel I'm trying to pair them up with, and that if I just
found the right switch to flip, it would work... I've tried flipping
various PCI-related switches under "Bus options" in menuconfig, with
absolutely no change.  (Actually, that's not true.  One time I swear I made
a build where I tried limiting the PCI access mode to "BIOS", and
pci_dev.resource[0].start actually had a non-zero value, but it wasn't the
right one: it matched the address for pci_dev.resource[1].start!  But I
can't reproduce that again.  Bizarre.  Maybe the kernel is using a
different definition for either 'struct pci_dev' or 'struct resource' than
the modules are, and it just happened to hit the "right" area of memory
That time where the value for the second BAR starting address was stored?)      

I'll spare you guys any more rambling, though, and end it here.  If anyone
who is intimately familiar with the Linux PCI code has any idea what I
might be able to do to get this to work, you would have my undying
gratitide.   

Thanks so much for reading,

-- 
Nathan Anderson
First Step Internet, LLC
nathana@fsr.com
