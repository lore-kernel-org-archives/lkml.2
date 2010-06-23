Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0FWNEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 09:04:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab0FWNEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 09:04:09 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when using CFQ
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<20100623092028.GA13900@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 23 Jun 2010 09:03:52 -0400
In-Reply-To: <20100623092028.GA13900@infradead.org> (Christoph Hellwig's
	message of "Wed, 23 Jun 2010 05:20:28 -0400")
Message-ID: <x49mxulq4sn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, Jun 22, 2010 at 05:34:59PM -0400, Jeff Moyer wrote:
>> Hi,
>> 
>> Running iozone with the fsync flag, or fs_mark, the performance of CFQ is
>> far worse than that of deadline for enterprise class storage when dealing
>> with file sizes of 8MB or less.  I used the following command line as a
>> representative test case:
>> 
>>   fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096 -F
>> 
>> When run using the deadline I/O scheduler, an average of the first 5 numbers
>> will give you 448.4 files / second.  CFQ will yield only 106.7.  With
>> this patch series applied (and the two patches I sent yesterday), CFQ now
>> achieves 462.5 files / second.
>> 
>> This patch set is still an RFC.  I'd like to make it perform better when
>> there is a competing sequential reader present.  For now, I've addressed
>> the concerns voiced about the previous posting.
>
> What happened to the initial idea of just using the BIO_RW_META flag
> for log writes?  In the end log writes are the most important writes you
> have in a journaled filesystem, and they should not be effect to any
> kind of queue idling logic or other interruption.  Log I/O is usually
> very little (unless you use old XFS code with a worst-case directory
> manipulation workload), and very latency sensitive.

Vivek showed that starting firefox in the presence of a processing doing
fsyncs (using the RQ_META approach) took twice as long as without the
patch:
  http://lkml.org/lkml/2010/4/6/276

Cheers,
Jeff
