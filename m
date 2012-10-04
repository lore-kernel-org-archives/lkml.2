Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2JDUiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:38:21 -0400
Received: from 1wt.eu ([62.212.114.60]:35911 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab2JDUiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:38:20 -0400
Date: Thu, 4 Oct 2012 22:38:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Bottomley <JBottomley@Parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 089/180] SCSI: fix scsi_wait_scan
Message-ID: <20121004203813.GL10245@1wt.eu>
References: <6a854f579a99b4fe2efaca1057e8ae22@local> <20121001225201.376690206@1wt.eu> <20121004203436.GD13292@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004203436.GD13292@decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 09:34:36PM +0100, Ben Hutchings wrote:
> On Tue, Oct 02, 2012 at 12:53:26AM +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: James Bottomley <jbottomley@parallels.com>
> > 
> > commit 1ff2f40305772b159a91c19590ee159d3a504afc upstream.
> > 
> > Commit  c751085943362143f84346d274e0011419c84202
> > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > Date:   Sun Apr 12 20:06:56 2009 +0200
> > 
> >     PM/Hibernate: Wait for SCSI devices scan to complete during resume
> > 
> > Broke the scsi_wait_scan module in 2.6.30.  Apparently debian still uses it so
> > fix it and backport to stable before removing it in 3.6.
> [...]
> > --- a/drivers/scsi/scsi_wait_scan.c
> > +++ b/drivers/scsi/scsi_wait_scan.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/module.h>
> >  #include <linux/device.h>
> >  #include <scsi/scsi_scan.h>
> > +#include "scsi_priv.h"
> >  
> >  static int __init wait_scan_init(void)
> >  {
> 
> This backported version is a no-op.  I think we need to do:
> 
> -#include <scsi/scsi_scan.h>
> +
> +extern int scsi_complete_async_scans(void);

But this is what we have in scsi_scan.h :

#ifdef CONFIG_SCSI
/* drivers/scsi/scsi_scan.c */
extern int scsi_complete_async_scans(void);
#else
static inline int scsi_complete_async_scans(void) { return 0; }
#endif

Since CONFIG_SCSI_WAIT_SCAN depends on CONFIG_SCSI, we're certain to have
it defined when we build this code.

Am I missing something ?

Regards,
Willy

