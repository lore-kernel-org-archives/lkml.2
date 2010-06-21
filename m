Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab0FUR15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:27:57 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:17582 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab0FUR14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:27:56 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai.lu@oracle.com>
Subject: Re: [Bug 16007] x86/pci Oops with CONFIG_SND_HDA_INTEL
Date: Mon, 21 Jun 2010 11:28:11 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Graham Ramsey <ramsey.graham@ntlworld.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       Myron Stowe <myron.stowe@hp.com>,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>
References: <4BF40014.30303@ntlworld.com> <201006111549.05164.bjorn.helgaas@hp.com> <4C12C189.50201@oracle.com>
In-Reply-To: <4C12C189.50201@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006211128.12889.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the best long-term fix is to always enable "pci=use_crs",
regardless of the BIOS date (currently we only do it for 2008 and
newer).  System designers and BIOS writers expect the OS to pay
attention to that information, and indications are that Windows
does use it, so I think we will ultimately be better off if we
use the expected, best-tested path.

However, we have at least one known Linux issue (bug #16228) when
_CRS is enabled, so I'm hesitant to enable it unconditionally at
least until that is resolved.

In the short term, I think we should apply Graham's quirk from
comment #8, which enables pci=use_crs just for his system.

Here's my response to Yinghai's patches.  ACPI gives us these resources:
  pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xff37ffff] (bus 00)
  pci_root PNP0A08:00: host bridge window [mem 0xfebfc000-0xfebfffff] (bus 80)

Yinghai's patch (comment #17, with a v2 posted to the list but not in
the bugzilla), gives us these resources:
  pci_bus 0000:00: resource 5 [mem 0x80000000-0xfcffffffff]
  pci_bus 0000:80: resource 5 [mem 0x80000000-0xfcffffffff]

I think it's just a bad idea to assign the same range to both buses,
especially when the BIOS is telling us what we should be using.

I also think it's a mistake to mess with the resource code to deal
with this specific case.  A change like that makes resource.c hard
to understand and maintain in the future.
