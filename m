Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab1CUXko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:40:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669Ab1CUXiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:38:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/6] Do not use sysdevs for implementing "core" PM operations on x86
Date: Tue, 22 Mar 2011 00:31:22 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        cpufreq@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl>
In-Reply-To: <201103122212.40828.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <201103220031.22729.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, March 12, 2011, Rafael J. Wysocki wrote:
> On Thursday, March 10, 2011, Rafael J. Wysocki wrote:
> > There are multiple problems with sysdevs, or struct sys_device objects to
> > be precise, that are so annoying that some people have started to think
> > of removind them entirely from the kernel.  To me, personally, the most
> > obvious issue is the way sysdevs are used for defining suspend/resume
> > callbacks to be executed with one CPU on-line and interrupts disabled.
> > Greg and Kay may tell you more about the other problems with sysdevs. :-)
> > 
> > Some subsystems need to carry out certain operations during suspend after
> > we've disabled non-boot CPUs and interrupts have been switched off on the
> > only on-line one.  Currently, the only way to achieve that is to define
> > sysdev suspend/resume callbacks, but this is cumbersome and inefficient.
> > Namely, to do that, one has to define a sysdev class providing the callbacks
> > and a sysdev actually using them, which is excessively complicated.  Moreover,
> > the sysdev suspend/resume callbacks take arguments that are not really used
> > by the majority of subsystems defining sysdev suspend/resume callbacks
> > (or even if they are used, they don't really _need_ to be used, so they
> > are simply unnecessary).  Of course, if a sysdev is only defined to provide
> > suspend/resume (and maybe shutdown) callbacks, there's no real reason why
> > it should show up in sysfs.
> > 
> > For this reason, I thought it would be a good idea to provide a simpler
> > interface for subsystems to define "very late" suspend callbacks and
> > "very early" resume callbacks (and "very late" shutdown callbacks as well)
> > without the entire bloat related to sysdevs.  The interface is introduced
> > by the first of the following patches, while the second patch converts some
> > sysdev users related to the x86 architecture to using the new interface.
> > 
> > I believe that call sysdev users who need to define suspend/resume/shutdown
> > callbacks may be converted to using the interface provided by the first patch,
> > which in turn should allow us to convert the remaining sysdev functionality
> > into "normal" struct device interfaces.  Still, even if that turns out to be
> > too complicated, the bloat reduction resulting from the second patch kind of
> > shows that moving at least some sysdev users to a simpler interface (like in
> > the first patch) is a good idea anyway.
> > 
> > This is a proof of concept, so the patches have not been tested.  Please be
> > extrememly careful, because they touch sensitive code, so to speak.  In the
> > majority of cases the changes are rather straightforward, but there are some
> > more interesting cases as well (io_apic.c most importantly).
> 
> Since Greg likes the idea and there haven't been any objections so far, here's
> the official submission.  The patches have been tested on HP nx6325 and
> Toshiba Portege R500.
> 
> Patch [1/8] is regareded as 2.6.38 material, following Greg's advice.  The
> other patches in the set are regarded as 2.6.39 material.  The last one
> obviously depends on all of the previous ones.
> 
> [1/8] - Introduce struct syscore_ops for registering operations to be run on
>         one CPU during suspend/resume/shutdown.
> 
> [2/8] - Convert sysdev users in arch/x86 to using struct syscore_ops.
> 
> [3/8] - Make ACPI use struct syscore_ops for irqrouter_resume().
> 
> [4/8] - Make timekeeping use struct syscore_ops for suspend/resume.
> 
> [5/8] - Make Intel IOMMU use struct syscore_ops for suspend/resume.
> 
> [6/8] - Make KVM use struct syscore_ops for suspend/resume.
> 
> [7/8] - Make cpufreq use struct syscore_ops for boot CPU suspend/resume.
> 
> [8/8] - Introduce config switch allowing architectures to skip sysdev
>         suspend/resume/shutdown code.
> 
> If there are no objectsions, I'd like to push these patches through the suspend
> tree.

[1/8] has been merged in the meantime and [3/8] has been included into the
ACPI tree.  if there are no objections, I'm going to push the following
patches to Linus this week through the suspend-2.6 tree:

[1/6] - Convert sysdev users in arch/x86 to using struct syscore_ops.

[2/6] - Make timekeeping use struct syscore_ops for suspend/resume.
 
[3/6] - Make Intel IOMMU use struct syscore_ops for suspend/resume.

[4/6] - Make KVM use struct syscore_ops for suspend/resume.

[5/6] - Make cpufreq use struct syscore_ops for boot CPU suspend/resume.

[6/6] - Introduce config switch allowing architectures to skip sysdev
        suspend/resume/shutdown code.

Thanks,
Rafael

