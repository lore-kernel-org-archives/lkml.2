Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2HSEnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 00:43:09 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44348 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab2HSEnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 00:43:07 -0400
X-Sasl-enc: WZfIS6iQ7N+/DCDLg3b0/jWkcaXHzlDbPnOgK/18X8jd 1345351385
Date: Sun, 19 Aug 2012 01:43:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces
 for early load ucode
Message-ID: <20120819044302.GB9773@khazad-dum.debian.net>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-5-git-send-email-fenghua.yu@intel.com>
 <20120818224442.GB32120@khazad-dum.debian.net>
 <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2012, Yu, Fenghua wrote:
> > From: Henrique de Moraes Holschuh [mailto:hmh@hmh.eng.br]
> > On Sat, 18 Aug 2012, Fenghua Yu wrote:
> > > +	char ucode_name[] =
> > "kernel/x86/microcode/GenuineIntel/microcode.hex";
> > 
> > Why name it ".hex" when you're loading binary data?  I suggest ".bin".
> > It
> > is confusing to have .hex there, since you're not dealing with the
> > Intel HEX
> > format, nor anything text-like.
> > 
> > > +void __init load_ucode_bsp(char *real_mode_data)
> > > +{
> > > +	u64 ramdisk_image, ramdisk_size, ramdisk_end;
> > > +	unsigned long initrd_start, initrd_end;
> > > +	struct boot_params *boot_params;
> > > +
> > > +	boot_params = (struct boot_params *)real_mode_data;
> > > +	ramdisk_image = boot_params->hdr.ramdisk_image;
> > > +	ramdisk_size  = boot_params->hdr.ramdisk_size;
> > > +
> > > +#ifdef CONFIG_X86_64
> > > +	ramdisk_end  = PAGE_ALIGN(ramdisk_image + ramdisk_size);
> > > +	initrd_start = ramdisk_image + PAGE_OFFSET;
> > > +#else
> > > +	ramdisk_end  = ramdisk_image + ramdisk_size;
> > > +	initrd_start = ramdisk_image;
> > > +#endif
> > > +	initrd_end = initrd_start + ramdisk_size;
> > > +
> > > +	/*
> > > +	 * It's early to get CPU vendor info at this point.
> > > +	 * By searching initrd to find right name for vendor's microcode,
> > > +	 * it's relative easier to get CPU vendor info.
> > > +	 */
> > > +	if (find_ucode_intel(initrd_start, initrd_end) == UCODE_OK)
> > > +		load_ucode_intel_bsp(real_mode_data);
> > > +}
> > 
> > I'd say something down the load_ucode_intel_bsp() chain better check
> > the CPU
> > vendor to make sure the Intel driver won't attempt to load microcode on
> > some
> > other vendor's processor.
> > 
> > Or are cpu signatures a global namespace and x86 cpu vendors make sure
> > (past, present and future) to never use the same cpu signature as
> > someone
> > else is going to use?  Anyway, it would still might be a good thing to
> > do
> > the vendor check somewhere to avoid wasting time going over every
> > microcode
> > of the wrong vendor on generic boot images that have both AMD and Intel
> > microcode.
> > 
> 
> In this early phase, detecting vendor in initrd is much simpler code. Otherwise, detecting vendor by cpuid (and without cpuid) needs similar but different code as existing functions and coding would be awkward. 
> 
> I fully thought and agreed the usage complexity you describe here. It might be good thing to do a bit ugly but more practical coding here.

Sure, there is no harm in defering the implementation of this check to later
versions of the patch set.  As long as the final patch set doesn't risk
loading microcode on the wrong vendor or waste a lot of milliseconds trying
to match intel microcode to a non-intel cpu, I have no objections  :-)

But what about the ".hex" naming for the microcode bundle (container) name?
I find it confusing, since the file contains binary data, not structured
text representing binary data using base 16...  this is also something that
is of minor importance, but at least it is a very easy thing to change at
this point.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
