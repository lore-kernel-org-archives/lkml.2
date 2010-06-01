Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab0FAN2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:28:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab0FAN2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:28:03 -0400
Subject: Re: Wrong DIF guard tag on ext2 write
From: James Bottomley <James.Bottomley@suse.de>
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	 <1275318102.2823.47.camel@mulgrave.site> <4C03D5FD.3000202@panasas.com>
	 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 13:27:56 +0000
Message-ID: <1275398876.21962.6.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 12:30 +0200, Christof Schmitt wrote:
> What is the best strategy to continue with the invalid guard tags on
> write requests? Should this be fixed in the filesystems?

For write requests, as long as the page dirty bit is still set, it's
safe to drop the request, since it's already going to be repeated.  What
we probably want is an error code we can return that the layer that sees
both the request and the page flags can make the call.

> Another idea would be to pass invalid guard tags on write requests
> down to the hardware, expect an "invalid guard tag" error and report
> it to the block layer where a new checksum is generated and the
> request is issued again. Basically implement a retry through the whole
> I/O stack. But this also sounds complicated.

No, no ... as long as the guard tag is wrong because the fs changed the
page, the write request for the updated page will already be queued or
in-flight, so there's no need to retry.  We still have to pass checksum
failures on in case the data changed because of some HW (or SW) cockup.
The check for this is page dirty.  If we get a checksum error back and
the page is still clean, we know nothing in the OS changed it, therefore
it's a real bit flip error.

James


