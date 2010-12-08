Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab0LHVht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:37:49 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:21170 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab0LHVhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:37:46 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 0/5] resources: add arch hook for preventing allocation in reserved areas
Date: Wed, 8 Dec 2010 14:37:34 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
References: <20101208213606.13026.47657.stgit@bob.kio>
In-Reply-To: <20101208213606.13026.47657.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012081437.34539.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crap, here's the cover letter I meant to include.

[RFC] PCI, PNP, resources: effectively reserve ACPI device resources

2.6.37-rc includes some patches of mine to change the way we allocate address
space for devices, and these caused some regressions.

Most device resource allocation is done by the BIOS, but Linux does allocate
space if the BIOS doesn't do it (e.g., for CardBus or other hotplug devices)
or if the BIOS did it wrong (e.g., it put a PCI device outside the host bridge
windows).

My original 2.6.37-rc patches make Linux allocate space from the top down
instead of from the bottom up.  We did this because that's what Windows does,
and doing it the same way helps us avoid some BIOS defects, such as
https://bugzilla.kernel.org/show_bug.cgi?id=16228 .

The regressions caused by these changes include:

https://bugzilla.kernel.org/show_bug.cgi?id=23332

    Here, we allocated a 64MB bridge window for a subtractive-decode bridge
    leading to a CardBus controller, and the window conflicts with devices not
    reported by the BIOS.  Windows doesn't see this problem because it relies
    on the fact that the bridge is in subtractive-decode mode and doesn't
    program the window at all.

https://bugzilla.kernel.org/show_bug.cgi?id=23542
https://bugzilla.kernel.org/show_bug.cgi?id=23802

    In both cases, Linux allocated space that conflicts with an ACPI device
    because it ignores resource usage reported by ACPI.  Windows avoids this
    problem because it pays attention to the ACPI _CRS methods that report
    device resource usage.

I think the best way to address these problems would be to put ACPI device
resources in the resource maps, just like we do for PCI devices.  We tried this
a couple years ago (http://lkml.org/lkml/2007/11/1/214) and tripped over some
subtle issues.  We should try again, but not at this stage of the -rc.

Instead, these patches take the approach of adding a filter in the
allocate_resource() path so each arch can prevent allocation of any address
ranges it cares about.  For x86, that means looking through all the PNP
devices and protecting the address space they use.

In addition, for 23332, I added a quirk that builds a fake PNP device to
protect the unreported devices.  I'm a little nervous about this because I've
been told that the WHQL tests look for unreported devices, and the HP nx6325
should have passwd.  But it's the best I can think of for now.

Bjorn
