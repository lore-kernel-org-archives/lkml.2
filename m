Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0HIVT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 17:19:26 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:25602 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab0HIVTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 17:19:25 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=7Awd4vsLCzQA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel0A:10
 a=xqWC_Br6kY4A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=C-FMxcPHgfcgdeUZAkEA:9
 a=MFPhBHoM948ecDh_grnvu8pGcX8A:4 a=CjuIK1q_8ugA:10
Subject: Re: [RFC v3] ext4: Combine barrier requests coming from fsync
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20100809195324.GG2109@tux1.beaverton.ibm.com>
Date: Mon, 9 Aug 2010 17:19:22 -0400
Cc: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
        Ric Wheeler <rwheeler@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com>
To: djwong@us.ibm.com
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-09, at 15:53, Darrick J. Wong wrote:
> This patch attempts to coordinate barrier requests being sent in by fsync.  Instead of each fsync call initiating its own barrier, there's now a flag to indicate if (0) no barriers are ongoing, (1) we're delaying a short time to collect other fsync threads, or (2) we're actually in-progress on a barrier.
> 
> So, if someone calls ext4_sync_file and no barriers are in progress, the flag shifts from 0->1 and the thread delays for 500us to see if there are any other threads that are close behind in ext4_sync_file.  After that wait, the state transitions to 2 and the barrier is issued.  Once that's done, the state goes back to 0 and a completion is signalled.

You shouldn't use a fixed delay for the thread.  500us _seems_ reasonable, if you have a single HDD.  If you have an SSD, or an NVRAM-backed array, then 2000 IOPS is a serious limitation.

What is done in the JBD2 code is to scale the commit sleep interval based on the average commit time.  In fact, the ext4_force_commit-> ...->jbd2_journal_force_commit() call will itself be waiting in the jbd2 code to merge journal commits.  It looks like we are duplicating some of this machinery in ext4_sync_file() already.

It seems like a better idea to have a single piece of code to wait to merge the IOs.  For the non-journal ext4 filesystems it should implement the wait for merges explicitly, otherwise it should defer the wait to jbd2.

Cheers, Andreas





