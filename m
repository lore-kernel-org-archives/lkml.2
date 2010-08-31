Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0HaKOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 06:14:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:39976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab0HaKOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 06:14:34 -0400
Message-ID: <4C7CD5D0.40007@kernel.org>
Date: Tue, 31 Aug 2010 12:13:36 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        rwheeler@redhat.com, hare@suse.de, neilb@suse.de,
        rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de> <4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz> <4C76250B.6060800@kernel.org> <20100827173147.GA12374@quack.suse.cz> <x4939tv98n8.fsf@segfault.boston.devel.redhat.com> <20100830202034.GB12226@quack.quadriga.com> <4C7CB936.8010509@kernel.org> <4C7CD47B.1050409@panasas.com>
In-Reply-To: <4C7CD47B.1050409@panasas.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 31 Aug 2010 10:13:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/31/2010 12:07 PM, Boaz Harrosh wrote:
> I don't know all the specifics of the virtio driver and the KVM backend but
> don't the KVM target io is eventually directed to a local file or device?
> If so the scsi device has disappeard but the bulk of the data is in host cache
> at the backstore (file or bdev). Once all files are closed the data is synced
> to disk.
> 
> Is it not the same as Ric's problem of disconnecting the sata cable but
> not dropping power to the drive. The main of the cache is still intact.

There are two layers of caching there.

 drive cache - host page cache - guest

When guest issues FLUSH, qemu will translate it into fdatasync which
will flush the host page cache followed by FLUSH to the drive which
will flush the drive cache to the media.  If you delete the host disk
device, it will be detached w/o host page cache flushed.  So, although
it's not complete, it will lose good part of cache.  With out write
out timeout increased and/or with laptop mode enabled, it will
probably lose most of cache.

Thanks.

-- 
tejun
