Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0FAOyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:54:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18529 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab0FAOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:54:30 -0400
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Chris Mason <chris.mason@oracle.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<1275318102.2823.47.camel@mulgrave.site>
	<4C03D5FD.3000202@panasas.com>
	<20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
	<1275398876.21962.6.camel@mulgrave.site> <20100601133341.GK8980@think>
	<1275399637.21962.11.camel@mulgrave.site>
	<yq1hblmkgka.fsf@sermon.lab.mkp.net>
	<1275402728.21962.35.camel@mulgrave.site>
Date: Tue, 01 Jun 2010 10:54:06 -0400
In-Reply-To: <1275402728.21962.35.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 01 Jun 2010 14:32:08 +0000")
Message-ID: <yq1d3wakdm9.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4C051F1D.000C:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:

>> I experimented with this approach a while back.  However, I quickly
>> got into a situation where frequently updated blocks never made it to
>> disk because the page was constantly being updated.  And all writes
>> failed with a guard tag error.

James> But that's unfixable with a retry based system as well if the
James> page is changing so fast that the guard is always wrong by the
James> time we get to the array.  The only way to fix this is either to
James> copy or freeze the page.

Exactly,  and that's why I'm in favor of the filesystems implementing
whatever method they see fit for ensuring that pages don't change in
flight.  Whether that be locking, unmapping, or copying the page.

If there's a performance hit we can have a flag that indicates whether
this block device requires pages to be stable or not.  I believe extN
really depends on modifying pages for performance reasons.  However,
both XFS and btrfs seem to do just fine without it.

Over time we'll have checksums coming down from userspace with various
I/O submission interfaces, internally generated checksums for filesystem
metadata, etc.  I really don't think a one-size-fits-all retry heuristic
is going to cut it.

-- 
Martin K. Petersen	Oracle Linux Engineering
