Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0LXR04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 12:26:56 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:59363 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab0LXR0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 12:26:54 -0500
Date: Fri, 24 Dec 2010 18:26:44 +0100
From: matthieu castet <castet.matthieu@free.fr>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX protection
 for kernel data)
Message-ID: <20101224182644.062bdb3f@mat-laptop>
In-Reply-To: <1291093230.2405.191.camel@minggr.sh.intel.com>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
	<1290431008.2072.119.camel@laptop>
	<1290443379.4cea9a73cd9ce@imp.free.fr>
	<1290443758.2072.318.camel@laptop>
	<20101122164247.GC21836@basil.fritz.box>
	<20101123235527.54293b59@mat-laptop>
	<20101126183144.300a71a4@mat-laptop>
	<1291093230.2405.191.camel@minggr.sh.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/jiVnnPOMKDTzHAhDvedD2cc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/jiVnnPOMKDTzHAhDvedD2cc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Le Tue, 30 Nov 2010 13:00:30 +0800,
Lin Ming <ming.m.lin@intel.com> a =E9crit :

> On Sat, 2010-11-27 at 01:31 +0800, mat wrote:
> > Le Tue, 23 Nov 2010 23:55:27 +0100,
> > mat <castet.matthieu@free.fr> a =E9crit :
> >=20
> > > Le Mon, 22 Nov 2010 17:42:47 +0100,
> > > Andi Kleen <andi@firstfloor.org> a =E9crit :
> > >=20
> > > > > That seems to be a S3 specific code path, that won't fix
> > > > > anything. Simply do:
> > > > >=20
> > > > > echo 0 > /sys/devices/system/cpu/cpu1/online;
> > > > > echo 1 > /sys/devices/system/cpu/cpu1/online;
> > > > >=20
> > > > > and your machine will explode..
> > > >=20
> > > > The SMP startup trampoline is copied I believe
> > > > and only executed in real mode without page tables.
> > > >=20
> > > > So it's perhaps not the trampoline, but the early startup=20
> > > > code that ends up being broken.
> > > yes :
> > > acpi wakeup code and smp trampoline are copied in low memory
> > > (first 1MB).
> > >=20
> > > So they can't end up int the kernel data mapping ?
> > >=20
> > > So it should something else.
> > >=20
> > > I will try to investigate on this.
> > >=20
> > Unfortunately on my laptop supporting NX, suspend to ram seems
> > broken (even without this patch) and I got only one core, so I am
> > unable to test it.
> >=20
> > Does cpu suspend/resume is broken ? Or it is only S3 ?
> >=20
> > If yes, are there any interesting trace if we suspend only one core
> > with sysfs.
>=20
> echo 0 > /sys/devices/system/cpu/cpu1/online;
> echo 1 > /sys/devices/system/cpu/cpu1/online;
>=20
> then machine just reboots...
>=20
Ok,

could you try the attached patch ?

Thanks

Matthieu

--MP_/jiVnnPOMKDTzHAhDvedD2cc
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=x64_nx_data.diff

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 71a5929..d86552f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -790,6 +790,7 @@ void mark_rodata_ro(void)
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
 	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
+	unsigned long data_end = PAGE_ALIGN((unsigned long) &_edata);
 	unsigned long data_start = (unsigned long) &_sdata;
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
@@ -802,7 +803,7 @@ void mark_rodata_ro(void)
 	 * The rodata section (but not the kernel text!) should also be
 	 * not-executable.
 	 */
-	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
+	set_memory_nx(rodata_start, (data_end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
 

--MP_/jiVnnPOMKDTzHAhDvedD2cc--
