Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1BNTsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:48:06 -0500
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:36784 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1BNTsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:48:05 -0500
Message-ID: <4D5986DF.8000808@neli.hopto.org>
Date: Mon, 14 Feb 2011 20:47:43 +0100
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for multiple MSI on x86
References: <4D583E31.4070507@neli.hopto.org> <20110214123443.GF15860@elte.hu>
In-Reply-To: <20110214123443.GF15860@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Micha Nelissen <micha@neli.hopto.org> wrote:
>> Patch is based on earlier patch from Matthew Wilcox.
> 
> Hm, there's an awful lot of 'background', 'implementation', 'advantages', 
> 'disadvantages', 'testing' description missing.

Sorry, my bad, wrong assumption that this would be common knowledge.

PCI devices interrupt the CPU using 'legacy' INTx; or PCI-e devices can 
do a special write, called an MSI (message signaled interrupt). The 
interrupt vector is chosen by the CPU, different devices use different 
vectors so that software can keep the interrupt sources separate 
(instead of using shared INTx "lines").

Most PCI-e devices support what's called MSI-X, but not all do. 
Especially for FPGA based endpoints it's easier to implement only 
'regular' MSI support. MSI-X basically involves implementing a lookup 
table that maps interrupt types in the device to interrupt vectors for 
the CPU. 'Regular' MSI (non MSI-X) only supports a contiguous block of 
interrupt vectors: a base vector with a vector count (which is a power 
of 2).

The x86 code to allocate these interrupt vectors does not handle the <> 
1 vector count case; it would return that it could only handle 1. So 
either device drivers had 1 MSI, or the device should support MSI-X to 
have multiple interrupts (and handlers) for one device.

This patch adds the needed code to support multiple MSI per device.

Advantages: separate interrupt handlers for separate tasks in the 
device. This allows device drivers to be better structured. Easy 
'diagnostics' due to /proc/interrupts counting number of interrupts for 
separate functionality separately.

Disadvantages: more complex code due to requirement that it is a 
contiguous block, so needs some effort to look for a free block with the 
requested count.

Tested: on an Atom platform, with a Xilinx based PCI-e core in FPGA.

Please review; thanks,

Micha
