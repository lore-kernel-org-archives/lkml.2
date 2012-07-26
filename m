Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab2GZMno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:43:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60249 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2GZMnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:43:41 -0400
Date: Thu, 26 Jul 2012 20:43:32 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>,
        Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH v3 2/7] scsi: pm: use autosuspend if device supports it
Message-ID: <20120726124326.GA2022@localhost.localdomain>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
 <1343297129-28174-3-git-send-email-aaron.lu@amd.com>
 <1476441.ovA4GKBza3@linux-lqwf.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476441.ovA4GKBza3@linux-lqwf.site>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 12:44:24PM +0200, Oliver Neukum wrote:
> On Thursday 26 July 2012 18:05:24 Aaron Lu wrote:
> > If the device is using autosuspend, when scsi_autopm_put_device is
> > called for it, use autosuspend runtime pm calls instead of the sync
> > call.
> 
> What is the purpose of this approach?

The purpose is to let scsi layer driver(sd, sr, etc.) use the same pm
api(scsi_autopm_put_device) to put the device to runtime suspended
state.
When the device is ready to be suspended, if it does not make use of
autosuspend, call pm_runtime_put_sync for it; if it makes use of
autosuspend, call the autosuspend runtime pm apis for it.

> You need a very good reason to have an API do two different things
> based on this.

If you see the above reason not good, I'll prepare an updated version
to create a new api to cover the autosuspend case, something like:
void scsi_autopm_put_device_autosuspend(struct scsi_device *sdev)
{
	pm_runtime_mark_last_busy(&sdev->sdev_gendev);
	pm_runtime_put_autosuspend(&sdev->sdev_gendev);
}
Does this look right?

Thanks,
Aaron
