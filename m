Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2JDKMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:12:23 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35005 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2JDKMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:12:21 -0400
Message-ID: <506D60FC.7090801@redhat.com>
Date: Thu, 04 Oct 2012 12:12:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/3] block: add queue-private command filter, editable
 via sysfs
References: <1348587009-22400-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1348587009-22400-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/09/2012 17:30, Paolo Bonzini ha scritto:
> The set of use cases for SG_IO is quite variable that no single filter can
> accomodate all of them.  The current filter is tailored very much to
> CD burning, and includes many MMC-specific commands that may have
> other meanings in different standards.  Someone may want to remove
> those commands; at the same time, people that trust their users may
> want to add persistent reservations, trim/discard, or even access to
> vendor-specific commands.
> 
> Filters used to be mutable via sysfs, but the implementation was
> never enabled.  Add it back, and let the admin set this up per device.
> 
> A simple bitmap does not let you do things like enabling command A with
> option B on a specific device for a certain block range.  However, the
> question is really whether this is needed---in fact, neither of the known
> uses for the filtering need it.
> 
> In one use case, the administrator then needs the ability to configure
> devices easily, for example to be much more restrictive on non-MMC
> devices.  It must be done with the same tools it uses for other aspects
> of the policy---which will be a combination of DAC (Unix permissions and
> ACLs) and sysfs.  Different SCSI standards may give different meanings
> for the same byte value, but a simple bitmap is enough for this.
> 
> In the virtualization case, the problem is really that you want to
> pass through everything or almost everything, while still running as
> confined as possible (i.e. CAP_SYS_RAWIO is not a choice).  But in this
> case a more complex filtering can be done just as easily in userspace,
> in the virtual machine monitor.  While the userspace filter can be
> subverted if the guest can escape the QEMU jail, the bitmap still lets
> you block some commands at the kernel level if really necessary.
> 
> One alternative is a ioctl to disable the filter altogether, to be
> used together with SCM_RIGHTS file descriptor passing.  This works in
> the virtualization case but not for policy decisions.  So this patch
> series provides the sysfs knob.  It is a tweaked revert of commit 018e044
> (block: get rid of queue-private command filter, 2009-06-26).
> 
> Please review!
> 
> Paolo
> 
> v1->v2: add OOM and capability checks
> 
> Paolo Bonzini (3):
>   block: add back queue-private command filter
>   scsi: create an all-zero filter for scanners
>   block: add back command filter modification via sysfs
> 
>  Documentation/block/queue-sysfs.txt |   16 +++++
>  block/Kconfig                       |   10 +++
>  block/blk-sysfs.c                   |   43 +++++++++++++
>  block/bsg.c                         |    2 +-
>  block/scsi_ioctl.c                  |  117 +++++++++++++++++++++++++++++++----
>  drivers/scsi/scsi_scan.c            |    6 ++-
>  drivers/scsi/sg.c                   |    7 +-
>  include/linux/blkdev.h              |   31 +++++++++-
>  8 files changed, 213 insertions(+), 19 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Ping?

Tejun, Jens, anyone else, any hope that this gets in 3.7?

Paolo
