Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761530Ab0HMLtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 07:49:41 -0400
Received: from verein.lst.de ([213.95.11.210]:60585 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0HMLti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 07:49:38 -0400
Date: Fri, 13 Aug 2010 13:48:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Message-ID: <20100813114858.GA31937@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281616891-5691-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patchset looks functionally correct to me, and with a small patch
to make use of WRITE_FUA_FLUSH survives xfstests, and instrumenting the
underlying qemu shows that we actually get the flush requests where we should.

No performance or power fail testing done yet.

But I do not like the transition very much.  The new WRITE_FUA_FLUSH
request is exactly what filesystems expect from a current barrier
request, so I'd rather move to that functionality without breaking stuff
inbetween.

So if it was to me I'd keep patches 1, 2, 4 and 5 from your series, than
a main one to relax barrier semantics, then have the renaming patches 7
and 8, and possible keep patch 11 separate from the main implementation
change, and if absolutely also a separate one to introduce REQ_FUA and
REQ_FLUSH in the bio interface, but keep things working while doing
this.

Then we can patches do disable the reiserfs barrier "optimization" as
the very first one, and DM/MD support which I'm currently working on
as the last one and we can start doing the heavy testing.

