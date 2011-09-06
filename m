Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1IFPKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:10:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41853 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab1IFPKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:10:00 -0400
MIME-Version: 1.0
In-Reply-To: <1315285921.46647.YahooMailClassic@web29519.mail.ird.yahoo.com>
References: <CAG1a4ruG8bL9j01RgSXuK2w9FV0izp8vdoQMLEZzc=qZfCNpzA@mail.gmail.com>
 <1315285921.46647.YahooMailClassic@web29519.mail.ird.yahoo.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Tue, 6 Sep 2011 11:09:27 -0400
Message-ID: <CAG1a4rttHKgp=nAjQ=7zUu=bURq9x7DdhL2fTAZKimicpfdYsw@mail.gmail.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Christoph Hellwig <hch@tuxera.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 1:12 AM, Hin-Tak Leung <hintak_leung@yahoo.co.uk> wrote:
>> Anyway the following patch worked for me and I've got my
>> iPod mounted
>> and navigateable (although only in read-only mode because
>> it has
>> journaled filesystem).
>
> I worked on the netgear journalling patches a bit:
> http://htl10.users.sourceforge.net/patchsets/hfsplus_3.0_rfc/patches/
> But please *back up your data*, as well as reading my notes before trying them out:
> http://www.spinics.net/lists/linux-fsdevel/msg47684.html
> http://www.spinics.net/lists/linux-fsdevel/msg47734.html

I'd be happy to try them out and to help in testing/fixing/reviewing them.

>> diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
>> index c106ca2..5458be4 100644
>> --- a/fs/hfsplus/super.c
>> +++ b/fs/hfsplus/super.c
>> @@ -345,6 +345,8 @@ static int hfsplus_fill_super(struct
>> super_block
>> *sb, void *data, int silent)
>>      struct qstr str;
>>      struct nls_table *nls = NULL;
>>      int err;
>> +    unsigned check_blksz_bits;
>> +    u64 check_num_blocks;
>>
>>      err = -EINVAL;
>>      sbi = kzalloc(sizeof(*sbi),
>> GFP_KERNEL);
>> @@ -399,10 +401,15 @@ static int hfsplus_fill_super(struct
>> super_block
>> *sb, void *data, int silent)
>>      if (!sbi->rsrc_clump_blocks)
>>
>> sbi->rsrc_clump_blocks = 1;
>>
>> -    err =
>> generic_check_addressable(sbi->alloc_blksz_shift,
>> -
>>
>> sbi->total_blocks);
>> +    check_blksz_bits =
>> sbi->alloc_blksz_shift;
>> +    check_num_blocks =
>> sbi->total_blocks;
>> +    if (sbi->fs_shift != 0) {
>> +        check_num_blocks
>> <<= sbi->fs_shift;
>> +        check_blksz_bits -=
>> sbi->fs_shift;
>> +    }
>> +    err =
>> generic_check_addressable(check_blksz_bits,
>> check_num_blocks);
>>      if (err) {
>>         printk(KERN_ERR "hfs:
>> filesystem size too large.\n");
>>          goto out_free_vhdr;
>>
>>
>> I can format and submit both patches (plus a small cleanup
>> that I felt
>> is needed to be changed along the way). Tell me what you
>> think.
>
> This is a bit ugly - what it does is massage the two values taking into account of sbi->fs_shift to pass check_addressable() . I think either check_addressable should be extended, or this be abstracted out say, to check_hfs_addressable() (with __inline__ if desired) to be cleaner.

Agreed. It was more of a quick hack to prove the correctness of such
change direction. I'll think how to do it better.


Thank you,
Pavel
