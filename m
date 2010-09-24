Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab0IXGYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 02:24:09 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:42822 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0IXGYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 02:24:07 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=H95gfW32JB/XYJSBuOTvJ8IIviFcsPdfxXHbM7LS6jM= c=1 sm=1
 a=TuThC90Nb-EA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=DtQNR282OvZCYDttZ9UA:9
 a=qi9NmP5Jqy7LE5SQ0EvOCgyd6jYA:4 a=CjuIK1q_8ugA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: Performance testing of various barrier reduction patches [was:	Re: [RFC v4] ext4: Coordinate fsync requests]
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20100923232527.GB25624@tux1.beaverton.ibm.com>
Date: Fri, 24 Sep 2010 00:24:04 -0600
Cc: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
        Ric Wheeler <rwheeler@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, hch@lst.de
Content-Transfer-Encoding: 8BIT
Message-Id: <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca>
References: <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca> <20100809233805.GH2109@tux1.beaverton.ibm.com> <20100819021441.GM2109@tux1.beaverton.ibm.com> <20100823183119.GA28105@tux1.beaverton.ibm.com> <20100923232527.GB25624@tux1.beaverton.ibm.com>
To: djwong@us.ibm.com
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-23, at 17:25, Darrick J. Wong wrote:
> To try to find an explanation, I started looking for connections between fsync delay values and average flush times.  I noticed that the setups with low (< 8ms) flush times exhibit better performance when fsync coordination is not attempted, and the setups with higher flush times exhibit better performance when fsync coordination happens.  This also is no surprise, as it seems perfectly reasonable that the more time consuming a flush is, the more desirous it is to spend a little time coordinating those flushes across CPUs.
> 
> I think a reasonable next step would be to alter this patch so that ext4_sync_file always measures the duration of the flushes that it issues, but only enable the coordination steps if it detects the flushes taking more than about 8ms.  One thing I don't know for sure is whether 8ms is a result of 2*HZ (currently set to 250) or if 8ms is a hardware property.

Note that the JBD/JBD2 code will already dynamically adjust the journal flush interval based on the delay seen when writing the journal commit block.  This was done to allow aggregating sync journal operations for slow devices, and allowing fast (no delay) sync on fast devices.  See jbd2_journal_stop() for details.

I think the best approach is to just depend on the journal to do this sync aggregation, if at all possible, otherwise use the same mechanism in ext3/4 for fsync operations that do not involve the journal (e.g. nojournal mode, data sync in writeback mode, etc).

Using any fixed threshold is the wrong approach, IMHO.

Cheers, Andreas





