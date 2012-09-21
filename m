Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2IUOBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:01:41 -0400
Received: from mail.x86-64.org ([217.9.48.20]:50610 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab2IUOBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:01:39 -0400
Date: Fri, 21 Sep 2012 16:01:33 +0200
From: Borislav Petkov <bp@amd64.org>
To: Josh Hunt <johunt@akamai.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
Message-ID: <20120921140133.GA27890@aftab.osrc.amd.com>
References: <20120912154943.GB12103@aftab.osrc.amd.com>
 <5050B708.5020308@akamai.com>
 <20120912164843.GC12103@aftab.osrc.amd.com>
 <5050BF1F.1080503@akamai.com>
 <20120912170629.GD12103@aftab.osrc.amd.com>
 <20120912172351.GE12103@aftab.osrc.amd.com>
 <50532940.10201@akamai.com>
 <50534184.1050208@akamai.com>
 <20120921123645.GD26869@aftab.osrc.amd.com>
 <505C6558.1040405@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505C6558.1040405@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 08:02:16AM -0500, Josh Hunt wrote:
> On 09/21/2012 07:36 AM, Borislav Petkov wrote:
> >Ok, I think this is still the old code you're looking at so it would be
> >cool if you could test with my patchset I sent you last week.
> >
> >Because with it, it all looks fine on my K8 here:
> >
> >It has 2 2048MB single-ranked DIMMs on each node and edac output looks
> >like this:
> >
> >[   52.920302] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00000060
> >[   52.920302] EDAC MC: DCT0 chip selects:
> >[   52.920304] EDAC amd64: MC: 0:     0MB 1:     0MB
> >[   52.920305] EDAC amd64: MC: 2:  2048MB 3:  2048MB
> >[   52.920306] EDAC amd64: MC: 4:     0MB 5:     0MB
> >[   52.920308] EDAC amd64: MC: 6:     0MB 7:     0MB
> >
> >...
> >
> >[   52.920344] EDAC DEBUG: init_csrows: node 1, NBCFG=0x0ad00044[ChipKillEccCap: 1|DramEccEn: 1]
> >[   52.920345] EDAC DEBUG: init_csrows: MC node: 1, csrow: 2
> >[   52.920346] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, DBAM idx: 6
> >[   52.920347] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 524288
> >[   52.920348] EDAC amd64: CS2: Registered DDR2 RAM
> >[   52.920350] EDAC DEBUG: init_csrows: Total csrow2 pages: 524288
> >[   52.920351] EDAC DEBUG: init_csrows: MC node: 1, csrow: 3
> >[   52.920352] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 0, DBAM idx: 6
> >[   52.920353] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 524288
> >[   52.920354] EDAC amd64: CS3: Registered DDR2 RAM
> >[   52.920355] EDAC DEBUG: init_csrows: Total csrow3 pages: 524288
> >
> >$ cat /sys/devices/system/edac/mc/mc0/csrow2/size_mb
> >2048
> >$ cat /sys/devices/system/edac/mc/mc0/csrow3/size_mb
> >2048
> >
> >So what am I missing?
> >
> >Thanks.
> 
> I'm running with your edac-queue branch with the last commit being:
>  9d67117feece8852570cc8ee25b68c41f8def323
> 
> You can verify this with my dmesg (also attached) showing the new
> dbg messages added:
> 
> <patch>
> +       edac_dbg(0, "csrow: %d, channel: %d, DBAM idx: %d\n",
> +                   csrow_nr, dct,  cs_mode);
> +       edac_dbg(0, "nr_pages/channel: %u\n", nr_pages);
> </patch>
> 
> <dmesg>
> [   25.838822] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel:
> 0, DBAM idx: 2
> [   25.838823] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> </dmesg>
> 
> Please let me know if this is the wrong version and I can rerun with
> the correct one.

Ah ok, my bad, I have 4 more patches ontop which should deal with the
channel doubling, please repull the same branch which I've just updated.

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git edac-queue

and retest.

And you're right about WIDTH_128 - it actually denotes the channel width
and the code wrongly uses it to say that there are two channels on K8.

However, this has been the case since the driver went upstream and I
need to think a bit harder when correcting that so that I don't upset
something else in it.

Also, it would be very helpful if you send me full dmesg after you've
applied the latest patches so that I can have another reference when
changing the WIDTH_128 thing.

Thanks for your help.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
