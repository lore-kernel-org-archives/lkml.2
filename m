Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2CISr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:47:59 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42393 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2CISr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:47:57 -0500
Date: Fri, 9 Mar 2012 19:47:33 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120309184733.GB13745@aftab>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120308215716.GA5925@aftab>
 <4F59DC38.5080104@redhat.com>
 <20120309143806.GA11962@aftab>
 <4F5A329A.70702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F5A329A.70702@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 01:40:58PM -0300, Mauro Carvalho Chehab wrote:
> Your logs show:
> 
> [   12.058897] EDAC MC: DCT0 chip selects:
> [   12.063091] EDAC amd64: MC: 0:  2048MB 1:  2048MB
> [   12.068155] EDAC amd64: MC: 2:  2048MB 3:  2048MB
> [   12.073219] EDAC amd64: MC: 4:     0MB 5:     0MB
> [   12.078281] EDAC amd64: MC: 6:     0MB 7:     0MB
> [   12.093305] EDAC MC: DCT1 chip selects:
> [   12.097499] EDAC amd64: MC: 0:  2048MB 1:  2048MB
> [   12.102562] EDAC amd64: MC: 2:  2048MB 3:  2048MB
> [   12.107623] EDAC amd64: MC: 4:     0MB 5:     0MB
> [   12.112690] EDAC amd64: MC: 6:     0MB 7:     0MB
> 
> This memory controller has 16 ranks (8 filled/8 empty). The above
> debug info is at edac_mc_alloc(). The EDAC core doesn't know yet how 
> many of those were filled or not, as the driver didn't fill the rank
> size yet.

Yeah, yeah, 16 ranks total, but 8 used. So we're on the same page.

[..]

> > which splits the ch0 and ch1 of the csrow? dir above into ranks. All
> > fine and dandy but that doesn't change the whole situation - we simply
> > talk about ranks and not chip select rows anymore. Oh well...
> 
> Yes, it won't bring anything new there for rank-based hierarchy.
> The only benefit in this case is that newer userspace programs/versions
> would use the same struct as the one shown with DIMMs:
> 
> dimm0
> ├── dimm_dev_type
> ├── dimm_edac_mode
> ├── dimm_label
> ├── dimm_location
> ├── dimm_mem_type
> └── dimm_size
> dimm4
> ├── dimm_dev_type
> ├── dimm_edac_mode
> ├── dimm_label
> ├── dimm_location
> ├── dimm_mem_type
> └── dimm_size
> dimm8
> ├── dimm_dev_type
> ├── dimm_edac_mode
> ├── dimm_label
> ├── dimm_location
> ├── dimm_mem_type
> └── dimm_size

Just to make sure I understand you correctly: are you saying the
topnodes dimm{0,4,8} are called ranks on the CS-based hw? If so, yes, I
agree.

> 
> 
> > Also, the following hierarchy looks ugly:
> > 
> >  ce_csrow0
> >  ce_csrow0_channel0
> >  ce_csrow0_channel1
> >  ce_csrow1
> >  ce_csrow1_channel0
> >  ce_csrow1_channel1
> >  ce_csrow2
> >  ce_csrow2_channel0
> >  ce_csrow2_channel1
> >  ce_csrow3
> >  ce_csrow3_channel0
> >  ce_csrow3_channel1
> 
> The actual error count node names depend on how the hierarchy is 
> organized. This is how it looks like at the i5000 machine:
> 
> mc0
> ├── ce_branch0
> ├── ce_branch0_channel0
> ├── ce_branch0_channel0_slot0
> ├── ce_branch0_channel1
> ├── ce_branch0_channel1_slot0

Yes, but this names have subdirectories written all over them, don't you
see that in redundant substrings in every filename?

IOW, it is much nicer to have:

mc0
|-> CE
    |-> branch0
        |-> ch0
	    |-> slot0
	    |-> slot1
	    |-> ...
	|-> ch1
	    |-> slot0
	    |-> slot1
	    ...
    |-> branch1
    ...
|-> UE
...


On CS-based controllers we simply skip "branch".

[..]

> > Much better would it be if you put the ch0 and ch1 CE error count into
> > the csrow?/ directory, i.e. something like:
> > 
> > csrow?/ce/ch{0,1}
> > csrow?/ue/ch{0,1}
> 
> There is a strong technical reason for not doing it. Now, the rank or
> dimm information is not stored anymore at the legacy structures.
> The "csrow?" sysfs nodes are created from the struct csrow_info,
> while the rank/dimm nodes, are created from struct dimm_info.
> 
> A csrow? node only makes sense if the hierarchy is csrow/channel.
> As the code should work with all kinds of hierarchy, it would require
> two different implementations, one for each case.
> 
> It would also mix the old representation with the new one, creating
> a complex code for the csrow-based sysfs nodes. After having
> the new way adopted from some kernel versions, we may think on remove
> the old nodes,

yeah, we already talked about this - we need to know that no userspace
uses them before we do that.

> as removing the csrow/ch hierarchy means to simplify
> the EDAC code by removing the compatibility logic and data. 
> 
> So, keeping it on a separate hierarchy helps to have a sane implementation.

Ok.

> From userspace POV, creating a node tree may make it  harder to parse, as 
> there would be, currently, at least 3 different ways for them with the 
> current hierarchies:
> 	csrow?/channel?/ce?
> 	branch?/channel?/slot?/ce?
> 	channel?/slot?/ce?
> 
> (and more could be added, as new memory technologies/arrangements
> may be created).
> 
> I considered two other alternatives, before adopting this one on my patches:
> 
> 1) remove the layer name from the name. So, the nodes could be called instead:
> 
> 	ce_count_0:0:0
> 	ce_count_0:0:1
> 	ce_count_0:0
> 	ce_count_0
> 	ce_count_0:1:0
> 	ce_count_0:1:1
> 	ce_count_0:1
> 	ce_count_1
> 	...
> 
> It shouldn't be hard to change the code to use this way, but it is a little
> more confusing for users to understand.
> 
> 2) Put all error counters into a single sub-directory, like:
> 	error_counters
> 	├── ce_branch0
> 	├── ce_branch0_channel0
> 	├── ce_branch0_channel0_slot0
> 	├── ce_branch0_channel1
> 	├── ce_branch0_channel1_slot0	
> 	├── ce_branch1
> 	├── ce_branch1_channel0
> 	├── ce_branch1_channel0_slot0
> 	├── ce_branch1_channel1
> 	├── ce_branch1_channel1_slot0
> 	├── ce_count
> 	├── ce_noinfo_count
> 	├── ue_branch0
> 	├── ue_branch0_channel0
> 	├── ue_branch0_channel0_slot0
> 	├── ue_branch0_channel1
> 	├── ue_branch0_channel1_slot0
> 	├── ue_branch1
> 	├── ue_branch1_channel0
> 	├── ue_branch1_channel0_slot0
> 	├── ue_branch1_channel1
> 	├── ue_branch1_channel1_slot0
> 	├── ue_count
> 	└── ue_noinfo_count
> 
> In the last case, the EDAC core would need to keep the 4
> "general" error counters also under the mc? level (ce_count & friends).
>
> > 
> > so that all is clear just from looking at the directory structure. Or
> > put it into the rank?/ hierarchy and have all per-rank info in one
> > concentrated, self-describing location.
> 
> Not sure if I understood what you're meaning here. Could you give an
> example about what kind of tree are you imagining in this case?

Right, what I mean is that the rank?/ already contains some info:

rank0/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size

Now, we do the CE/UE error counting on a per-rank granularity anyway, so
the most natural way to have that is to add those counts to the ranks:

rank0/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
|-- CE
|-- UE
`-- dimm_size

And this has to be _very_ easy to do without any adding additional
sysfs nodes with ugly names to /sys/devices/system/edac etc. This is
even better grouping than the mc?/-based hierarchy I suggested above,
actually.

Hmm...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
