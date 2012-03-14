Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab2CNW6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:58:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab2CNW6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:58:51 -0400
Message-ID: <4F611991.9040604@redhat.com>
Date: Wed, 14 Mar 2012 19:20:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com> <20120313233217.GB31106@kroah.com> <4F60F2E4.7060707@redhat.com> <20120314204355.GA10187@kroah.com>
In-Reply-To: <20120314204355.GA10187@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 14-03-2012 17:43, Greg KH a:
> On Wed, Mar 14, 2012 at 04:35:00PM -0300, Mauro Carvalho Chehab wrote:
>> Em 13-03-2012 20:32, Greg KH escreveu:
>>> On Wed, Mar 07, 2012 at 08:40:32AM -0300, Mauro Carvalho Chehab wrote:
>>>> Prepare the internal structures to represent the memory properties per dimm, 
>>>> instead of per csrow. 
>>>>
>>>> This is needed for modern controllers with more than 2 channels, as the memories 
>>>> at the same slot number but on different channels (or channel pairs) may be 
>>>> different.
>>>>
>>>> Mauro Carvalho Chehab (6):
>>>>   edac: Create a dimm struct and move the labels into it
>>>>   edac: Add per dimm's sysfs nodes
>>>
>>> You need Documentation/ABI entries for these new sysfs files.
>>
>> Sure. I'll provide it on the final patchset.
>>
>> Boris suggested some alternatives for the error counter sysfs nodes, but the 
>> discussion ended by diverging into an implementation detail of hiding the UE
>> error nodes, without any consensus about the sysfs structure for it.
>>
>> At the current patchset, the error counter nodes are all under
>> 	sys/devices/system/edac/mc/mc?/
>>
>> He thinks that a multi-layer struct should be created inside that directory
>> (it could have 2 or 3 levels of directories, depending on how the memory is
>> organized at the memory controller), instead of having a large number of files
>> there.
> 
> Why create subdirs?  If those subdirectories are not real devices,
> showing a real hierarchy, then do not create them as userspace will get
> very confused very quickly.

Yes, I think so. 

That's the sysfs structure proposed on those patchsets:

The error counter registers for corrected errors (CE) and uncorrected 
errors (UE) will be like:

/sys/devices/system/edac/
└── mc
    ├── mc0
    │   ├── ce_csrow[0-i]
    │   ├── ce_csrow[0-i]_channel[0-j]
...
    │   ├── ce_count
    │   ├── ce_noinfo_count
...
    │   ├── ue_csrow[0-i]
    │   ├── ue_csrow[0-i]_channel[0-j]
...
    ├── ue_count
    └── ue_noinfo_count

The actual names for the error counters will depend on how the memory
controller addresses the memory. Currently, there are 3 possibilities:

	- csrow/channel - for drivers where the memory is addressed by rank;
	- channel/slot - for devices where the memory controller can properly
			 identify a DIMM slot;
	- branch/channel/slot - for FB-DIMM memory controllers with more
				than 2 channels, as those memory controllers
				group each channel pair into a branch.

This basically reflects the hierarchy used by the memory controller in
order to see the memory chips.

When an error occurs, the driver increments the pertinent counters.
For example, a CE error on a dimm located at csrow 3 channel 1 will
increment:
	ce_csrow3_channel1
	ce_csrow3
	ce_count

On several cases, it is not possible to point to a single DIMM or rank. On
such case, only the higher hierarchy counters will be incremented. For
example, an Uncorrected Error at csrow3 with a 128 cacheline will
increment only:
	ce_csrow3
	ce_count

As the ECC chipkill algorithm in general is not able to tell if the error
happened at the rank located at channel 0 or channel 1.

The special ce_noinfo_count/ue_noinfo_count counters are there signalize
that an error occurred but the driver couldn't get the error location.

The ce_count/ue_count/ue_noinfo_count/ce_noinfo_count are part of the
current API. That's why I added the other counters there, and used a
nomenclature close to the existing one.


The per-rank/per-dimm memory struct that contains the memory information 
(size, type, location, etc), and it will be like:

/sys/devices/system/edac/
└── mc
    ├── mc0
    │   ├── (rank|dimm)[0-n]
    │   │   ├── dimm_dev_type
    │   │   ├── dimm_edac_mode
    │   │   ├── dimm_label
    │   │   ├── dimm_location
    │   │   ├── dimm_mem_type
    │   │   └── dimm_size

There are a few other nodes that are untouched by this patchset and
will remain there:

/sys/devices/system/edac/
└── mc
    ├── mc0
    │   ├── device -> ../../../../pci0000:00/0000:00:18.2
    │   ├── reset_counters
    │   ├── sdram_scrub_rate
    │   ├── seconds_since_reset
    │   └── size_mb

(there are also a few driver-specific sysfs nodes - most due to error injection,
 and, on some devices, device nodes for erros on the PCI bus - none of them
 touched on those series)

And finally, the nodes that are redundant and, IMO, should be deprecated on some
future kernel version:

/sys/devices/system/edac
├── mc
│   ├── mc0
│   │   ├── csrow[0-i]
│   │   │   ├── ce_count
│   │   │   ├── ch0_ce_count
│   │   │   ├── ch0_dimm_label
...
│   │   │   ├── ch[j]_ce_count
│   │   │   ├── ch[j]_dimm_label
│   │   │   ├── dev_type
│   │   │   ├── edac_mode
│   │   │   ├── mem_type
│   │   │   ├── size_mb
│   │   │   └── ue_count
...

On the above:
	/csrow3/ch1_ce_count
is equivalent to: 
	/ce_csrow3_channel1

and
	/csrow3/ce_count
is equivalent to:
	/ce_csrow3

> Easy rule to remember, never mix "raw" kobjects and 'struct device',
> which is what you would be doing here, right?  We can handle many
> hundreds of thousands of files and devices in a single directory, no
> problem.

No. They're all generated with raw kobjects, using kobject_init_and_add() or
sysfs_create_file() calls.

>> Anyway, before adding unnedded complexity, I'd like to hear more comments from 
>> the others before writing a complex patch to create such structure.
>>
>> So, maybe I could just add what it was there as ABI/testing, and give more
>> time for kernel and userspace developers to work with it and provide us a better
>> feedback.
> 
> That's a nice dream, it usually never happens until a few kernel
> releases, after people have already written tools that rely on the
> existing structure :)

:)

Well, on the test tools I wrote to test the patches, it is a way easier to
parse the error counters on just one directory, than to write a shell script
that would navigate on a complex multi-directory layer with 2 or 3 levels.

> Feel free to cc: me on any of these patches if you want some review of
> the sysfs layout and usage.

Thanks! I'll do it on my next submission.

Thanks,
Mauro
