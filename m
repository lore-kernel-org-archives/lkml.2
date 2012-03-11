Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2CKLfC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 07:35:02 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48097 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab2CKLeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 07:34:37 -0400
Date: Sun, 11 Mar 2012 12:34:11 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120311113411.GB29175@aftab>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120308215716.GA5925@aftab>
 <4F59DC38.5080104@redhat.com>
 <20120309143806.GA11962@aftab>
 <4F5A329A.70702@redhat.com>
 <20120309184733.GB13745@aftab>
 <4F5A5E2D.4090408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5A5E2D.4090408@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 04:46:53PM -0300, Mauro Carvalho Chehab wrote:

[..]

> > Right, what I mean is that the rank?/ already contains some info:
> > 
> > rank0/
> > |-- dimm_dev_type
> > |-- dimm_edac_mode
> > |-- dimm_label
> > |-- dimm_location
> > |-- dimm_mem_type
> > `-- dimm_size
> > 
> > Now, we do the CE/UE error counting on a per-rank granularity anyway, so
> > the most natural way to have that is to add those counts to the ranks:
> > 
> > rank0/
> > |-- dimm_dev_type
> > |-- dimm_edac_mode
> > |-- dimm_label
> > |-- dimm_location
> > |-- dimm_mem_type
> > |-- CE
> > |-- UE
> > `-- dimm_size
> > 
> > And this has to be _very_ easy to do without any adding additional
> > sysfs nodes with ugly names to /sys/devices/system/edac etc. This is
> > even better grouping than the mc?/-based hierarchy I suggested above,
> > actually.
> 
> Agreed. Yeah, it is easy to add CE/UE there. I actually implemented it
> on one of my internal patches, but there's an issue:
> 
> The typical case for UE is to report errors by cacheline (128 bits), and
> not by DIMM. This happens on all FB-DIMM memory controllers, and also on
> several CS-based ones.
> 
> For example, this is how (currently) the amd64_handle_ue() handles an
> Uncorrected Error:
> 
> 		error_address_to_page_and_offset(sys_addr, &page, &offset);
> 		edac_mc_handle_ue(log_mci, page, offset, csrow, EDAC_MOD_STR);
> 
> There's no channel info there.

Right, this looks like a largely untested path which has been that way
since forever. But, since UEs generally cause the machine to syncflood
and warm reset (now, at least), I don't think it makes a whole lot of
sense to even have such a counter - if we did, it would either say 0 or
1 :).

So, I'd suggest the UE counter to be optional and to let the driver
decide whether it wants it or not.

[..]

> One alternative would simply to remove all those intermediate
> counters, letting userspace to count the errors via perf (provided
> that we have a proper location field).

Yes, that would be where we want to go eventually because I too don't
see any reason for those counters. Besides, they don't decay over time,
for example, say you have a DIMM which experiences a temporary failure
and generates k CEs. Then, the source of that error disappears and the
DIMM works fine for months.

Now, when you look at the counters, you'll still see k CEs in one of its
ranks which doesn't tell you when those errors happened and what their
rate was, etc.

So, I'm fine with dropping those counters since they don't give you the
flexibility of a userspace tool and they don't work properly anyway.

HOWEVER, I don't know who uses them still so probably a deprecation
warning is in order here...


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
