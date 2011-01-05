Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1AES6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 13:58:32 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:39224 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab1AES6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 13:58:31 -0500
Date: Wed, 5 Jan 2011 19:58:16 +0100
From: matthieu castet <castet.matthieu@free.fr>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX protection
 for kernel data)
Message-ID: <20110105195816.31457a59@mat-laptop>
In-Reply-To: <1293415850.2565.269.camel@minggr.sh.intel.com>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
	<1290431008.2072.119.camel@laptop>
	<1290443379.4cea9a73cd9ce@imp.free.fr>
	<1290443758.2072.318.camel@laptop>
	<20101122164247.GC21836@basil.fritz.box>
	<20101123235527.54293b59@mat-laptop>
	<20101126183144.300a71a4@mat-laptop>
	<1291093230.2405.191.camel@minggr.sh.intel.com>
	<20101224182644.062bdb3f@mat-laptop>
	<1293415850.2565.269.camel@minggr.sh.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mon, 27 Dec 2010 10:10:50 +0800,
Lin Ming <ming.m.lin@intel.com> a écrit :

> On Sat, 2010-12-25 at 01:26 +0800, matthieu castet wrote:
> > Hi,
> > 
> > Le Tue, 30 Nov 2010 13:00:30 +0800,
> > Lin Ming <ming.m.lin@intel.com> a écrit :
> > 
> > > On Sat, 2010-11-27 at 01:31 +0800, mat wrote:
> > > > Le Tue, 23 Nov 2010 23:55:27 +0100,
> > > > mat <castet.matthieu@free.fr> a écrit :
> > > > 
> > > > > Le Mon, 22 Nov 2010 17:42:47 +0100,
> > > > > Andi Kleen <andi@firstfloor.org> a écrit :
> > > > > 
> > > > > > > That seems to be a S3 specific code path, that won't fix
> > > > > > > anything. Simply do:
> > > > > > > 
> > > > > > > echo 0 > /sys/devices/system/cpu/cpu1/online;
> > > > > > > echo 1 > /sys/devices/system/cpu/cpu1/online;
> > > > > > > 
> > > > > > > and your machine will explode..
> > > > > > 
> > > > > > The SMP startup trampoline is copied I believe
> > > > > > and only executed in real mode without page tables.
> > > > > > 
> > > > > > So it's perhaps not the trampoline, but the early startup 
> > > > > > code that ends up being broken.
> > > > > yes :
> > > > > acpi wakeup code and smp trampoline are copied in low memory
> > > > > (first 1MB).
> > > > > 
> > > > > So they can't end up int the kernel data mapping ?
> > > > > 
> > > > > So it should something else.
> > > > > 
> > > > > I will try to investigate on this.
> > > > > 
> > > > Unfortunately on my laptop supporting NX, suspend to ram seems
> > > > broken (even without this patch) and I got only one core, so I
> > > > am unable to test it.
> > > > 
> > > > Does cpu suspend/resume is broken ? Or it is only S3 ?
> > > > 
> > > > If yes, are there any interesting trace if we suspend only one
> > > > core with sysfs.
> > > 
> > > echo 0 > /sys/devices/system/cpu/cpu1/online;
> > > echo 1 > /sys/devices/system/cpu/cpu1/online;
> > > 
> > > then machine just reboots...
> > > 
> > Ok,
> > 
> > could you try the attached patch ?
> 
> Unfortunately, it does not work against current tip/master(1f7107c8).
> 
> Lin Ming
> 
Thanks for the testing.

For the record I did some tests.
- The x86_32 cpu hotplug is working fine.
- On x86_64 we crash between the cpu1 is wakeup and before trampoline
  jump to start_secondary

A difference between 32 and 64 bit is that head_32.S use
initial_page_table mmu table then switch to swapper_pg_dir
while 64 bit version use init_level4_pgt for trampoline, head and
kernel.

But I fail to see where setting NX is level3_kernel_pgt aera can make
the resume fail. When we enable NX we are in .text section (head_64).


Matthieu
