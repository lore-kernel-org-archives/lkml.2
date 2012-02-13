Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab2BMQ3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:29:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab2BMQ3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:29:30 -0500
Date: Mon, 13 Feb 2012 11:29:24 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>,
        Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: scsi_error: do not allow IO errors with certain ILLEGAL_REQUEST
 sense to be retryable
Message-ID: <20120213162923.GA29578@redhat.com>
References: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
 <yq1zkf5pfx1.fsf@sermon.lab.mkp.net>
 <20111206212704.GB30719@redhat.com>
 <yq1vcptpdch.fsf@sermon.lab.mkp.net>
 <20111206224218.GA31543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206224218.GA31543@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06 2011 at  5:42pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Dec 06 2011 at  5:03pm -0500,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> 
> > >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> > 
> > Mike> Regardless, shouldn't the SCSI midlayer classify such
> > Mike> ILLEGAL_REQUEST sense, with an add. sense I listed in the patch,
> > Mike> as a target error?
> > 
> > Well, even SUCCESS should cause the I/O to be aborted.
> 
> As I replied to James, yes SUCCESS does cause the IO to fail, but the
> discard gets retried by multipath.
> 
> Returning TARGET_ERROR enables the block layer to return -EREMOTEIO
> which multipath will immediately pass up (rather than the normal fail
> path and retry).
>  
> > I assume this is the RHEL6 kernel? Did you backport my provisioning
> > updates that brings the heuristics in sync with SBC-3 (#c98a0e)?
> 
> Yes, that update was pulled in to RHEL6.2 (released today).  But this
> issue is a concern for both upstream and RHEL6 (and any other distro
> with a recent kernel).

Hey Martin and James,

(for the benefit of others, original proposed fix is here):
http://www.spinics.net/lists/linux-scsi/msg55792.html

I've had 2 additional reports from different storage vendors that they
(or their customers) are having Linux (RHEL6) installation failures.
The reason is their storage is broken:
- they set TPE in the storage target's READ CAPACITY response
- but they only support UNMAP (not WRITE SAME w/ UNMAP bit set)
  - but they don't properly populate the BLOCK LIMITS VPD; so Linux
    defaults to using WRITE SAME w/ UNMAP bit set.

So that makes 3 different _prominent_ storage vendors, that I am aware
of, that are bitten by their broken storage (relative to discard and
properly advertising which variant they actually support).  I'd much
rather deal with the storage vendors (or their customers) reporting that
discards aren't working than mutual customers reporting that they cannot
even install to the storage.

The ultimate fix is clear: storage vendors need to fix their storage
(2 of the 3 have, 1 is working on it).  But a Linux-only workaround for
this series of unfortunate events (particularly as it happens with
multipath in the mix) is to have SCSI classify certain ILLEGAL_REQUEST
as the TARGET_ERROR that they are.

I would very much appreciate this fix making its way to Linux 3.3 (even
though we're past the merge window this is a pure fix).

It will allow Linux to cope with vendors' storage that is broken.

Please advise, Ack, submit for upstream 3.3 inclusion, etc... thanks! :)

Mike
