Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935623Ab0KQWnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:43:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64363 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070Ab0KQWnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:43:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: BKL: remove extraneous #include <smp_lock.h>
Date: Wed, 17 Nov 2010 23:43:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <201011172159.oAHLx1tu001236@hera.kernel.org> <20101117140526.d532b373.randy.dunlap@oracle.com> <AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com>
In-Reply-To: <AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011172343.07949.arnd@arndb.de>
X-Provags-ID: V02:K0:H78vDRu7fwiAm7UYHwz9B44PGP6v005reACix5zKVOG
 zwlPVvnNWpPIRjcjKYDeGJa7zoNh8GAXTLfvhUzEI9p1CdihWL
 9Ln/6uAlFeqRtzcD2eMd4Qcm87mKeiw4Kp4nBqhy3PBrImp15Q
 VH7f6ZBQBj/mooB9CMU7rn+H1dtRyjafZnvpKwI4wCdvHaazmU
 oTKXWBwXylF7hhqXKizIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 November 2010 23:23:23 Linus Torvalds wrote:
> On Wed, Nov 17, 2010 at 2:05 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> Hmm. I think that part was a mistake, but I suspect the simplest fix
> for it is to simply get rid of "kernel_locked()". It has no other
> users than the hardirq.h one, so let's just move it there.
> 
> Something like the attached?
> 
> NOTE! The reason I only take the CONFIG_LOCK_KERNEL version from
> smp_lock.h is because:
> 
>  - LOCK_KERNEL is defined by init/Kconfig as "(SMP || PREEMPT) && BKL"
> 
>  - inside hardirq.h we only use "kernel_locked()" inside "PREEMPT && BKL"
> 
>  - so "PREEMPT && BKL" implies "LOCK_KERNEL"
> 
>  - so the !LOCK_KERNEL kernel_locked() case is irrelevant.
> 
> unless I did a thinko somewhere.
> 
> Does this work in all configurations? TOTALLY UNTESTED! Caveat emptor.

It looks completely right, thanks for diving into the problem yourself!

The script that I used to create the broken patch removed the smp_lock.h
include from all files that did not call any of lock_kernel, unlock_lernel,
release_kernel_lock and reacquire_kernel_lock, but I missed kernel_locked().

I did not find it in my own build tests, I only tested PREEMPT with BKL
disabled and vice versa and the mails about the build failure in -next
reached me after you had already pulled the patch.

	Arnd
