Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0FCMHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:07:41 -0400
Received: from daytona.panasas.com ([67.152.220.89]:27893 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992Ab0FCMHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:07:39 -0400
Message-ID: <4C079B07.5020303@panasas.com>
Date: Thu, 03 Jun 2010 15:07:35 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: James Bottomley <James.Bottomley@suse.de>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Gennadiy Nerubayev <parakie@gmail.com>
Subject: Re: Wrong DIF guard tag on ext2 write
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>	 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>	 <1275318102.2823.47.camel@mulgrave.site> <4C03D5FD.3000202@panasas.com>	 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com> <1275398876.21962.6.camel@mulgrave.site> <4C078FE2.9000804@vlnb.net>
In-Reply-To: <4C078FE2.9000804@vlnb.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2010 12:07:37.0838 (UTC) FILETIME=[5BBB28E0:01CB0315]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2010 02:20 PM, Vladislav Bolkhovitin wrote:
> 
> There's one interesting problem here, at least theoretically, with SCSI 
> or similar transports which allow to have commands queue depth >1 and 
> allowed to internally reorder queued requests. I don't know the FS/block 
> layers sufficiently well to tell if sending several requests for the 
> same page really possible or not, but we can see a real life problem, 
> which can be well explained if it's possible.
> 
> The problem could be if the second (rewrite) request (SCSI command) for 
> the same page queued to the corresponding device before the original 
> request finished. Since the device allowed to freely reorder requests, 
> there's a probability that the original write request would hit the 
> permanent storage *AFTER* the retry request, hence the data changes it's 
> carrying would be lost, hence welcome data corruption.
> 

I might be totally wrong here but I think NCQ can reorder sectors but
not writes. That is if the sector is cached in device memory and a later
write comes to modify the same sector then the original should be
replaced not two values of the same sector be kept in device cache at the
same time.

Failing to do so is a scsi device problem.

Please note that page-to-sector is not necessary constant. And the same page
might get written at a different sector, next time. But FSs will have to
barrier in this case.

> For single parallel SCSI or SAS devices such race may look practically 
> impossible, but for sophisticated clusters when many nodes pretending to 
> be a single SCSI device in a load balancing configuration, it becomes 
> very real.
> 
> The real life problem we can see in an active-active DRBD-setup. In this 
> configuration 2 nodes act as a single SCST-powered SCSI device and they 
> both run DRBD to keep their backstorage in-sync. The initiator uses them 
> as a single multipath device in an active-active round-robin 
> load-balancing configuration, i.e. sends requests to both nodes in 
> parallel, then DRBD takes care to replicate the requests to the other node.
> 
> The problem is that sometimes DRBD complies about concurrent local 
> writes, like:
> 
> kernel: drbd0: scsi_tgt0[12503] Concurrent local write detected! 
> [DISCARD L] new: 144072784s +8192; pending: 144072784s +8192
> 
> This message means that DRBD detected that both nodes received 
> overlapping writes on the same block(s) and DRBD can't figure out which 
> one to store. This is possible only if the initiator sent the second 
> write request before the first one completed.
> 

It is totally possible in today's code.

DRBD should store the original command_sn of the write and discard
the sector with the lower SN. It should appear as a single device
to the initiator.

> The topic of the discussion could well explain the cause of that. But, 
> unfortunately, people who reported it forgot to note which OS they run 
> on the initiator, i.e. I can't say for sure it's Linux.
> 
> Vlad
> 

Boaz
