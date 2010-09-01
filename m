Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0IARfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:35:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab0IARfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:35:31 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Doug Neal <dneallkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: I/O scheduler deadlocks on Xen virtual block devices
References: <AANLkTi=O6Tpiz8TRFFknEpW7MMTGBAtqCpr7zH3abO67@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 01 Sep 2010 13:33:07 -0400
In-Reply-To: <AANLkTi=O6Tpiz8TRFFknEpW7MMTGBAtqCpr7zH3abO67@mail.gmail.com>
	(Doug Neal's message of "Wed, 1 Sep 2010 15:17:25 +0100")
Message-ID: <x49fwxtqsh8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Neal <dneallkml@gmail.com> writes:

> Hello all,
>
> I believe I have found a bug in the I/O scheduler which results in
> access to a block device being blocked indefinitely.
>
> The setup:
>  * Xen dom0 version 3.4.2.
>  * domU: Ubuntu 10.04, x86_64, with kernel 2.6.32.15+drm33.5.
>  * Paravirtual disks and network interfaces.
>  * Root filesystem on /dev/xvdb1
>  * A scratch filesystem for the purposes of my tests on /dev/xvda
> mounted on /mnt
>  * Both filesystems are ext3, formatted and mounted with defaults
>  * XVBDs are backed by LVM on top of an iSCSI SAN in the dom0.
>
>
> Activities leading up to the incident:
>
> To reproduce the bug, I run the VM on a Xen host which has a moderate
> workload of other VMs. (It seems to manifest itself more readily than
> if the host is otherwise idle).
>
> I repeatedly rsync the contents of a Linux install CD to an arbitrary
> location on the scratch filesystem, e.g. /mnt/test, then rm -rf the
> lot, and rsync again. It can sometimes take a few iterations before
> the bug is triggered. Sometimes it's triggered on the rsync, sometimes
> on the rm.
>
> At some point during either the rsync or the rm, all the processes
> accessing /dev/xvda (rsync, kjournald, flush) become stuck in the D
> state. After 120 seconds the warnings start to appear in dmesg:
>
>   [  840.070508] INFO: task rm:1455 blocked for more than 120 seconds.
>   [  840.070514] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
>
> Full dmesg output is below, including call traces which show that each
> of these processes is stuck in io_schedule or sync_buffer called from
> io_schedule.
>
>
> I believe I have eliminated:
>  * Problems with the underlying physical device
>    - The same bug has manifested itself on two completely separate
> sets of hardware, with different servers, switches, and SANs.
>
>  * Problems with the host's iSCSI initiator
>    - Other VMs depending on the same iSCSI session are unaffected
>    - Other XVBDs within the same VM (in this case: /dev/xvdb1 mounted
> on /) are unaffected
>
> Things I've tried:
>  * Noop, deadline, cfq and anticipatory elevators.

Did you try these different I/O schedulers in the domU or on the dom0?
Does switching I/O schedulers in either place make the problem go away
when it happens?

Cheers,
Jeff
