Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161288Ab2CPOH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:07:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760859Ab2CPOHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:07:25 -0400
Message-ID: <4F63490E.3040500@redhat.com>
Date: Fri, 16 Mar 2012 11:07:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>, Greg KH <gregkh@linuxfoundation.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com> <20120313233217.GB31106@kroah.com> <4F60F2E4.7060707@redhat.com> <20120314204355.GA10187@kroah.com> <20120314223102.GA27602@aftab> <4F61496D.8030000@redhat.com> <20120315113115.GA32149@aftab> <4F61E35B.9000906@redhat.com> <20120315213844.GA3781@aftab> <4F62FE38.6060704@redhat.com> <20120316111536.GA8577@aftab> <4F632D16.1090200@redhat.com>
In-Reply-To: <4F632D16.1090200@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-03-2012 09:07, Mauro Carvalho Chehab escreveu:
> Em 16-03-2012 08:15, Borislav Petkov escreveu:
>> Lemme save you all the trouble:
...
> Anyway, I wrote the patches for it already after Greg's email.
> I'm just about to test them.

And they're already working. 

The patches are (will be, after mirror sync) at:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events_v8

There are just two new patches on it (and some bug fix patches got fold
to simplify their review):

c316427 edac: preserve the current EDAC sysfs API on a separate file

	- Just copies the edac_mc_sysfs.c as edac_mc_sysfs_legacy.c,
	  in order to preserve the ABI before the changes;

22790f1 edac: Convert edac mc to use struct device

	- Fixes edac_mc_sysfs_legacy.c with the changes at the struct,
	  and converts edac_mc_sysfs to use struct device.

There are still a few adjustments to do, so this is not a final version,
but the patch is already doing what's expected.

I decided to code the ras functions it as a new class, under:
	/sys/class/ras

I didn't convert yet the code that creates the CE/UE error counters
per rank/dimm/branch/csrow, as it will need some changes. The code is
also creating a "power" subdir, of course, this is uneeded/unwanted,
but the basic stuff is already there:

$ tree /sys/class/ras
/sys/class/ras
├── mc0 -> ../../devices/pci0000:3f/0000:3f:03.0/ras/mc0
├── rank0 -> ../../devices/pci0000:3f/0000:3f:03.0/ras/mc0/rank0
├── rank1 -> ../../devices/pci0000:3f/0000:3f:03.0/ras/mc0/rank1
├── rank3 -> ../../devices/pci0000:3f/0000:3f:03.0/ras/mc0/rank3
└── rank6 -> ../../devices/pci0000:3f/0000:3f:03.0/ras/mc0/rank6

$ tree /sys/class/ras/mc0
/sys/class/ras/mc0
├── ce_count
├── ce_noinfo_count
├── device -> ../../../0000:3f:03.0
├── fake_inject
├── max_location
├── mc_name
├── power
│   ├── async
│   ├── autosuspend_delay_ms
│   ├── control
│   ├── runtime_active_kids
│   ├── runtime_active_time
│   ├── runtime_enabled
│   ├── runtime_status
│   ├── runtime_suspended_time
│   └── runtime_usage
├── rank0
│   ├── device -> ../../mc0
│   ├── dimm_dev_type
│   ├── dimm_edac_mode
│   ├── dimm_label
│   ├── dimm_location
│   ├── dimm_mem_type
│   ├── power
│   │   ├── async
│   │   ├── autosuspend_delay_ms
│   │   ├── control
│   │   ├── runtime_active_kids
│   │   ├── runtime_active_time
│   │   ├── runtime_enabled
│   │   ├── runtime_status
│   │   ├── runtime_suspended_time
│   │   └── runtime_usage
│   ├── size
│   ├── subsystem -> ../../../../../../class/ras
│   └── uevent
├── rank1
│   ├── device -> ../../mc0
│   ├── dimm_dev_type
│   ├── dimm_edac_mode
│   ├── dimm_label
│   ├── dimm_location
│   ├── dimm_mem_type
│   ├── power
│   │   ├── async
│   │   ├── autosuspend_delay_ms
│   │   ├── control
│   │   ├── runtime_active_kids
│   │   ├── runtime_active_time
│   │   ├── runtime_enabled
│   │   ├── runtime_status
│   │   ├── runtime_suspended_time
│   │   └── runtime_usage
│   ├── size
│   ├── subsystem -> ../../../../../../class/ras
│   └── uevent
├── rank3
│   ├── device -> ../../mc0
│   ├── dimm_dev_type
│   ├── dimm_edac_mode
│   ├── dimm_label
│   ├── dimm_location
│   ├── dimm_mem_type
│   ├── power
│   │   ├── async
│   │   ├── autosuspend_delay_ms
│   │   ├── control
│   │   ├── runtime_active_kids
│   │   ├── runtime_active_time
│   │   ├── runtime_enabled
│   │   ├── runtime_status
│   │   ├── runtime_suspended_time
│   │   └── runtime_usage
│   ├── size
│   ├── subsystem -> ../../../../../../class/ras
│   └── uevent
├── rank6
│   ├── device -> ../../mc0
│   ├── dimm_dev_type
│   ├── dimm_edac_mode
│   ├── dimm_label
│   ├── dimm_location
│   ├── dimm_mem_type
│   ├── power
│   │   ├── async
│   │   ├── autosuspend_delay_ms
│   │   ├── control
│   │   ├── runtime_active_kids
│   │   ├── runtime_active_time
│   │   ├── runtime_enabled
│   │   ├── runtime_status
│   │   ├── runtime_suspended_time
│   │   └── runtime_usage
│   ├── size
│   ├── subsystem -> ../../../../../../class/ras
│   └── uevent
├── reset_counters
├── sdram_scrub_rate
├── seconds_since_reset
├── size_mb
├── subsystem -> ../../../../../class/ras
├── ue_count
├── ue_noinfo_count
└── uevent

19 directories, 85 files

The legacy API is also there, just like it was
before the entire patchset:

$ tree /sys/devices/system/edac/
/sys/devices/system/edac/
├── mc
│   └── mc0
│       ├── all_channel_counts
│       │   ├── udimm0
│       │   ├── udimm1
│       │   └── udimm2
│       ├── ce_count
│       ├── ce_noinfo_count
│       ├── csrow0
│       │   ├── ce_count
│       │   ├── ch0_ce_count
│       │   ├── ch0_dimm_label
│       │   ├── ch1_ce_count
│       │   ├── ch1_dimm_label
│       │   ├── ch2_ce_count
│       │   ├── ch2_dimm_label
│       │   ├── dev_type
│       │   ├── edac_mode
│       │   ├── mem_type
│       │   ├── size_mb
│       │   └── ue_count
│       ├── csrow1
│       │   ├── ce_count
│       │   ├── ch0_ce_count
│       │   ├── ch0_dimm_label
│       │   ├── ch1_ce_count
│       │   ├── ch1_dimm_label
│       │   ├── ch2_ce_count
│       │   ├── ch2_dimm_label
│       │   ├── dev_type
│       │   ├── edac_mode
│       │   ├── mem_type
│       │   ├── size_mb
│       │   └── ue_count
│       ├── csrow2
│       │   ├── ce_count
│       │   ├── ch0_ce_count
│       │   ├── ch0_dimm_label
│       │   ├── ch1_ce_count
│       │   ├── ch1_dimm_label
│       │   ├── ch2_ce_count
│       │   ├── ch2_dimm_label
│       │   ├── dev_type
│       │   ├── edac_mode
│       │   ├── mem_type
│       │   ├── size_mb
│       │   └── ue_count
│       ├── device -> ../../../../pci0000:3f/0000:3f:03.0
│       ├── inject_addrmatch
│       │   ├── bank
│       │   ├── channel
│       │   ├── col
│       │   ├── dimm
│       │   ├── page
│       │   └── rank
│       ├── inject_eccmask
│       ├── inject_enable
│       ├── inject_section
│       ├── inject_type
│       ├── mc_name
│       ├── reset_counters
│       ├── sdram_scrub_rate
│       ├── seconds_since_reset
│       ├── size_mb
│       ├── ue_count
│       └── ue_noinfo_count
└── pci
    ├── check_pci_errors
    ├── edac_pci_log_npe
    ├── edac_pci_log_pe
    ├── edac_pci_panic_on_pe
    ├── pci0
    │   ├── device -> ../../../../pci0000:3f/0000:3f:03.0
    │   ├── npe_count
    │   └── pe_count
    ├── pci_nonparity_count
    └── pci_parity_count

11 directories, 66 files
