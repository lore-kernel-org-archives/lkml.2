Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0KOJou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:44:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52935 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab0KOJot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:44:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2.6.36 1/1 RESEND] kernel SPIN_LOCK_UNLOCKED changed to __SPIN_LOCK_UNLOCKED()
Date: Mon, 15 Nov 2010 10:44:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: Atul Sowani <sowani@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com,
        ralf@linux-mips.org
References: <4CDED96A.9080404@gmail.com> <20101115092404.GA24194@n2100.arm.linux.org.uk>
In-Reply-To: <20101115092404.GA24194@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011151044.36213.arnd@arndb.de>
X-Provags-ID: V02:K0:P8jEJt/pUYja8eyrwKeR59hEcOOB9oeas/rPS3gisx6
 Td2Q+WMNixW6zvpolMVemKeBP+iVq0UJfleB8mK4WfhynT1Q17
 iv3MzpBrvH4PxQst59uP+cKblMT3cIMa9IYlmeJZSm/3ceyTrg
 Vvzrr22sEmsMrnD0YUlq1ifnTIoMDlzrBXf2zK8BLV4F704w5k
 tHwEOMN1n1VRux0uh23gw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 November 2010 10:24:04 Russell King - ARM Linux wrote:
> > diff -uprN a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> > --- a/arch/arm/kernel/smp.c   2010-10-21 02:00:22.000000000 +0530
> > +++ b/arch/arm/kernel/smp.c   2010-11-07 00:47:32.000000000 +0530
> > @@ -56,7 +56,7 @@ struct ipi_data {
> >  };
> > 
> >  static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
> > -     .lock   = SPIN_LOCK_UNLOCKED,
> > +     .lock   = __SPIN_LOCK_UNLOCKED(ipi_data.lock),
> >  };
> 
> This lock is in the percpu data area.  This means that when other CPUs
> are brought online, and therefore other percpu areas are instantiated,
> this lock will be mis-initialized (the pointers et.al. will be pointing
> at the original percpu instance.)
> 
> So NAK, this will break.

I believe right now we only use the argument of __SPIN_LOCK_UNLOCKED
as an identifier string for lockdep, but not for any pointers, so the
patch would actually do what was intended, but break if we ever start
relying on the pointer.

Maybe we can mangle the argument in some way to make sure it will break
at build time when that happens, e.g.

     .lock   = __SPIN_LOCK_UNLOCKED(ipi_data.__lock)

This would at least let us remove SPIN_LOCK_UNLOCKED.

	Arnd
