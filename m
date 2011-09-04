Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1IDLmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 07:42:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:64501 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab1IDLmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 07:42:37 -0400
To: djwong@us.ibm.com
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, Sunil Mushran <sunil.mushran@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
	<CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
	<20110902182214.GC12086@tux1.beaverton.ibm.com>
Date: Sun, 04 Sep 2011 07:41:03 -0400
In-Reply-To: <20110902182214.GC12086@tux1.beaverton.ibm.com> (Darrick
	J. Wong's message of "Fri, 2 Sep 2011 11:22:14 -0700")
Message-ID: <yq1d3fgwn5c.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E636402.00C1:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <djwong@us.ibm.com> writes:

Darrick,

Darrick> Furthermore, the nice thing about the in-filesystem checksum is
Darrick> that we bake in other things like the FS UUID and the inode
Darrick> number, which gives you a somewhat better assurance that the
Darrick> data block belongs to the fs and the file that the code think
Darrick> it belongs to.

Yeah, I view DIF/DIX mostly as in-flight protection for writes. Whereas
FS metadata checksumming is great for problem detection at read time.

Another problem with using the DIF app tag to store filesystem metadata
is that many array vendors use it internally and thus only disk drives
are likely to provide the app tag space.


Darrick> The DIX interface allows for a 32-bit block number and a 16-bit
Darrick> application tag ... which is unfortunately small given 64-bit
Darrick> block numbers and 32-bit inode numbers.

I never understood the 32-bit ref tag. Seems silly to have a check that
wraps at the exact boundary where problems are most likely to occur.

I advocated for a DIF Type with 16-bit guard tag and 48-bit ref tag but
that never went anywhere. Too bad - would have been easy for the storage
vendors to implement.


Darrick> As a side note, the crc-t10dif implementation is quite slow --
Darrick> the hardware accelerated crc32c is 15x faster, and the sw
Darrick> implementation is usually 3-6x faster.  I suspect somebody will
Darrick> want to fix that before DIF becomes more widespread...

The CRC32C op on Nehalem and beyond is really, really fast. It's
essentially free except for pulling the data through the cache. So it's
not entirely fair to use that as baseline for a pure software
implementation. What is the faster sw implementation are you referring
to, btw.?

lib/crc-t10dif is a regular 256-entry table-based CRC implementation. It
is done pretty much like all our other software CRCs. I seem to recall
attempting a bigger table but that yielded worse real life results due
to cache pollution.

On Westmere and beyond it is possible to accelerate generic CRC
calculation using the PCLMULQDQ operation. There are many of our CRC
functions that could benefit from this. However, so far intel have not
been willing to contribute the relevant code to Linux.


Darrick> The good news is that if you're really worried about integrity,
Darrick> metadata_csum and DIF/DIX aren't mutually exclusive features.
Darrick> Rejecting corrupted write commands at write time seems like a
Darrick> useful feature. :)

Yup!

-- 
Martin K. Petersen	Oracle Linux Engineering
