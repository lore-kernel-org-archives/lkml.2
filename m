Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2JQQv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:51:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46129 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab2JQQvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:51:55 -0400
Date: Wed, 17 Oct 2012 12:39:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: Is: axe read_tscp pvops call. Was: Re: [RFC] ACPI S3 and Xen
 (suprisingly small\!).
Message-ID: <20121017163945.GA28856@phenom.dumpdata.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
 <507ED6C0.4020503@zytor.com>
 <20121017161036.GA10691@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017161036.GA10691@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 12:10:36PM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 17, 2012 at 09:03:12AM -0700, H. Peter Anvin wrote:
> > On 10/17/2012 06:49 AM, Konrad Rzeszutek Wilk wrote:
> > >
> > >Note: These are the other patches that went in 3.7-rc1:
> > >xen/bootup: allow {read|write}_cr8 pvops call [https://lkml.org/lkml/2012/10/10/339]
> > >xen/bootup: allow read_tscp call for Xen PV guests. [https://lkml.org/lkml/2012/10/10/340]
> > >
> > 
> > So WTF do we have a read_tscp PV call?  Again, if there isn't a user
> > we should just axe it...
> 
> Let me spin off a patch to see if that can be done.

It can be done faily easy. That said  the only user that could
_potentially_ use this (if the read_tscp had some extra logic to
do 'readtsc' operations) would be the __vdso_getcpu.

Meaning in __vdso_getcpu we would modify it from native_read_tscp
to paravirt_read_tscp:

notrace long
__vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
{
	unsigned int p;

	if (VVAR(vgetcpu_mode) == VGETCPU_RDTSCP) {
		/* Load per CPU data from RDTSCP */
===>		native_read_tscp(&p);
	} else {
		/* Load per CPU data from GDT */
		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
	}
	if (cpu)
		*cpu = p & 0xfff;
	if (node)
		*node = p >> 12;
	return 0;
}

but that line was added for a purpose, which was
in git commit 8f12dea6135d0a55b151dcb4c6bbe211f5f8d35d
Author: Glauber de Oliveira Costa <gcosta@redhat.com>
Date:   Wed Jan 30 13:31:06 2008 +0100

    x86: introduce native_read_tscp
    
    Targetting paravirt, this patch introduces native_read_tscp, in
    place of rdtscp() macro. When in a paravirt guest, this will
    involve a function call, and thus, cannot be done in the vdso area.
    These users then have to call the native version directly
    
    Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

which implies that it since it is a vDSO area it cannot do paravirt
calls anyhow.

In other words, I think I'm OK with axing it. Going to spin a patch
and ask for some other folks to review/double check.
