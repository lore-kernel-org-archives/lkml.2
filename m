Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab2EaSFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:05:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2EaSFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:05:13 -0400
Message-ID: <4FC7B2C7.80504@redhat.com>
Date: Thu, 31 May 2012 15:04:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
References: <20120531100005.GC14074@aftab.osrc.amd.com> <4FC748F5.9070709@redhat.com> <20120531121741.GB14515@aftab.osrc.amd.com> <4FC7788C.1070405@redhat.com> <20120531142229.GF14515@aftab.osrc.amd.com> <4FC783EA.80704@redhat.com> <20120531145416.GI14515@aftab.osrc.amd.com> <4FC787BF.3020006@redhat.com> <20120531151408.GJ14515@aftab.osrc.amd.com> <4FC798E2.4000402@redhat.com> <20120531171337.GN14515@aftab.osrc.amd.com>
In-Reply-To: <20120531171337.GN14515@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 31-05-2012 14:13, Borislav Petkov escreveu:
> On Thu, May 31, 2012 at 01:14:26PM -0300, Mauro Carvalho Chehab wrote:
>>> 5 amd76x_edac.c     amd76x_init_csrows          214 dimm->grain = dimm->nr_pages << PAGE_SHIFT;
>>> 6 cpc925_edac.c     cpc925_init_csrows          367 dimm->grain = 32;
>>> 7 cpc925_edac.c     cpc925_init_csrows          371 dimm->grain = 64;
>>> 8 e752x_edac.c      e752x_init_csrows          1119 dimm->grain = 1 << 12;
>>> 9 e7xxx_edac.c      e7xxx_init_csrows           399 dimm->grain = 1 << 12;
>>> k i3000_edac.c      i3000_probe1                416 dimm->grain = I3000_DEAP_GRAIN;
>>> l i3200_edac.c      i3200_probe1                395 dimm->grain = nr_pages << PAGE_SHIFT;
>>> m i5000_edac.c      i5000_init_csrows          1286 dimm->grain = 8;
>>> n i5100_edac.c      i5100_init_csrows           852 dimm->grain = 32;
>>> o i5400_edac.c      i5400_init_dimms           1212 dimm->grain = 8;
>>> p i7300_edac.c      decode_mtr                  662 dimm->grain = 8;
>>> q i7core_edac.c     get_dimm_config             637 dimm->grain = 8;
>>> r i82443bxgx_edac.c i82443bxgx_init_csrows      225 dimm->grain = 1 << 12;
>>> s i82860_edac.c     i82860_init_csrows          180 dimm->grain = 1 << 12;
>>> t i82875p_edac.c    i82875p_init_csrows         388 dimm->grain = 1 << 12;
>>> v i82975x_edac.c    i82975x_init_csrows         430 dimm->grain = 1 << 7;
>>> w mpc85xx_edac.c    mpc85xx_init_csrows         956 dimm->grain = 8;
>>> x mv64x60_edac.c    mv64x60_init_csrows         677 dimm->grain = 8;
>>> y pasemi_edac.c     pasemi_edac_init_csrows     183 dimm->grain = PASEMI_EDAC_ERROR_GRAIN;
>>> z ppc4xx_edac.c     ppc4xx_edac_init_csrows     983 dimm->grain = 1;
>>> A r82600_edac.c     r82600_init_csrows          259 dimm->grain = 1 << 14;
>>> B sb_edac.c         get_dimm_config             597 dimm->grain = 32;
>>> C tile_edac.c       tile_edac_init_csrows       117 dimm->grain = TILE_EDAC_ERROR_GRAIN;
>>> D x38_edac.c        x38_probe1                  394 dimm->grain = nr_pages << PAGE_SHIFT;
>>
>> The grains among the drivers are different; userspace needs to know, so an
>> API is needed.
> 
> Sure, that's why I'm preaching about sysfs or dmesg for so long.
> 
> [ … ]
> 
>>> Don't create a bloated API just to fit your purpose because you're
>>> staring at the world through your glasses.
>>
>> It is not a bloated API. The error grain should be reported to userspace,
>> as:
>> 	- Not all drivers have the same address granularity, as you've shown
>> 	  above;
> 
> Yes.
> 
>> 	- No other userspace API provides it;
> 
> Yes, it should.
> 
>> 	- The granularity is a property of the per-error address;
> 
> Not necessarily, as it is shown above.
> 
>> 	- There are well-known cases where the address grain changes are
>> 	  dynamically filled by the error registers (MCA arch on Intel).
> 
> Ok.
> 
>> So, the memory error tracepoint is the proper place to store it, as it is
>> the place where the address and the other memory error information is
>> reported to userspace.
> 
> Yes, but not as a separate field but in driver_detail _only_ on those
> drivers where grain is dynamic. The remaining ones simply don't output
> it all because they have done so in dmesg or sysfs.

The tracepoint approach is proposed as a way to replace dmesg, so, dmesg is
not an option.

Sysfs nodes for address grain won't work, as, on MCA, the grain is only 
known when an error is generated, and it is valid only together with an
error report.

The same issue with MCA is also probably true for memory scrubbing on other
drivers, e. g. errors generated via scrubbing logic likely have a different
grain.

Having the _same_ field exported either in sysfs or via the trace, depending if
the grain is dynamic or if it is global-wide is a very crappy API, as the same
information would be provided to userspace via different API's, with is
insane.

>> Also, converting the grain to a string, as you proposed would require
>> at least 26 bytes to store "grain: 0xdeadbeef:deadbeef", while putting
>> it as a u64 will consume only 8 bytes.
> 
> Again, only on those drivers which have dynamic grain. Other drivers
> which keep outputting 'x' (and 'x' doesn't change) on every tracepoint
> invocation don't need to output it all in the tracepoint.

So what? If only one type of granularity applies to all addresses, the
information provided to userspace won't be wrong.

This is about the same as network masks: on the majority of Linux usecases,
the network mask for the local network is /24, but that doesn't mean that
the network stack would require a different API to be used if the mask
is not /24.

Regards,
Mauro








