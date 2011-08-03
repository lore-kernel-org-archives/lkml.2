Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1HCRXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 13:23:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62669 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1HCRXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 13:23:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6427"; a="107673254"
Date: Wed, 3 Aug 2011 10:23:13 -0700
From: Larry Bassel <lbassel@codeaurora.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Larry Bassel <lbassel@codeaurora.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: questions about memory hotplug
Message-ID: <20110803172313.GD3466@labbmf-linux.qualcomm.com>
References: <20110729221230.GA3466@labbmf-linux.qualcomm.com>
 <20110730093055.GA10672@sli10-conroe.sh.intel.com>
 <20110801170850.GB3466@labbmf-linux.qualcomm.com>
 <1312247376.15392.454.camel@sli10-conroe>
 <1312358106.15392.466.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312358106.15392.466.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03 Aug 11 15:55, Shaohua Li wrote:
> On Tue, 2011-08-02 at 09:09 +0800, Shaohua Li wrote:
> > On Tue, 2011-08-02 at 01:08 +0800, Larry Bassel wrote:
> > > 
> > > In use case #1 yes, maybe not in #2 (we can arrange it to be
> > > at the end of memory, but then might waste memory as it may
> > > not be aligned on a SPARSEMEM section boundary and so would
> > > need to be padded).
> > then maybe the new migrate type I suggested can help here for the
> > non-aligned memory. Anyway, let me do an experiment.
> so your problem is to offline memory in arbitrary address and size (eg,
> might not be at the end, and maybe smaller than a section)

Yes (and online it again). Also the decision to (attempt to)
on/offline must be done from userspace (as memory hotplug does already).

> 
> I had a hack. In my machine, I have DMA, DMA32, and NORMAL zone.
> At boot time, I mark 500M~600M ranges as MOVABLE_NOFB. the range is in
> DMA32 and not section size aligned.

A few questions:

* You still use SPARSEMEM though, correct?
* Would there be any problem using NORMAL memory as MOVABLE_NOFB?
* So you don't use ZONE_MOVABLE or kernelcore= or movablecore=
at all?
* Do you online/offline using the /sys/devices/system/memory files?
If so, does the kernel still attempt to on/offline the entire
section (as it does now) or only the MOVABLE_NOFB part?
If not, how do you on/offline memory?

> MOVABLE_NOFB is a new migrate type I
> added. That range memory is movable, but other type of allocation can't
> fallback into such ranges. so such range memory can only be used by
> userspace.

And the kernel will not reserve memory from it either (I had to put a
hack in an earlier version of what I'm doing to not allow reserving
from the movable zone because otherwise the existence of these
reserved pages would block logical hotremove), correct?

> I then run a memory stress test and do memory online/offline for the
> range at runtime, the offline always success.
> Does this meet your usage? If yes, I'll cook it up a little bit.

Yes, this looks very promising.
Do you see any reason this can't be backported to 2.6.38?

Thank you very much for your help here.

Larry

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
