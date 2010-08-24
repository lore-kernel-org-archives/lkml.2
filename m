Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab0HXSNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 14:13:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:40372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab0HXSNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 14:13:19 -0400
Message-ID: <4C740BEF.2010806@kernel.org>
Date: Tue, 24 Aug 2010 20:14:07 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Hannes Reinecke <hare@suse.de>,
        tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com,
        jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com,
        linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
        James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp,
        linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com,
        Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com,
        dm-devel@redhat.com
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <20100814103654.GA13292@lst.de> <4C6A5D8A.4010205@kernel.org> <20100817131915.GB2963@lst.de> <4C6ABBCB.9030306@kernel.org> <20100817165929.GB13800@lst.de> <4C6E3C1A.50205@ct.jp.nec.com> <4C72660A.7070009@kernel.org> <20100823141733.GA21158@redhat.com> <4C739DE9.5070803@ct.jp.nec.com> <4C73FA8F.5080800@kernel.org> <20100824175215.GA29409@redhat.com>
In-Reply-To: <20100824175215.GA29409@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 Aug 2010 18:12:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/24/2010 07:52 PM, Mike Snitzer wrote:
>> If it can't be done quickly enough the retry logic can be kept around
>> to keep the old behavior but that already was a broken behavior, so...
>> :-(
> 
> I'll have to review this thread again to understand why mpath's existing
> retry logic is broken behavior.  mpath is used with more capable SCSI
> devices so I'm missing why a failed FLUSH implies data loss.

SBC doesn't specify the failure behavior, so it could be that retrying
flush could be safe.  But for most disk type devices, flush failure
usually indicates that the device exhausted all the options to commit
some of pending data to NV media - ie. even remapping failed for
whatever reason.  Even if retry is safe, it's more likely to simply
delay notification of failure.

In ATA, the situation is clearer, when a device actively fails a
flush, the drive reports the first failed sector it failed to commit
and the next flush will continue _after_ the sector - IOW, data is
already lost.

<speculation>
I think there's no reason mpath should be tasked with retrying flush
failure.  That's upto the SCSI EH.  If the command failed in 'safe'
transient way - ie. device busy or whatnot, SCSI EH can and does retry
the command.  There are several FAILFAST bits already and SCSI EH can
avoid retrying transport errors for mpath (maybe it already does
that?) and just need to be able to tell upper layer that the failure
was a fast one and upper layer is responsible for retrying?  Is there
any reason to pass the whole sense information upwards?
</speculation>

Anyways, flush failure is different from read/write failures.
Read/writes can always be retried cleanly.  They are stateless.  I
don't know how SCSI devices would actually behavior but it's a bit
scary to retry SYNCHRONIZE_CACHE a device failed and report success
upwards.

Thanks.

-- 
tejun
