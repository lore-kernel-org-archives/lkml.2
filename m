Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401Ab0KQKBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:01:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:53168 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933216Ab0KQKBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:01:37 -0500
Message-ID: <4CE3A7E9.3010009@kernel.org>
Date: Wed, 17 Nov 2010 11:01:13 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
References: <20101117062958.GA2894@havoc.gtf.org> <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com> <4CE38D70.4010507@garzik.org>
In-Reply-To: <4CE38D70.4010507@garzik.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Nov 2010 10:01:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeff, Linus.

On 11/17/2010 09:08 AM, Jeff Garzik wrote:
> Looking solely at the SCSI code (ie. ignoring LLD code), it seems
> like the magic number zero for serial_number is signaling a boolean
> condition "are we an EH command?"
> 
> EH tests this at the very beginning of the abort/reset/explode error
> handling sequence, presumably to avoid recursive EH invocations
> (scsi_try_to_abort_cmd).
>
> So maybe an EH expert (Tejun?) can correct me here, but I think we
> may be able to completely the lock/get-serial/unlock sequence from
> libata, as long as scsi_init_cmd_errh() reliably sets an "I am an EH
> command" flag.
> 
> Would be nice if true...

Yeah, it's actually nice (for once).  libata doesn't use or care about
scmd->serial_number at all.  The SCSI EH path you mentioned above is
not applicable as libata implements its eh_strategy_handler and SCSI
only calls scsi_try_to_abort_cmd() for the default EH handler,
scsi_unjam_host().

We'll need to test a bit to make sure everything is okay but I'm
fairly certain removing it won't break anything fundamental.  If
something breaks at all, it would be some silly easy-to-fix thing.

Thanks.

-- 
tejun
