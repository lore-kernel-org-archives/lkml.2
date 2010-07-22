Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab0GVVZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:25:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33011 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab0GVVZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=N/uzydSEkQ8wTlUA7NSzNwZ5MADt+/YXesQ9Y8hFqlt1oMlfWEDKe+rWJl3pytV57+
         azSDzd0fYasGtC6X9E1+ceOtZQkIuTRJRomS524JThJ8tAQHeV12bmlkhdM0ypw81rJJ
         G0Hiz8J9wVKBQGeJ96gOg2441SenqNJvieYto=
Message-ID: <4C48B730.30708@gmail.com>
Date: Thu, 22 Jul 2010 22:25:04 +0100
From: Iain <selsinork@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Andi Kleen <andi@firstfloor.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "Yu, Luming" <luming.yu@intel.com>,
        Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki@google.com" <venki@google.com>
Subject: Re: [PATCH] ACPI: make acpi_idle Nehalem-aware
References: <20100427124703.GA16706@jgarrett.org> <alpine.LFD.2.00.1004301218280.2489@sony> <20100430174447.GA14889@srcf.ucam.org> <d7f2dd35a4361e5156079278543769a0@localhost> <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain> <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com> <20100525124325.GC7876@srcf.ucam.org> <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain> <20100525185507.GA15997@srcf.ucam.org> <alpine.LFD.2.00.1007211729550.409@localhost.localdomain> <20100722074750.GA22520@one.firstfloor.org> <alpine.LFD.2.00.1007221153120.3164@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1007221153120.3164@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> However, we'll still have issues with systems
> like the HP DL360 G6 which explicity set the
> flag to ask for BM_STS checking and configure
> the chipset such that BM_STS is active.
> That may require a BIOS fix, or we may
> have to run intel_idle on that box --
> since intel_idle ignores BM_STS always
> and instead relies on drivers to use pm_qos
> to register device latency constraints.

I'm curious as to why you see a problem with the DL380G6 as the one I have here happily sits in C6 when idle.

your turbostat util shows:

  CPU  GHz  TSC   %c0    %c1    %c3    %c6   %pc3   %pc6
  avg 1.64 2.27   0.16   0.12   0.00  99.71   0.00  90.15

and powertop has results like:

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 0,1%)       Turbo Mode     0,0%
polling           0,0ms ( 0,0%)         2,27 Ghz     0,0%
C1 mwait          0,1ms ( 0,0%)         2,13 Ghz     0,0%
C2 mwait          1,0ms ( 0,0%)         2,00 Ghz     0,0%
C3 mwait         90,4ms (99,9%)         1,60 Ghz   100,0%

this is with v2.6.35-rc5-176-gcd5b8f8 and using acpi_idle. I've deliberately disabled intel_idle to test, however using intel_idle 
gives almost identical results.

Looking at the bug 15886, the Access Size 0x03 entries you mentioned are all 0x01 on this system. I've also uploaded the acpidump 
from this DL380G6 to that bug so that you can check I've not just looked in the wrong place.

Did the first acpidump come from a system with the 'HP Power Regulator' setting in the bios set to OS Control mode ?  My system is 
set this way and it seems to work as expected.
The other settings for this option appear to be designed to override OS power management controls, for example the description of 
the 'Static High Performance' option suggests it'll somehow force the CPU to operate in the highest performance mode all of the 
time: "HP Static High Performance Mode: Processors will run in their maximum power/performance state at all times regardless of the 
OS power management policy".

If this does turn out to be as simple as a bios setting, should we really be trying to workaround what may be a legitimate decision 
by the servers admin ?

Iain
