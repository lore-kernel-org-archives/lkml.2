Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab0KFLSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 07:18:12 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:56301 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab0KFLSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 07:18:10 -0400
To: gregkh@suse.de, kay.sievers@vrfy.org
Cc: cbouatmailru@gmail.com, ak@linux.intel.com, axboe@kernel.dk,
        shemminger@vyatta.com, ebiederm@xmission.com,
        stern@rowland.harvard.edu, James.Bottomley@suse.de,
        akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
        randy.dunlap@oracle.com, tj@kernel.org, davem@davemloft.net,
        perex@perex.cz, tiwai@suse.de, mingo@elte.hu, a.p.zijlstra@chello.nl,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.37-rc1] udevd-event prints errors.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201011060307.GIG13040.OFFJOVHMSFLOtQ@I-love.SAKURA.ne.jp>
	<20101105200245.GA1645@suse.de>
In-Reply-To: <20101105200245.GA1645@suse.de>
Message-Id: <201011062018.ADJ30249.OVOOJFMFHQFStL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 6 Nov 2010 20:18:07 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Nov 06, 2010 at 03:07:55AM +0900, Tetsuo Handa wrote:
> > Hello.
> > 
> > I noticed that udevd-event started to print error messages.
> > 
> >   Starting udev: udevd-event[1682]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:10.0/host0/ioerr_cnt' failed
> >   udevd-event[2103]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:10.0/host0/target0:0:1/ioerr_cnt' failed
> >   udevd-event[2102]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:10.0/host0/target0:0:0/ioerr_cnt' failed
> 
> That's wierd, what version of udev is this?
> 

# rpm -qf /sbin/udevd
udev-095-14.21.el5_5.1
# /usr/bin/udevinfo -V
udevinfo, version 095

> > These error messages are caused by one or more of below commits.
> > (Sorry, I can't find exact one because I can't boot as of below commits.)
> > 
> > 5cfc64ce "base/platform: Safe handling for NULL platform data and resources"
> > 807508c8 "base/platform: Simplifications for NULL platform data/resources handling"
> > 39aba963 "driver core: remove CONFIG_SYSFS_DEPRECATED_V2 but keep it for block devices"
> > 
> > Is this a regression? (Is this an intended change?)
> 
> Do you still have CONFIG_SYSFS_DEPRECATED enabled?
> 
Oh, around above commits, CONFIG_SYSFS_DEPRECATED has changed to "n"
by some reason. I changed to

  # grep CONFIG_SYSFS .config
  CONFIG_SYSFS_DEPRECATED=y
  CONFIG_SYSFS_DEPRECATED_V2=y
  CONFIG_SYSFS=y

and re-bisected. Now it turned out that

  39aba963 "driver core: remove CONFIG_SYSFS_DEPRECATED_V2 but keep it for block devices"

is the commit which caused these error messages.

Guessing from error messages, changes in drivers/scsi/hosts.c and
drivers/scsi/scsi_scan.c might be involved.

> Other than that, everything works ok, right?
Right.

Regards.
