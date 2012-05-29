Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2E2PXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 11:23:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab2E2PXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 11:23:41 -0400
Message-ID: <4FC4E9EB.5030801@redhat.com>
Date: Tue, 29 May 2012 12:23:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
References: <1337358773-6919-38-git-send-email-mchehab@redhat.com> <1337854460-25191-1-git-send-email-mchehab@redhat.com> <20120524105604.GC27063@aftab.osrc.amd.com> <4FBE5E1D.7070804@redhat.com> <20120524164554.GM27063@aftab.osrc.amd.com> <4FBE7755.2080301@redhat.com> <20120529115851.GB29157@aftab.osrc.amd.com> <4FC4D6E2.9060501@redhat.com> <20120529145245.GG29157@aftab.osrc.amd.com>
In-Reply-To: <20120529145245.GG29157@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-05-2012 11:52, Borislav Petkov escreveu:
> On Tue, May 29, 2012 at 11:02:10AM -0300, Mauro Carvalho Chehab wrote:
>> It seems you were unable to read the comments at the function that fills dimm->grain:
>>
>> 	/*
>> 	 * The dram rank boundary (DRB) reg values are boundary addresses
>> 	 * for each DRAM rank with a granularity of 64MB.  DRB regs are
>> 	 * cumulative; the last one will contain the total memory
>> 	 * contained in all ranks.
> 
> This looks like a bug:
> 
> "The DRAM Rank Boundary Register defines the upper boundary address
> of each DRAM rank with a granularity of 32 MB. Each rank has its own
> single-byte DRB register. These registers are used to determine which
> chip select will be active for a given address."
> 
> This is from http://www.intel.com/Assets/PDF/datasheet/306828.pdf which
> is 955X but it should be documenting the same thing - DRB.

Maybe i3200 is similar to 955x. I dunno, as I didn't write this driver.

> Now, if I'm reporting an error address and I'm saying "you had an error
> at X, but this error is somewhere in the X+64MB region", then I can
> simply say which rank it is. And we're doing that already with the
> layer-things.

Doesn't make sense, as a rank is bigger than 64 MB. I suspect that the
work "rank" is used to indicate something else, like the DRAM bank.

If so, an address at the 64MB region could be used to identify the DRAM
chip.

> 
> [ … ]
> 
>> That means that any correlation function used by an stochastic process
>> analysis will need to take the grain into account, in order to detect
>> if a series of errors are due to a random noise, or if they're due to
>> a physical problem at the device.
> 
> Dude, stop talking crap and concentrate. On which planet is granularity
> of the error 64 MB?
> 
> From <Documentation/edac.txt>:
> 
> ============================================================================
> SYSTEM LOGGING
> 
> If logging for UEs and CEs are enabled then system logs will have
> error notices indicating errors that have been detected:
> 
> EDAC MC0: CE page 0x283, offset 0xce0, grain 8, syndrome 0x6ec3, row 0,
> channel 1 "DIMM_B1": amd76x_edac
> 
> EDAC MC0: CE page 0x1e5, offset 0xfb0, grain 8, syndrome 0xb741, row 0,
> channel 1 "DIMM_B1": amd76x_edac
> 
> 
> The structure of the message is:
>         the memory controller                   (MC0)
>         Error type                              (CE)
>         memory page                             (0x283)
>         offset in the page                      (0xce0)
>         the byte granularity                    (grain 8)
>                 or resolution of the error
> 	^^^^
> 
> and
> 
> struct csrow_info {
>         unsigned long first_page;       /* first page number in dimm */
>         unsigned long last_page;        /* last page number in dimm */
>         unsigned long page_mask;        /* used for interleaving -
>                                          * 0UL for non intlv
>                                          */
>         u32 nr_pages;           /* number of pages in csrow */
>         u32 grain;              /* granularity of reported error in bytes */
> 				   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

>> 			dimm->grain = nr_pages << PAGE_SHIFT;

Grain unity is bytes, so it seems ok.

Also, you might not be noticed, but, at least on this driver, the grain
is per-memory module (and not a per-memory controller value).

> But none of that matters - the only thing that matters is that this
> thing is static and doesn't change for the module's lifetime.

I'm not so sure about that.

@Tony: Can you ensure us that, on Intel memory controllers, the address
mask remains contant at module's lifetime, or are there any events that
may change it (memory hot-plug, mirror mode changes, interleaving 
reconfiguration, ...)?

> 
> So add it as a part of some EDAC initialization printk which we print
> once on boot in dmesg and userspace tools can read it. Or to sysfs, if
> it makes more sense.
> 
> But not in _each_ tracepoint record, filling the buffers with useless info.
> 

Regards,
Mauro
