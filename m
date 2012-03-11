Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab2CKMc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 08:32:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab2CKMc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 08:32:57 -0400
Message-ID: <4F5C9B6C.2080904@redhat.com>
Date: Sun, 11 Mar 2012 09:32:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>, "Mark A. Grondona" <mgrondona@llnl.gov>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com> <20120308215716.GA5925@aftab> <4F59DC38.5080104@redhat.com> <20120309143806.GA11962@aftab> <4F5A329A.70702@redhat.com> <20120309184733.GB13745@aftab> <4F5A5E2D.4090408@redhat.com> <20120311113411.GB29175@aftab>
In-Reply-To: <20120311113411.GB29175@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 11-03-2012 08:34, Borislav Petkov escreveu:
> On Fri, Mar 09, 2012 at 04:46:53PM -0300, Mauro Carvalho Chehab wrote:
> 
> [..]
> 
>>> Right, what I mean is that the rank?/ already contains some info:
>>>
>>> rank0/
>>> |-- dimm_dev_type
>>> |-- dimm_edac_mode
>>> |-- dimm_label
>>> |-- dimm_location
>>> |-- dimm_mem_type
>>> `-- dimm_size
>>>
>>> Now, we do the CE/UE error counting on a per-rank granularity anyway, so
>>> the most natural way to have that is to add those counts to the ranks:
>>>
>>> rank0/
>>> |-- dimm_dev_type
>>> |-- dimm_edac_mode
>>> |-- dimm_label
>>> |-- dimm_location
>>> |-- dimm_mem_type
>>> |-- CE
>>> |-- UE
>>> `-- dimm_size
>>>
>>> And this has to be _very_ easy to do without any adding additional
>>> sysfs nodes with ugly names to /sys/devices/system/edac etc. This is
>>> even better grouping than the mc?/-based hierarchy I suggested above,
>>> actually.
>>
>> Agreed. Yeah, it is easy to add CE/UE there. I actually implemented it
>> on one of my internal patches, but there's an issue:
>>
>> The typical case for UE is to report errors by cacheline (128 bits), and
>> not by DIMM. This happens on all FB-DIMM memory controllers, and also on
>> several CS-based ones.
>>
>> For example, this is how (currently) the amd64_handle_ue() handles an
>> Uncorrected Error:
>>
>> 		error_address_to_page_and_offset(sys_addr, &page, &offset);
>> 		edac_mc_handle_ue(log_mci, page, offset, csrow, EDAC_MOD_STR);
>>
>> There's no channel info there.
> 
> Right, this looks like a largely untested path which has been that way
> since forever. But, since UEs generally cause the machine to syncflood
> and warm reset (now, at least), I don't think it makes a whole lot of
> sense to even have such a counter - if we did, it would either say 0 or
> 1 :).
> 
> So, I'd suggest the UE counter to be optional and to let the driver
> decide whether it wants it or not.

Well, this change can be done, but still we need to decide how to export it ;)

The new edac_mc_handle_error() with replaces all the legacy edac_mc_handle* calls
does what the other calls used to do. I didn't change its behavior. Anyway, what
it does for UE errors is:

	...
	/* Some logic to get the memory DIMM labels */
        trace_mc_error(type, mci->mc_idx, msg, label, location,
                       detail, other_detail);
	
	if (type == HW_EVENT_ERR_CORRECTED) {
		...
        } else {
		...
                if (edac_mc_get_log_ue())
                        edac_mc_printk(mci, KERN_WARNING,
                                "UE %s on %s (%s%s %s)\n",
                                msg, label, location, detail, other_detail);

                if (edac_mc_get_panic_on_ue())
                        panic("UE %s on %s (%s%s %s)\n",
                              msg, label, location, detail, other_detail);

                edac_increment_ue_error(mci, enable_filter, pos);
        }

So, it basically:
	1) prints the memory location and the DIMM label(s) of the memory(ies)
	   from where the error originates;
	2) if edac_mc_panic_on_ue is set, it will panic;
	3) otherwise, it will increment the UE error counters.

It shouldn't be hard to add a patch to disable the sysfs error UE counters if 
edac_mc_panic_on_ue is enabled.

Anyway, an UE error with a 128 bits cacheline points to a location that has
two DIMMs (or 4 DIMMs, on memory controllers with mirror mode enabled). So,
incrementing a DIMM error counter doesn't seem to be the right thing to do.

Well, it may increment two DIMM error counters (or 4 DIMM error counters), but
it would change the current behavior.

It should also be noticed that the MCA-based Intel memory controllers have the 
(likely limited) capability of recovering from an UE error. So, an UE error 
may not mean a fatal error. So, the UE error counter value can actually be
bigger than 1.

> 
> [..]
> 
>> One alternative would simply to remove all those intermediate
>> counters, letting userspace to count the errors via perf (provided
>> that we have a proper location field).
> 
> Yes, that would be where we want to go eventually because I too don't
> see any reason for those counters. Besides, they don't decay over time,
> for example, say you have a DIMM which experiences a temporary failure
> and generates k CEs. Then, the source of that error disappears and the
> DIMM works fine for months.

Userspace applications may reset the error counters. There is a sysfs node
for it.

> Now, when you look at the counters, you'll still see k CEs in one of its
> ranks which doesn't tell you when those errors happened and what their
> rate was, etc.

Yeah, a proper handling for CE/UE errors is to log them into some
Element Management System (or Network Management System), and let the EMS/NMS
to generate not only the error counters, but also the error rate counters.

For this to happen, the EMS/NMS should be capable of parsing the error location
and the DIMM labels, in order to provide per-DIMM and per location counters.

> So, I'm fine with dropping those counters since they don't give you the
> flexibility of a userspace tool and they don't work properly anyway.
> 
> HOWEVER, I don't know who uses them still so probably a deprecation
> warning is in order here...

Mark's edac-utils edac-ctl application use those counters. I know it is
used on RHEL (and RHEL-based distros), Fedora and Debian/Ubuntu. Not sure
if it is packaged for other distros.

I don't know any other EDAC public tool.

Mark,

any comments with regards to the error counters?

Regards,
Mauro
