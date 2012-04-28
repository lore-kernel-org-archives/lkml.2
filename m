Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2D1XQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 19:16:24 -0400
Received: from mail130c7.megamailservers.com ([69.49.98.230]:47644 "EHLO
	mail130c7.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068Ab2D1XQX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 19:16:23 -0400
X-Greylist: delayed 1061 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2012 19:16:23 EDT
X-POP-User: travis.1x1architecture.ca
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com> <20120306204941.1663.56283.stgit@elm3b70.beaverton.ibm.com> <20120428141933.GB29481@thunk.org>
In-Reply-To: <20120428141933.GB29481@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <FCF93AD5-A078-4855-BC8D-B7B046884411@dilger.ca>
Content-Transfer-Encoding: 8BIT
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Coly Li <colyli@gmail.com>
X-Mailer: iPhone Mail (9B176)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 15/23] jbd2: Change disk layout for metadata checksumming
Date: Sat, 28 Apr 2012 16:58:12 -0600
To: "Ted Ts'o" <tytso@mit.edu>
X-CSC: 0
X-CHA: v=1.1 cv=jegz8rrpTsCmfIP3oxsmQwLmgXLlG4mytwnW3LPhSlA= c=1 sm=1
		a=Q2d4rd1hsggA:10 a=kj9zAlcOel0A:10 a=0SDMJWAZksigYED0kvO7Mg==:17
		a=spYHe48e4jy_JBXyZ18A:9 a=CjuIK1q_8ugA:10 a=aPpGz_mIUJdH1GJJ:21
		a=qGMMUv7bjHlKJMOP:21 a=0SDMJWAZksigYED0kvO7Mg==:117
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A02020A.4F9C7609.0067,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-28, at 8:19, Ted Ts'o <tytso@mit.edu> wrote:

> On Tue, Mar 06, 2012 at 12:49:41PM -0800, Darrick J. Wong wrote:
>> @@ -177,11 +189,17 @@ typedef struct journal_block_tag_s
>>    __be32        t_blocknr;    /* The on-disk block number */
>>    __be32        t_flags;    /* See below */
>>    __be32        t_blocknr_high; /* most-significant high 32bits. */
>> +    __be32        t_checksum;    /* crc32c(uuid+seq+block) */
>> } journal_block_tag_t;
>> 
>> #define JBD2_TAG_SIZE32 (offsetof(journal_block_tag_t, t_blocknr_high))
>> #define JBD2_TAG_SIZE64 (sizeof(journal_block_tag_t))
> 
> There's a problem with this patch here --- we are changing the size of
> journal_block_tag_t, which is an on-disk data structure.  So for
> 64-bit journals, this represents a format change.  This means that if
> you have a 64-bit file system that needs to have its journal
> recovered, if the journal was written with an older kernel, and then
> we try to recover it with a new kernel, things won't be good.
> Similarly, for e2fsck's recovery code, it's not going to be able to
> recover 64-bit file systems using current coding, since this patch
> series changes the size of JBD2_TAG_SIZE64.
> 
> What we need to do is something like this:
> 
> #define JBD2_TAG_SIZE64 (offsetof(journal_block_tag_t, t_checksum))
> #define JBD2_TAG_SIZE_CSUM (sizeof(journal_block_tag_t))
> 
> And then change the code appropriately in e2fsprogs and in the kernel
> to use the correct tag size depending on the journal options.

I thought we originally discussed using the high 16 bits of the t_flags field to store the checksum?  This would avoid the need to change the disk format. 

Since there is still a whole transaction checksum, it isn't so critical that the per-block checksum be strong.

One idea is to do the crc32c for each block, then store the high 16 bits into t_flags, and checksum the full 32-bit per-block checksums to make the commit block checksum, to avoid having to do the block checksums twice. 

Cheers, Andreas