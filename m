Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2HSCiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:38:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:45157 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab2HSCis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:38:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210411702"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for
 early load ucode
Thread-Topic: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces
 for early load ucode
Thread-Index: AQHNfRunwqP95+1vaUy4HYughHZSRZdgoT4A//+XQYA=
Date: Sun, 19 Aug 2012 02:38:46 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-5-git-send-email-fenghua.yu@intel.com>
 <20120818224442.GB32120@khazad-dum.debian.net>
In-Reply-To: <20120818224442.GB32120@khazad-dum.debian.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Henrique de Moraes Holschuh [mailto:hmh@hmh.eng.br]
> Sent: Saturday, August 18, 2012 3:45 PM
> To: Yu, Fenghua
> Cc: H Peter Anvin; Ingo Molnar; Thomas Gleixner; Mallick, Asit K;
> Tigran Aivazian; Andreas Herrmann; Borislav Petkov; linux-kernel; x86
> Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define
> interfaces for early load ucode
> 
> On Sat, 18 Aug 2012, Fenghua Yu wrote:
> > +	char ucode_name[] =
> "kernel/x86/microcode/GenuineIntel/microcode.hex";
> 
> Why name it ".hex" when you're loading binary data?  I suggest ".bin".
> It
> is confusing to have .hex there, since you're not dealing with the
> Intel HEX
> format, nor anything text-like.
> 
> > +void __init load_ucode_bsp(char *real_mode_data)
> > +{
> > +	u64 ramdisk_image, ramdisk_size, ramdisk_end;
> > +	unsigned long initrd_start, initrd_end;
> > +	struct boot_params *boot_params;
> > +
> > +	boot_params = (struct boot_params *)real_mode_data;
> > +	ramdisk_image = boot_params->hdr.ramdisk_image;
> > +	ramdisk_size  = boot_params->hdr.ramdisk_size;
> > +
> > +#ifdef CONFIG_X86_64
> > +	ramdisk_end  = PAGE_ALIGN(ramdisk_image + ramdisk_size);
> > +	initrd_start = ramdisk_image + PAGE_OFFSET;
> > +#else
> > +	ramdisk_end  = ramdisk_image + ramdisk_size;
> > +	initrd_start = ramdisk_image;
> > +#endif
> > +	initrd_end = initrd_start + ramdisk_size;
> > +
> > +	/*
> > +	 * It's early to get CPU vendor info at this point.
> > +	 * By searching initrd to find right name for vendor's microcode,
> > +	 * it's relative easier to get CPU vendor info.
> > +	 */
> > +	if (find_ucode_intel(initrd_start, initrd_end) == UCODE_OK)
> > +		load_ucode_intel_bsp(real_mode_data);
> > +}
> 
> I'd say something down the load_ucode_intel_bsp() chain better check
> the CPU
> vendor to make sure the Intel driver won't attempt to load microcode on
> some
> other vendor's processor.
> 
> Or are cpu signatures a global namespace and x86 cpu vendors make sure
> (past, present and future) to never use the same cpu signature as
> someone
> else is going to use?  Anyway, it would still might be a good thing to
> do
> the vendor check somewhere to avoid wasting time going over every
> microcode
> of the wrong vendor on generic boot images that have both AMD and Intel
> microcode.
> 

In this early phase, detecting vendor in initrd is much simpler code. Otherwise, detecting vendor by cpuid (and without cpuid) needs similar but different code as existing functions and coding would be awkward. 

I fully thought and agreed the usage complexity you describe here. It might be good thing to do a bit ugly but more practical coding here.

Thanks.

-Fenghua
