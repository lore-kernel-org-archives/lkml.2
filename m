Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0HRT3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:29:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab0HRT3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:29:03 -0400
Message-ID: <4C6C3481.7000302@vlnb.net>
Date: Wed, 18 Aug 2010 23:29:05 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz,
        rwheeler@redhat.com, hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <4C6540C5.8070108@vlnb.net> <20100813131722.GB4140@lst.de>
In-Reply-To: <20100813131722.GB4140@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:QN3W2llJWEeOWnU72imQU2ronTBwgGI5jw86yruxuUn
 9QOWTEI42Yqqky+YyMSG2jfd1Jf/nckaGBFuAs4RK0DKt4gW68
 2K73+V5DintMBaY1njaRVQnLqgpEySVEoiGMb0eNDOLv2OMMpP
 SCPxH+9jCM2ROFhfymQo47c+KkLCvsnp0tL/W1bNhLYPpSF1L6
 D8XSq/hxJufQvCT5SK32A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig, on 08/13/2010 05:17 PM wrote:
> As far as playing with ordered tags it's just adding a new flag for
> it on the bio that gets passed down to the driver.  For a final version
> you'd need a queue-level feature if it's supported, but you don't
> even need that for the initial work.  Then you can implement a
> variant of blk_do_flush that does away with queueing additional requests
> once finish but queues all two or three at the same time with your
> new ordered flag set, at which point you are back to the level or
> ordered tag usage that the old code allows.  You're still left with
> all the hard problems of actually implementing error handling for it
> and using it higher up in the filesystem and generic page cache code.

But how about file systems doing internal local order-by-drain? Without 
converting them to use ordered commands it would be impossible to show 
full potential of them and to make the conversion one would need deep 
internal FS knowledge. That's my point. But if there's a trivial way to 
see all such places in the filesystems code and convert, then OK, I agree.

> I'd really love to see your results, up to the point of just trying
> that once I get a little spare time.  But my theory is that it won't
> help us - the problem with ordered tags is that they enforce global
> ordering while we currently have local ordering.  While it will reduce
> the latency for the process waiting for an fsync or similar it will
> affect other I/O going on in the background and reduce the devices
> ability to reorder that I/O.

The local ordering vs global ordering is relevant only if you have 
several applications/threads load. But how about a single 
application/thread?

Another point, for which, AFAIU, the ORDERED commands were invented, is 
that they make ordering on the _another_ side of the link _after_ all 
link/transfer latencies. This is why it's hard to see advantage of them 
on local disks.

Vlad
