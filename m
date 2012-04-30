Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2D3Qvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:51:48 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:21159 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab2D3Qvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:51:45 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=W+ZrOcpwHTeQLvZQ9vbIxXRdvbK5p6H2/T6SuQCN924= c=1 sm=1
 a=Q2d4rd1hsggA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=xOeV8rxhm4bFzxoxZSQ2Ew==:17 a=w7lf1zp0WW3jMFVdsc8A:9
 a=W9obRk76AyFXLpzkdKEA:7 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH 15/23] jbd2: Change disk layout for metadata checksumming
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20120430155341.GC6938@tux1.beaverton.ibm.com>
Date: Mon, 30 Apr 2012 10:51:43 -0600
Cc: "Ted Ts'o" <tytso@mit.edu>, Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <29C40967-4A9E-4D32-B356-A5D15E23EB38@dilger.ca>
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com> <20120306204941.1663.56283.stgit@elm3b70.beaverton.ibm.com> <20120428141933.GB29481@thunk.org> <20120430155341.GC6938@tux1.beaverton.ibm.com>
To: djwong@us.ibm.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-30, at 9:53 AM, djwong wrote:
> As for putting half the checksum into the upper 16 bits of the flags
> field -- is journal space at such a premium that we need to overload
> the field and reduce the strength of the checksum?  Enabling journal
> checksums on a 4k block filesystem causes tags_per_block to decrease
> from 512 to 341 on a 32bit journal and from 341 to 256 on a 64bit
> journal.  Do transactions typically have that many blocks?  I didn't
> think most transactions had 1-2MB of dirty data.

I think on a busy filesystem there can be many thousands of blocks in
a single transaction.  We run Lustre with 400MB journals, and under
metadata-intensive workloads we can hit the 100MB transaction size
limit easily.  However, this doesn't mean there are 25k blocks in
each transaction, since most of these blocks are reserved for the
worst case, but not used.

As for the impact of reducing the number of tags in each block, for a
4096-block transaction this would currently mean 8 32-bit tag blocks,
and it would grow to 12 or 13, which isn't significant in the end.

My suggestion was mostly to avoid problems with the disk format change.
If this can be handled in another manner, AND it doesn't break journal
recovery on older kernels/e2fsprogs, then I'm OK with the cleaner
approach.  Please ensure that this is tested.

Cheers, Andreas





