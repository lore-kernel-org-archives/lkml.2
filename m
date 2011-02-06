Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1BFXmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:42:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33244 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab1BFXmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:42:07 -0500
Message-ID: <4D4F31BC.3000709@zytor.com>
Date: Sun, 06 Feb 2011 15:41:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: castet.matthieu@free.fr
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu> <1296566732.4d4809cc1f963@imp.free.fr> <20110202062632.GA12256@elte.hu> <4D4CA3FD.6000901@zytor.com> <1296924395.4d4d7eeb6f1fe@imp.free.fr>
In-Reply-To: <1296924395.4d4d7eeb6f1fe@imp.free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2011 08:46 AM, castet.matthieu@free.fr wrote:
> You could remove PCI BIOS +x hack in static protection, and the x mapping will
> be set by set_memory_x().
> 
> The problem is that acpi_reserve_wakeup_memory is called too early, before we
> build the page table with kernel_physical_mapping_init.
> 
> Doing the setting in a arch_initcall make it work.

No, the problem is that the code is braindamaged and don't take into
account reserved areas or have a mechanism for marking the reserved
areas so that kernel_physical_mapping_init can do the right thing... and
then it's hacked around instead of done properly.

We obviously need to reserve this memory very early in order to make
sure it exists, and init_memory_mapping() ->
kernel_physical_mapping_init() really should be able to deal with that
(for example by walking the list of reserved memory regions and look
which ones of them should have specific protection bits -- not just NX
-- set appropriately.)

The trampoline unification patch could have made this less broken, but
that code is certainly not ready for .38.

I'm officially proposing that we mark the low 1 MiB +x for .38, and do
something saner for .39, including my finishing the trampoline
unification code.

Ingo: ok with you?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
