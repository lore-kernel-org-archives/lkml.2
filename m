Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1BEBNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 20:13:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55975 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab1BEBNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 20:13:44 -0500
Message-ID: <4D4CA3FD.6000901@zytor.com>
Date: Fri, 04 Feb 2011 17:12:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: castet.matthieu@free.fr, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu> <1296566732.4d4809cc1f963@imp.free.fr> <20110202062632.GA12256@elte.hu>
In-Reply-To: <20110202062632.GA12256@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 10:26 PM, Ingo Molnar wrote:
> 
> So why not call set_memory_x() in your patch? Mind trying that?
> 
> Thanks,
> 
> 	Ingo

So I just tried that... it doesn't work.  The resulting pages still end
up NX:

---[ Kernel Mapping ]---
0xc0000000-0xc00a0000         640K     RW             GLB NX pte

This implies that the NX protection is applied after these allocations
happen, which is probably why the ugly hack in static_protections() to
set the PCI BIOS +x is there as well.

I have to admit to being rather at a loss for where in the boot sequence
the NX mappings get set up, despite staring at the code for some time.
mark_nxdata_nx() seems to only mark the kernel data/rodata and init
region... even though the latter is already done in free_init_pages().
It is also run way, way, way too late in the process -- why on earth
should we not have these protections during the driver initialization
phase of booting?

I talked to Suresh about the whole static_protections() bit, and as far
as he recalls it is because the entire set_memory_*() interface is
misdesigned to work on all aliases of a page, despite the fact that
protections are per mapping, not per physical page.

However, this isn't something we can fix for .38... I suspect
unprotecting the entire 0-640K region might just make most sense, and
then we need to do some serious restructuring of the entire handling of
this stuff, because it's broken seven ways to Sunday.

	-hpa
