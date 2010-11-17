Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553Ab0KQGoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:44:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933259Ab0KQGoh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:44:37 -0500
MIME-Version: 1.0
In-Reply-To: <20101117062958.GA2894@havoc.gtf.org>
References: <20101117062958.GA2894@havoc.gtf.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 22:44:14 -0800
Message-ID: <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com>
Subject: Re: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 10:29 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> +       spin_lock(shost->host_lock);
> +       scsi_cmd_get_serial(shost, cmd);
>        spin_unlock(shost->host_lock);

This is just sad.

How important is that serial number? So important that we need to do a
spinlock over it here? And it _must_ be per-shost?

Because if you made it per-ap, you could easily just move that logic
down to after you get the ap lock.

Just add a "unsigned int serial_number" into the ata_port struct, and
do the same (trivial) logic for getting a non-zero serial number
there:

  n = ap->serial_number;
  if (!++n)
    n = 1
  ap->serial_number = n;
  cmd->serial_number = n;

or something. And then you'd _really_ not need to touch that totally
pointless host lock at all.

               Linus
