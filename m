Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031Ab1IKDx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 23:53:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64691 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1IKDx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 23:53:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAG1a4rttHKgp=nAjQ=7zUu=bURq9x7DdhL2fTAZKimicpfdYsw@mail.gmail.com>
References: <CAG1a4ruG8bL9j01RgSXuK2w9FV0izp8vdoQMLEZzc=qZfCNpzA@mail.gmail.com>
 <1315285921.46647.YahooMailClassic@web29519.mail.ird.yahoo.com> <CAG1a4rttHKgp=nAjQ=7zUu=bURq9x7DdhL2fTAZKimicpfdYsw@mail.gmail.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Sat, 10 Sep 2011 23:52:55 -0400
Message-ID: <CAG1a4rt5wLihR-ZkUD78WRbHk39xWP0ypJzMe4K5G1O-k12-MQ@mail.gmail.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@tuxera.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 11:09 AM, Pavel Ivanov <paivanof@gmail.com> wrote:
>>> diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
>>> index c106ca2..5458be4 100644
>>> --- a/fs/hfsplus/super.c
>>> +++ b/fs/hfsplus/super.c
>>> @@ -345,6 +345,8 @@ static int hfsplus_fill_super(struct
>>> super_block
>>> *sb, void *data, int silent)
>>>      struct qstr str;
>>>      struct nls_table *nls = NULL;
>>>      int err;
>>> +    unsigned check_blksz_bits;
>>> +    u64 check_num_blocks;
>>>
>>>      err = -EINVAL;
>>>      sbi = kzalloc(sizeof(*sbi),
>>> GFP_KERNEL);
>>> @@ -399,10 +401,15 @@ static int hfsplus_fill_super(struct
>>> super_block
>>> *sb, void *data, int silent)
>>>      if (!sbi->rsrc_clump_blocks)
>>>
>>> sbi->rsrc_clump_blocks = 1;
>>>
>>> -    err =
>>> generic_check_addressable(sbi->alloc_blksz_shift,
>>> -
>>>
>>> sbi->total_blocks);
>>> +    check_blksz_bits =
>>> sbi->alloc_blksz_shift;
>>> +    check_num_blocks =
>>> sbi->total_blocks;
>>> +    if (sbi->fs_shift != 0) {
>>> +        check_num_blocks
>>> <<= sbi->fs_shift;
>>> +        check_blksz_bits -=
>>> sbi->fs_shift;
>>> +    }
>>> +    err =
>>> generic_check_addressable(check_blksz_bits,
>>> check_num_blocks);
>>>      if (err) {
>>>         printk(KERN_ERR "hfs:
>>> filesystem size too large.\n");
>>>          goto out_free_vhdr;
>>
>> This is a bit ugly - what it does is massage the two values taking into account of sbi->fs_shift to pass check_addressable() . I think either check_addressable should be extended, or this be abstracted out say, to check_hfs_addressable() (with __inline__ if desired) to be cleaner.
>
> Agreed. It was more of a quick hack to prove the correctness of such
> change direction. I'll think how to do it better.

Hin-Tak,

How about the following patch?


Subject: [PATCH] hfsplus: Allow to mount filesystem with block size
greater than PAGE_SIZE

Commit c6d5f5fa (hfsplus: lift the 2TB size limit) added call to
generic_check_addressable() but used the system's internal block size
which can be larger than PAGE_SIZE and will cause
generic_check_addressable() to return -EINVAL in this case. This
results in impossibility to mount file systems with such block sizes.
To fix it we have to use block size understandable by
generic_check_addressable() and adjust number of blocks accordingly.

Signed-off-by: Pavel Ivanov <paivanof@gmail.com>
Cc: <stable@kernel.org>
---

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index c106ca2..26ac5a5 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -399,8 +399,17 @@ static int hfsplus_fill_super(struct super_block
*sb, void *data, int silent)
 	if (!sbi->rsrc_clump_blocks)
 		sbi->rsrc_clump_blocks = 1;

-	err = generic_check_addressable(sbi->alloc_blksz_shift,
-					sbi->total_blocks);
+	/*
+	 * Check that filesystem data can be addressed by sector_t. Obvious way
+	 * to do that is to call generic_check_addressable with alloc_blksz_shift
+	 * and total_blocks as parameters. But alloc_blksz_shift can be greater
+	 * than PAGE_SIZE_SHIFT and in this case it won't be accepted by
+	 * generic_check_addressable. s_blocksize_bits will always be accepted
+	 * and difference between it and alloc_blksz_shift will be always in
+	 * fs_shift.
+	 */
+	err = generic_check_addressable(sb->s_blocksize_bits,
+			(u64)sbi->total_blocks << sbi->fs_shift);
 	if (err) {
 		printk(KERN_ERR "hfs: filesystem size too large.\n");
 		goto out_free_vhdr;
--
