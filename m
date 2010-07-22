Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188Ab0GVADW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:03:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55122 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120Ab0GVADU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ncwY/b2oBZ45LA0j3Tf2xAmKYcTnwHS5WIdJtb5lqGGCF5EY+d5Q/Jad3VBVCKV2AT
         VIlDVMRCDuFeUt7KxomxRLqReQyzZAcf7rPesyFpdUZYVLN9maeHMEXfgPI1Qq1a2wmc
         xhuWI4norJMbTkySTjas2MsxU+AeYUwwvIoqc=
MIME-Version: 1.0
In-Reply-To: <20100721174457.GE1215@atrey.karlin.mff.cuni.cz>
References: <201007122229025316610@gmail.com>
	<20100721174457.GE1215@atrey.karlin.mff.cuni.cz>
Date: Thu, 22 Jul 2010 08:03:18 +0800
Message-ID: <AANLkTikXSOHrIw0SVJMYqsQy1aG5sCXkvvOFU4XLDNGv@mail.gmail.com>
Subject: Re: [PATCH] check name_len before down_read xattr_sem and sb_read in 
	ext2_xattr_get
From: shenghui <crosslonelyover@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/22 Jan Kara <jack@suse.cz>:
>> Hi,
>>        I walked through ext2_xattr_get, and felt that we can
>> do some optimization on it. For name_len check, it's done
>> after down xattr_sem and sb_read, both of which are time
>> consuming operation compared with strlen:
>>          down_read(&EXT2_I(inode)->xattr_sem);
>>  ...
>>          bh = sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
>>  ...
>>          /* find named attribute */
>>          name_len = strlen(name);
>>
>>          error = -ERANGE;
>>          if (name_len > 255)
>>                  goto cleanup;
>>
>>        Most of the case, you'll get one valid block, but if the
>> name len > 255, then the xattr_sem down and sb_bread operation
>> can be seen as a waste of time. So I think we'd better do
>> name len check as early as possible.
>>        Following is my patch, and it's against 2.6.35-rc4.
>> Please check it.
>>
>> Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
>> ---
>>  fs/ext2/xattr.c |   12 +++++++-----
>>  1 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
>> index 7c39157..0b94d61 100644
>> --- a/fs/ext2/xattr.c
>> +++ b/fs/ext2/xattr.c
>> @@ -161,6 +161,13 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
>>
>>       if (name == NULL)
>>               return -EINVAL;
>> +
>> +     /* find named attribute */
>> +     name_len = strlen(name);
>> +     error = -ERANGE;
>> +     if (name_len > 255)
>> +             goto cleanup;
>  But you cannot go to cleanup here because you don't hold xattr_sem...
>

Sorry, I'm a little confused by your words.
The patch just checks name_len, and it
doesn't need xattr_sem.



-- 


Thanks and Best Regards,
shenghui
