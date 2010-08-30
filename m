Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0H3LjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:39:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:32932 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375Ab0H3Li6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:38:58 -0400
Message-ID: <4C7B984E.4070802@suse.de>
Date: Mon, 30 Aug 2010 13:38:54 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Tejun Heo <tj@kernel.org>,
        michaelc@cs.wisc.edu, James.Bottomley@suse.de, tytso@mit.edu,
        linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz,
        linux-kernel@vger.kernel.org, swhiteho@redhat.com,
        linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
        konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org,
        vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>,
        chris.mason@oracle.com, dm-devel@redhat.com
Subject: Re: [RFC] training mpath to discern between SCSI errors
References: <20100825155918.GB8509@redhat.com>
In-Reply-To: <20100825155918.GB8509@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer wrote:
> On Wed, Aug 25 2010 at  4:00am -0400,
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> 
>>> I'm not sure how to proceed here.  How much work would
>>> discerning between transport and IO errors take?  If it can't be done
>>> quickly enough the retry logic can be kept around to keep the old
>>> behavior but that already was a broken behavior, so...  :-(
>> I'm not sure how long will it take.
> 
> We first need to understand what direction we want to go with this.  We
> currently have 2 options.  But any other ideas are obviously welcome.
> 
> 1)
> Mike Christie has a patchset that introduce more specific
> target/transport/host error codes.  Mike shared these pointers but he'd
> have to put the work in to refresh them:
> http://marc.info/?l=linux-scsi&m=112487427230642&w=2
> http://marc.info/?l=linux-scsi&m=112487427306501&w=2
> http://marc.info/?l=linux-scsi&m=112487431524436&w=2
> http://marc.info/?l=linux-scsi&m=112487431524350&w=2
> 
> errno.h new EXYZ
> http://marc.info/?l=linux-kernel&m=107715299008231&w=2
> 
> add block layer blkdev.h error values
> http://marc.info/?l=linux-kernel&m=107961883915068&w=2
> 
> add block layer blkdev.h error values (v2 convert more drivers)
> http://marc.info/?l=linux-scsi&m=112487427230642&w=2
> 
> I think that patchset's appoach is fairly disruptive just to be able to
> train upper layers to differentiate (e.g. mpath).  But in the end maybe
> that change takes the code in a more desirable direction?
> 
> 2)
> Another option is Hannes' approach of having DM consume req->errors and
> SCSI sense more directly.
> 

Actually, I think we have two separate issues here:
1) The need of having more detailed I/O errors even in the fs layer. This
   we've already discussed at the LSF, consensus here is to allow other
   errors than just 'EIO'.
   Instead of Mike's approach I would rather use existing error codes here;
   this will make the transition somewhat easier.
   Initially I would propose to return 'ENOLINK' for a transport failure,
   'EIO' for a non-retryable failure on the target, and 'ENODEV' for a
   retryable failure on the target.

2) The need to differentiate the various error conditions on the multipath
   layer. Multipath needs to distinguish the three error types as specified
   in 1)

Mike has been trying to solve 1) and 2) by introducing separate/new error
codes, and I have been trying to use 2) by parsing the sense codes directly
from multipathing.

Given that the fs people have expressed their desire to know about these
error classes, too, it makes sense to have them exposed to the fs layer.

I see if I can come up with a patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
