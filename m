Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab1IAAd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 20:33:28 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38648 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab1IAAdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 20:33:23 -0400
Subject: [PATCH v1 0/3] crc32c: Add faster algorithm and self-test code
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Theodore Tso <tytso@mit.edu>, David Miller <davem@davemloft.net>,
        "Darrick J. Wong" <djwong@us.ibm.com>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Bob Pearson <rpearson@systemfabricworks.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mingming Cao <cmm@us.ibm.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Date: Wed, 31 Aug 2011 17:33:17 -0700
Message-ID: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11090100-7282-0000-0000-00000107895F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patchset replaces the current crc32c software implementation, which uses a
slow per-byte lookup table algorithm, with a faster implementation that uses an
adaptation of the slice-by-8 algorithm that Bob Pearson has been pushing for
crc32.

The motivation for this patchset is that I am working on adding full metadata
checksumming to ext4[1].  As far as performance impact of adding checksumming
goes, I see nearly no change with a standard mail server ffsb simulation.  On a
test that involves only file creation and deletion and extent tree writes, I
see a drop of about 50 pcercent with the current kernel crc32c implementation;
this improves to a drop of about 20 percent with the enclosed crc32c code.

When metadata is usually a small fraction of total IO, this new implementation
doesn't help much because metadata is usually a small fraction of total IO.
However, when we are doing IO that is almost all metadata (such as rm -rf'ing a
tree), then this patch speeds up the operation substantially.

Please have a look at the patches, and please feel free to suggest any changes.
I will be at LPC next week if anyone wishes to discuss, debate, or protest.

Incidentally, given that iscsi, sctp, and btrfs also use crc32c, this patchset
should improve their speed as well.  I have not yet quantified that, however.

--D

[1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums

