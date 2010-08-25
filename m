Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0HYP7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:59:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab0HYP7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:59:47 -0400
Date: Wed, 25 Aug 2010 11:59:18 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Tejun Heo <tj@kernel.org>,
        michaelc@cs.wisc.edu, James.Bottomley@suse.de,
        Hannes Reinecke <hare@suse.de>
Cc: tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com,
        jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com,
        linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
        konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org,
        vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>,
        chris.mason@oracle.com, dm-devel@redhat.com
Subject: [RFC] training mpath to discern between SCSI errors (was: Re:
 [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced
 flush)
Message-ID: <20100825155918.GB8509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C74CD95.1000208@ct.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25 2010 at  4:00am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> > I'm not sure how to proceed here.  How much work would
> > discerning between transport and IO errors take?  If it can't be done
> > quickly enough the retry logic can be kept around to keep the old
> > behavior but that already was a broken behavior, so...  :-(
> 
> I'm not sure how long will it take.

We first need to understand what direction we want to go with this.  We
currently have 2 options.  But any other ideas are obviously welcome.

1)
Mike Christie has a patchset that introduce more specific
target/transport/host error codes.  Mike shared these pointers but he'd
have to put the work in to refresh them:
http://marc.info/?l=linux-scsi&m=112487427230642&w=2
http://marc.info/?l=linux-scsi&m=112487427306501&w=2
http://marc.info/?l=linux-scsi&m=112487431524436&w=2
http://marc.info/?l=linux-scsi&m=112487431524350&w=2

errno.h new EXYZ
http://marc.info/?l=linux-kernel&m=107715299008231&w=2

add block layer blkdev.h error values
http://marc.info/?l=linux-kernel&m=107961883915068&w=2

add block layer blkdev.h error values (v2 convert more drivers)
http://marc.info/?l=linux-scsi&m=112487427230642&w=2

I think that patchset's appoach is fairly disruptive just to be able to
train upper layers to differentiate (e.g. mpath).  But in the end maybe
that change takes the code in a more desirable direction?

2)
Another option is Hannes' approach of having DM consume req->errors and
SCSI sense more directly.

I've refreshed Hannes' previous patchset against 2.6.36-rc2 but I
haven't finished testing it yet (should be OK.. it boots, but still have
FIXME to move scsi_uld_should_retry to scsi_error.c):
http://people.redhat.com/msnitzer/patches/dm-scsi-sense/

Would be great if James, Hannes and others had a look at this
refreshed RFC patchset.  It's clearly not polished but it gives an idea
of the approach.  Does this look worthwhile?

Follow-on work is needed to refine scsi_uld_should_retry further.  Keep
in mind that scsi_error.c is the intended location for this code.

James, please note that I've attempted to make REQ_TYPE_FS set
req->errors only for "genuine errors" by (ab)using
scsi_decide_disposition:
http://people.redhat.com/msnitzer/patches/dm-scsi-sense/scsi-Always-pass-error-result-and-sense-on-request-completion.patch

If others think this may be worthwhile I can finish testing, cleanup the
patches further, and post them.

Mike
