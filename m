Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345Ab2CPLQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 07:16:09 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48810 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab2CPLQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 07:16:07 -0400
Date: Fri, 16 Mar 2012 12:15:37 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120316111536.GA8577@aftab>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120313233217.GB31106@kroah.com>
 <4F60F2E4.7060707@redhat.com>
 <20120314204355.GA10187@kroah.com>
 <20120314223102.GA27602@aftab>
 <4F61496D.8030000@redhat.com>
 <20120315113115.GA32149@aftab>
 <4F61E35B.9000906@redhat.com>
 <20120315213844.GA3781@aftab>
 <4F62FE38.6060704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F62FE38.6060704@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lemme save you all the trouble:

There will be no breaking of userspace, no matter how wrong it is
implemented in the kernel. All sysfs nodes which are there now will
remain there until edac-ctl or something else uses them. So simply cut
the bullshit bingo and add only the changes needed to accomodate the
FBDIMM drivers _without_ _rewriting_ anything etc., and all the churn to
the whole EDAC core for no good reason.

As I've told you before, add a second edac_mc_alloc() function which
does everything needed for the FBDIMM drivers and is only called by
them. The other drivers don't need to know of any change.

On Fri, Mar 16, 2012 at 05:47:52AM -0300, Mauro Carvalho Chehab wrote:
> Em 15-03-2012 18:38, Borislav Petkov escreveu:
> > On Thu, Mar 15, 2012 at 09:40:59AM -0300, Mauro Carvalho Chehab wrote:
> >>> What are you talking about? Those per-rank counters should be the same
> >>> as the per-csrow ch0 and ch1 counters...
> >>
> >> Yes, but with your proposal, the per-csrow counters will not be added
> >> (the equivalent of):
> >> 	/sys/devices/system/edac/mc/mc0/csrow0/ue_count
> >> 	/sys/devices/system/edac/mc/mc0/csrow0/ce_count
> > 
> > What the hell? Those are already there:
> > 
> > /sys/devices/system/edac/mc/mc0/csrow0/
> > |-- ce_count
> > |-- ch0_ce_count
> > |-- ch0_dimm_label
> > |-- ch1_ce_count
> > |-- ch1_dimm_label
> > |-- dev_type
> > |-- edac_mode
> > |-- mem_type
> > |-- size_mb
> > `-- ue_count
> > 
> > and since userspace uses them, they cannot be removed.
> 
> Two reasons:
> 
> 1) a per-csrow counter only works properly for amd64 and the Intel drivers for
>    hardware shipped 5+ years ago;
> 
> 2) per Greg's request, we should not use struct sysdev, using instead,
>    struct device. That means that everything under
> 	/sys/devices/system/edac/mc/
>    will move to another place, likely:
> 	/sys/devices/ras/
> 
> and everything at /sys/devices/system/edac/mc/ will need to be provided by a
> legacy compat API code, to be dropped on some future.
> 
> >>> It depends - if the 128 bit word comes from a single DIMM (unganged
> >>> mode) then you have a per-rank UE.
> >>
> >> True, and there are other types of ECC logic that would allow to identify
> >> what DIMM/rank produced the error.
> >>
> >> Yet, the typical case is to use two DIMMs for a 128-bits cacheline
> >> on separate channels, due to performance improvements, and ECC chipkill
> >> using the 128+16 bits, as it improves the probability of error correction.
> > 
> > ... and in this typical case, on smart hardware you can get the rank
> > too. 
> 
> I've analyzed all edac drivers. Almost all points to a single
> DIMM or rank on UE errors. They can only blame two dimms/ranks. The
> very few ones that will point to a single DIMM seem to be due to a
> the way they cheat with the EDAC API in order to implement support
> for FB-DIMM (or RAMBUS), telling the EDAC core that there's just one
> channel.
> 
> > If one cannot discern between the two DIMMs, then there should be
> > one counter and the other one should be a symlink to that counter, or
> > something to that effect.
> 
> Doesn't sound easy to implement it, nor for userspace to convert back
> from a series of symlinks into a set of locations.
> 
> >>>> Of course, the EDAC logic could increment multiple UE error counters
> >>>> in such case, (meaning that an error happened on either one of the
> >>>> affected DIMMs/Ranks) but this is a different behavior than the
> >>>> current API.
> >>>
> >>> Well, the API should be changed to accomodate such configurations.
> >>
> >> True, but changing the propagation logic to propagate the error down
> >> to the several DIMMs from where the error might have occurred is:
> >>
> >> 	- the opposite of the current propagation logic;
> >>
> >> 	- the opposite on how ITU-T TMN architecture and all EMS/NMS
> >> 	  implementations I'm aware with work.
> >>
> >> So, using such propagation logic doesn't sound right to me. What I'm
> >> saying is that, if all the driver can be sure is that the error happened
> >> at the csrow level, it should not propagate the errors to the channel
> >> level. 
> >>
> >> So, I think that csrow-level counter is needed (and the equivalent
> >> "group" counters for non-rank-based memory controllers).
> > 
> > See above, we already have 'ce_count' and 'ue_count' and those are
> > csrow-level counters.
> 
> They're not branch-level counters (a requirement for FB-DIMM drivers).
> 
> The role target of this patchset is to fix the core of the reporting system.
> The old sysfs nodes don't work properly with Intel's systems
> manufactured after 2005 (and with a few others manufactured before).
> 
> All Xeon 3xxx/5xxx/7xxx/E3 chipsets[1] use advanced memory controllers that 
> abstract csrows, either because they're for FB-DIMMs (where the memory ranks and 
> chip select rows aren't visible by the memory controller), or, more recently,
> because their registers are per DIMM slots, instead of per ranks, and users
> can't replace a damaged rank on a dual-ranked DIMM in field.
> 
> [1] The Intel's CPU/chipset series of Servers since 2005. Desktop processors
> aren't relevant for EDAC, as they're either not supported, or they're 
> supported by the same driver that provides support for servers.
> 
> Regards,
> Mauro
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
