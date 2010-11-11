Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0KKPxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:53:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:45592 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab0KKPxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:53:09 -0500
Subject: Re: [PATCH] scsi: Convert scsi_host->cmd_serial_number to odd
 numbered atomic_t counter
From: James Bottomley <James.Bottomley@suse.de>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <1289472405-31003-1-git-send-email-nab@linux-iscsi.org>
References: <1289472405-31003-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 09:53:03 -0600
Message-ID: <1289490783.2982.33.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 02:46 -0800, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts struct scsi_host->cmd_serial_number to a 'odd incremented by 2'
> atomic_t counter in scsi_cmd_get_serial(), and moves the host_lock held call in
> jgarzik's DEF_SCSI_QCMD() wrapper back into it's original location in scsi_dispatch_cmd().

Actually, no ... this isn't really a good idea; you're lengthening our
critical path here (an atomic costs a lot more than a simple add under
spinlock).

There are only a few drivers left that actually make use of a serial
number.  Of those, the only modern ones are qla4, lpfc, mpt2sas and
megaraid.

So the next logical step seems to be eliminate the overloading of the
serial number zero value, which removes the last mid-layer use (dpt_i2o
seems to abuse this unnecessarily as well), then the serial number code
can be pushed down into the queuecommand routines of only those drivers
that actually use it.  None of the modern ones seems to have a
legitimate use, so I think their uses can mostly be eliminated.  Thus,
we might be able to get away with a simple queuecommand push down and
never bother with atomics for this (since it's unlikely the legacy users
would convert away from a lock wrapping their queuecommand routines).

James


