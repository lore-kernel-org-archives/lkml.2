Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869Ab2CALkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:40:45 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43782 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2CALko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:40:44 -0500
Date: Thu, 1 Mar 2012 12:40:23 +0100
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Message-ID: <20120301114023.GB32410@aftab>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4D7BF9.9070104@jp.fujitsu.com>
 <20120229101047.GA21224@aftab>
 <4F4E145E.4040901@redhat.com>
 <20120229121914.GD21224@aftab>
 <4F4E22B1.6020505@redhat.com>
 <20120229133741.GF21224@aftab>
 <4F4EDD9A.4050900@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4EDD9A.4050900@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 11:23:22AM +0900, Hidetoshi Seto wrote:
> (2012/02/29 22:37), Borislav Petkov wrote:
> > On Wed, Feb 29, 2012 at 10:05:53AM -0300, Mauro Carvalho Chehab wrote:
> >> Em 29-02-2012 09:19, Borislav Petkov escreveu:
> >> - on SB, the MCE status register only has the error message. In order to get
> >>   the DIMM location, the driver needs to parse the registers that describe
> >>   how the DIMM's are organized (this is spread on dozens of PCI devices, and
> >>   200+ registers), and how they're interlaced, in order to convert the error 
> >>   address reported by the MCA into a DIMM location.
> > 
> > As I already said, amd64_edac does a similar thing does already so I
> > don't see any difference in the solutions there: decode to the DIMM and
> > pass the info through 'msg'.
> 
> My concern is; on Sandy Bridge, is it safe to gather info about the DIMM
> location in/from machine check context in a reasonable time span?

Well, what amd64_edac does is "buffer" the required lookup info so
whenever you get an error, you simply lookup the channel and chip select
- all ops which can be done in atomic context.

[..]

> Getting back to the "msg" I think it is not necessary if it does not
> contain any new data which is not available in the mce_record today.
> If you just want to add field about physical memory location, I think
> string "msg" is not only way to do so.

No, currently, the mce_record contains the following, for example:

CPU: 0, MCGc/s: 0/0, MC4: d604c00006080a41, ADDR/MISC: 0000000000000016/dead57ac1ba0babe, RIP: 00:<0000000000000000>, TSC: 0, TIME: 0

With the decoded info added, it becomes:

[Hardware Error]: CPU:0 MC4_STATUS[Over|CE|-|PCC|AddrV|CECC]: 0xd604c00006080a41 MC4_ADDR: 0x0000000000000016
[Hardware Error]: Northbridge Error (node 0): DRAM ECC error detected on the NB.
[Hardware Error]: ERR_ADDR: 0x16 row: 0, channel: 0
[Hardware Error]: cache level: L1, mem/io: MEM, mem-tx: DWR, part-proc: RES (no timeout)
[Hardware Error]: CPU: 0, MCGc/s: 0/0, MC4: d604c00006080a41, ADDR/MISC: 0000000000000016/dead57ac1ba0babe, RIP: 00:<0000000000000000>, TSC: 0, TIME: 0)

where the ERR_ADDR line comes from amd64_edac looking up the error address.

This way, you get all the info needed to understand what the MCi_STATUS
of this MCE is telling you without any APM searching you'd normally have
to do to understand what each field means.

HTH.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
