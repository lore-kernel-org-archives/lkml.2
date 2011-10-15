Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1JOV1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 17:27:33 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45824 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433Ab1JOV1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 17:27:31 -0400
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of staging
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        linux-scsi@vger.kernel.org, hch@infradead.org,
        Haiyang Zhang <haiyangz@microsoft.com>
In-Reply-To: <1318660132-21529-1-git-send-email-kys@microsoft.com>
References: <1318660132-21529-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Oct 2011 16:27:27 -0500
Message-ID: <1318714047.7271.49.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 23:28 -0700, K. Y. Srinivasan wrote:
> In preparation for moving the storage driver out of staging, seek community
> review of the storage  driver code.

That's not exactly a very descriptive commit message for me to put into
SCSI.  It doesn't have to be huge, just something like "driver to enable
hyperv windows guest on Linux" or something.


>  drivers/scsi/Kconfig             |    7 +
>  drivers/scsi/Makefile            |    3 +
>  drivers/scsi/storvsc_drv.c       | 1480 ++++++++++++++++++++++++++++++++++++++
>  drivers/staging/hv/Kconfig       |    6 -
>  drivers/staging/hv/Makefile      |    2 -
>  drivers/staging/hv/storvsc_drv.c | 1480 --------------------------------------
>  6 files changed, 1490 insertions(+), 1488 deletions(-)

What tree is this against?  The hv/storvsc_drv.c in upstream only has

jejb@dabdike> wc -l drivers/staging/hv/storvsc_drv.c 
792 drivers/staging/hv/storvsc_drv.c

i.e. whatever you're sending is double the length (and obviously I have
trouble applying the patch.

> +++ b/drivers/scsi/storvsc_drv.c
> @@ -0,0 +1,1480 @@

So not a detailed review, but a couple of structural observations:

The whole driver is a writeout deadlock trap since I assume you intend
for it to be used as root/swap of a linux guest?  The writeout deadlock
occurs when we can't make forward progress on a direct writeout I/O
because one of the GFP_ATOMIC memory allocations in your driver fails.
The only way to fix this is to back the allocations with mempools (one
per actual device) so you can guarantee that whatever memory pressure
the system is under, one command can always make the round trip to
storage and back.

You use the locked version of queuecommand, but it looks like you don't
need the host lock in the submit path, so why not just use the unlocked
version?

The bounce buffer handling for discontiguous sg lists is a complete
nightmare.  And can't you just fix the hypervisor instead of pulling
this level of nastiness in the driver, I mean really, the last piece of
real SCSI hardware that failed this badly was produced in the dark ages.
Assuming the answer is "no", I really think you need to set the minimum
block size to 4k, which will completely avoid the situation.

Minor, but use accessors like shost_priv()

The SET WINDOW command is an obsolete scanner command ... the comment
about smart issuing it looks completely bogus, but even if there's
something issuing scanner commands and your hypervisor crashes on them,
you need to reject it with ILLEGAL_REQUEST not DID_ERROR.

All the business around max segment size and supplying your own merge
biovec function looks a bit bogus, don't you just want to disable
clustering?  This looks like another knock on from the weird hypervisor
sg list handling, where you apparently need one sg entry per page.  This
was originally a bug in the circa 1990 era NCR 53c800 host controllers
we then had, so that's actually why the clustering parameter exists ...
it's sort of nostalgic to see you resurrecting such an ancient bug.

James


