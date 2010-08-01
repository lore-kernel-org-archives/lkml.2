Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0HASBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 14:01:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940Ab0HASBj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 14:01:39 -0400
MIME-Version: 1.0
In-Reply-To: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 Aug 2010 11:01:04 -0700
Message-ID: <AANLkTimcH7+Bq1UEbaSU7SQpzArPgmSLegiqE13V8=CF@mail.gmail.com>
Subject: Re: 2.6.35-rc6-git6: Reported regressions from 2.6.34
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jaxboe@fusionio.com>,
        Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 1, 2010 at 6:46 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16400
> Subject         : 2.6.35-rc5 inconsistent lock state
> Submitter       : Martin Pirker <lkml.collector@gmail.com>
> Date            : 2010-07-14 20:33 (19 days old)
> Message-ID      : <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127913961025267&w=2

This has a proposed patch. I don't know what the status of it is, though. Jens?

   http://marc.info/?l=linux-kernel&m=127950018204029&w=2

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16393
> Subject         : kernel BUG at fs/block_dev.c:765!
> Submitter       : Markus Trippelsdorf <markus@trippelsdorf.de>
> Date            : 2010-07-14 13:52 (19 days old)
> Message-ID      : <20100714135217.GA1797@arch.tripp.de>
> References      : http://marc.info/?l=linux-kernel&m=127911564213748&w=2

This one is interesting. And I think I perhaps see where it's coming from.

bd_start_claiming() (through bd_prepare_to_claim()) has two separate
success cases: either there was no holder (bd_claiming is NULL) or the
new holder was already claiming it (bd_claiming == holder).

Note in particular the case of the holder _already_ holding it. What happens is:

 - bd_start_claiming() succeeds because we had _already_ claimed it
with the same holder

 - then some error happens, and we call bd_abort_claiming(), which
does whole->bd_claiming = NULL;

 - the original holder thinks it still holds the bd, but it has been released!

 - a new claimer comes in, and succeeds because bd_claiming is now NULL.

 - we now have two "owners" of the bd, but bd_claiming only points to
the second one.

I think bd_start_claiming() needs to do some kind of refcount for the
nested holder case, and bd_abort_claiming() needs to decrement the
refcount and only clear the bd_claiming field when it goes down to
zero.

I dunno. Maybe there's something else going on, but it does look
suspicious, and the above would explain the BUG_ON().

Tejun, Jens?

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16369
> Subject         : Yet another 2.6.35 regression (AGP)?
> Submitter       : Woody Suwalski <terraluna977@gmail.com>
> Date            : 2010-07-09 14:21 (24 days old)
> Message-ID      : <4C373084.8000503@gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127868797119254&w=2

Should hopefully be fixed by commit e7b96f28c58c ("agp/intel: Use the
correct mask to detect i830 aperture size.")

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16365
> Subject         : kernel BUG at fs/btrfs/extent-tree.c:1353
> Submitter       : Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
> Date            : 2010-07-08 14:27 (25 days old)
> Message-ID      : <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
> References      : http://marc.info/?l=linux-kernel&m=127859960725931&w=2

This one is reportedly fixed by commit 83ba7b071f30 ("writeback:
simplify the write back thread queue")

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16215
> Subject         : sysfs: cannot create duplicate filename '/class/net/bnep0'
> Submitter       : Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> Date            : 2010-06-15 14:55 (48 days old)
> Handled-By      : Eric W. Biederman <ebiederm@xmission.com>

Fixed by commit 24b1442d01ae155ea716dfb94ed21605541c317d.

                             Linus
