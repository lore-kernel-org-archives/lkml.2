Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab2CHV5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:57:49 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:7022
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758125Ab2CHV5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:57:46 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0L6C3-01-3G8-02
X-M-MSG: 
Date: Thu, 8 Mar 2012 22:57:16 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120308215716.GA5925@aftab>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 08:40:32AM -0300, Mauro Carvalho Chehab wrote:
> Prepare the internal structures to represent the memory properties per dimm, 
> instead of per csrow. 
> 
> This is needed for modern controllers with more than 2 channels, as the memories 
> at the same slot number but on different channels (or channel pairs) may be 
> different.

Ok, so I this thing looks pretty fishy to me. I've booted it on a box which has
the following config on the first memory controller:

[   12.058897] EDAC MC: DCT0 chip selects:
[   12.063091] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   12.068155] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   12.073219] EDAC amd64: MC: 4:     0MB 5:     0MB
[   12.078281] EDAC amd64: MC: 6:     0MB 7:     0MB
[   12.093305] EDAC MC: DCT1 chip selects:
[   12.097499] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   12.102562] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   12.107623] EDAC amd64: MC: 4:     0MB 5:     0MB
[   12.112690] EDAC amd64: MC: 6:     0MB 7:     0MB

Yes, 2 dual-ranked DIMMs per MCT, i.e. 4 DIMMs in the DIMM slots on the
node (+ 4 more for the other MCT because it is a dual-node CPU). With
your patchset I got 8 ranks, 1024MB each, not good.

$ tree /sys/devices/system/edac/mc/mc0/rank?/
/sys/devices/system/edac/mc/mc0/rank0/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size
/sys/devices/system/edac/mc/mc0/rank1/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size
/sys/devices/system/edac/mc/mc0/rank2/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size
/sys/devices/system/edac/mc/mc0/rank3/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size
/sys/devices/system/edac/mc/mc0/rank4/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size
/sys/devices/system/edac/mc/mc0/rank5/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size
/sys/devices/system/edac/mc/mc0/rank6/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size
/sys/devices/system/edac/mc/mc0/rank7/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size

Also, what does the nomenclature

[   12.196138] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0
[   12.204636] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: dimm1 (0:1:0): row 0, chan 1
[   12.213127] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: dimm2 (1:0:0): row 1, chan 0
[   12.221613] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: dimm3 (1:1:0): row 1, chan 1
[   12.230103] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: dimm4 (2:0:0): row 2, chan 0
[   12.238590] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: dimm5 (2:1:0): row 2, chan 1
[   12.247078] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: dimm6 (3:0:0): row 3, chan 0
[   12.255560] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: dimm7 (3:1:0): row 3, chan 1
[   12.264058] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: dimm8 (4:0:0): row 4, chan 0
[   12.272552] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 9: dimm9 (4:1:0): row 4, chan 1
[   12.281041] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 10: dimm10 (5:0:0): row 5, chan 0
[   12.289699] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 11: dimm11 (5:1:0): row 5, chan 1
[   12.298362] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 12: dimm12 (6:0:0): row 6, chan 0
[   12.307018] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 13: dimm13 (6:1:0): row 6, chan 1
[   12.315684] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 14: dimm14 (7:0:0): row 7, chan 0
[   12.324352] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 15: dimm15 (7:1:0): row 7, chan 1

mean? 16 DIMMs? No way.

Basically, the problem with the DIMM nomenclature is that you cannot
know from the hardware how many chip selects, aka ranks, comprise
one DIMM. IOW, you cannot know whether your DIMMs are single-ranked,
dual-ranked or quad-ranked and thus you cannot combine the csrows into
DIMM structs.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

