Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0HBQdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:33:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:32949 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab0HBQd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:33:29 -0400
Message-ID: <4C56F30D.3020304@kernel.org>
Date: Mon, 02 Aug 2010 18:32:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jaxboe@fusionio.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.35-rc6-git6: Reported regressions from 2.6.34
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera> <AANLkTimcH7+Bq1UEbaSU7SQpzArPgmSLegiqE13V8=CF@mail.gmail.com>
In-Reply-To: <AANLkTimcH7+Bq1UEbaSU7SQpzArPgmSLegiqE13V8=CF@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 16:31:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On 08/01/2010 08:01 PM, Linus Torvalds wrote:
> This has a proposed patch. I don't know what the status of it is, though. Jens?
> 
>    http://marc.info/?l=linux-kernel&m=127950018204029&w=2
> 
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16393
>> Subject         : kernel BUG at fs/block_dev.c:765!
>> Submitter       : Markus Trippelsdorf <markus@trippelsdorf.de>
>> Date            : 2010-07-14 13:52 (19 days old)
>> Message-ID      : <20100714135217.GA1797@arch.tripp.de>
>> References      : http://marc.info/?l=linux-kernel&m=127911564213748&w=2
> 
> This one is interesting. And I think I perhaps see where it's coming from.
> 
> bd_start_claiming() (through bd_prepare_to_claim()) has two separate
> success cases: either there was no holder (bd_claiming is NULL) or the
> new holder was already claiming it (bd_claiming == holder).
> 
> Note in particular the case of the holder _already_ holding it. What happens is:
> 
>  - bd_start_claiming() succeeds because we had _already_ claimed it
> with the same holder
> 
>  - then some error happens, and we call bd_abort_claiming(), which
> does whole->bd_claiming = NULL;
> 
>  - the original holder thinks it still holds the bd, but it has been released!
> 
>  - a new claimer comes in, and succeeds because bd_claiming is now NULL.
> 
>  - we now have two "owners" of the bd, but bd_claiming only points to
> the second one.
> 
> I think bd_start_claiming() needs to do some kind of refcount for the
> nested holder case, and bd_abort_claiming() needs to decrement the
> refcount and only clear the bd_claiming field when it goes down to
> zero.
> 
> I dunno. Maybe there's something else going on, but it does look
> suspicious, and the above would explain the BUG_ON().

Yeah, that definitely sounds plausible.  I think the condition check
in bd_prepare_to_claim() should have been "if (whole->bd_claiming)"
instead of "if (whole->bd_claiming && whole->bd_claiming != holder)".
It doesn't make much sense to allow multiple parallel claiming
operations anyway and the comment above already says - "This function
fails if @bdev is already claimed by another holder and waits if
another claiming is in progress."

I'll try to build a test case and verify it.

Thank you.

-- 
tejun
