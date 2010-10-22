Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0JVISc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:18:32 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56727 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab0JVISa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:18:30 -0400
Message-ID: <4CC148E5.2030605@kernel.dk>
Date: Fri, 22 Oct 2010 10:18:45 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andreas Dilger <adilger.kernel@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: Re: linux-next regression: IO errors in with ext4 and xen-blkfront
References: <4CBF83A0.8090802@goop.org> <4CBF84C9.6050606@goop.org>
In-Reply-To: <4CBF84C9.6050606@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-21 02:09, Jeremy Fitzhardinge wrote:
>  On 10/20/2010 05:04 PM, Jeremy Fitzhardinge wrote:
>>  Hi,
>>
>> When doing some regression testing with Xen on linux-next, I'm finding
>> that my domains are failing to get through the boot sequence due to IO
>> errors:
>>
>> Remounting root filesystem in read-write mode:  EXT4-fs (dm-0): re-mounted. Opts: (null)
>> [  OK  ]
>> Mounting local filesystems:  EXT3-fs: barriers not enabled
>> kjournald starting.  Commit interval 5 seconds
>> EXT3-fs (xvda1): using internal journal
>> EXT3-fs (xvda1): mounted filesystem with writeback data mode
>> SELinux: initialized (dev xvda1, type ext3), uses xattr
>> SELinux: initialized (dev xenfs, type xenfs), uses genfs_contexts
>> [  OK  ]
>> Enabling local filesystem quotas:  [  OK  ]
>> Enabling /etc/fstab swaps:  Adding 917500k swap on /dev/mapper/vg_f1364-lv_swap.  Priority:-1 extents:1 across:917500k 
>> [  OK  ]
>> SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
>> Entering non-interactive startup
>> Starting monitoring for VG vg_f1364:   2 logical volume(s) in volume group "vg_f1364" monitored
>> [  OK  ]
>> ip6tables: Applying firewall rules: [  OK  ]
>> iptables: Applying firewall rules: [  OK  ]
>> Bringing up loopback interface:  [  OK  ]
>> Bringing up interface eth0:  
>> Determining IP information for eth0... done.
>> [  OK  ]
>> Starting auditd: [  OK  ]
>> end_request: I/O error, dev xvda, sector 0
>> end_request: I/O error, dev xvda, sector 0
>> end_request: I/O error, dev xvda, sector 9675936
>> Aborting journal on device dm-0-8.
>> Starting portreserve: EXT4-fs error (device dm-0): ext4_journal_start_sb:259: Detected aborted journal
>> EXT4-fs (dm-0): Remounting filesystem read-only
>> [  OK  ]
>> Starting system logger: EXT4-fs (dm-0): error count: 4
>> EXT4-fs (dm-0): initial error at 1286479997: ext4_journal_start_sb:251
>> EXT4-fs (dm-0): last error at 1287618175: ext4_journal_start_sb:259
>>
>>
>> I haven't tried to bisect this yet (which will be awkward because
>> linux-next had also introduced various Xen bootcrashing bugs), but I
>> wonder if you have any thoughts about what may be happening here.  I
>> guess an obvious candidate is the barrier changes in the storage
>> subsystem, but I still get the same errors if I mount root with barrier=0.
> 
> Hm.  I get the same errors, but the system boots to login prompt rather
> than hanging at that point above, and seems generally happy.  So perhaps
> barriers are the key.

To test that theory, can you try and pull the two other main bits of the
pending block patches and see if it works?

git://git.kernel.dk/linux-2.6-block.git for-2.6.37/core
git://git.kernel.dk/linux-2.6-block.git for-2.6.37/drivers

and if that works, then pull

git://git.kernel.dk/linux-2.6-block.git for-2.6.37/barrier

and see how that fares.

-- 
Jens Axboe

