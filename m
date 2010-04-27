Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0D0PM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:12:28 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:30010 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0D0PM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:12:26 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai <yinghai.lu@oracle.com>
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below    BIOS_END
Date: Tue, 27 Apr 2010 09:11:10 -0600
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
References: <2b1eecc3-75b8-4ab3-8932-fdf7cc1e181b@email.android.com> <alpine.LFD.2.00.1004261824570.3739@i5.linux-foundation.org> <4BD640E3.1050101@oracle.com>
In-Reply-To: <4BD640E3.1050101@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004270911.12124.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 April 2010 07:41:55 pm Yinghai wrote:
> On 04/26/2010 06:27 PM, Linus Torvalds wrote:
> > Do we actually have a regression left with Bjorn's patch?

After the pcibios_align_resource() patch, I'm not aware of any regressions.

But let's double-check this:

> also find one AMD system:
> [    7.056011] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xffffffff]
> ...
> pci assign unassign code could use range like [mem 0xfed20000-0xffffffff] wrongly.

I agree, it's very unlikely that it's safe to put PCI devices all the
way up to 0xffffffff.  I suspect this might be fixed by d558b483d5a,
which computes the end of the bridge window using _MAX rather than _LEN.

See https://bugzilla.kernel.org/show_bug.cgi?id=15480#c15 for an example
similar to the one above: we originally thought the window was
[mem 0xcff00000-0xffffffff], but d558b483d5a changes that to
[mem 0xcff00000-0xfebfffff], which matches what Windows found.

Yinghai, can you take a look at your AMD system again with a kernel that
includes d558b483d5a, and see whether we still have a problem?  If we
*do* still have a problem, please open a bugzilla and attach a dmesg log
with ACPI resource info collected with the debug patch here:
https://bugzilla.kernel.org/show_bug.cgi?id=15533#c5

Bjorn
