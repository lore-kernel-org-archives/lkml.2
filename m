Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1DDJio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:38:44 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62148 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1DDJin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=oW/IomyPohcuqJJ2xjBHORUw0G7s2fxz0nWiwO8qsktobqNxAFLu/9Oo44rV9upcjt
         5oyfq7f3eI/sk+L1IQhWLo82DKpY4F34G+2ZGB+CLD12er6g+AVnJVKJ35hFCThjE7t+
         LilYQHtO/2GPBg/tXE7BQqmn4cWDkCsYlrv0I=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1301900656.2760.6.camel@localhost>
References: <1301874939-2630-1-git-send-email-sedat.dilek@gmail.com>
	<1301900656.2760.6.camel@localhost>
Date: Mon, 4 Apr 2011 11:38:42 +0200
Message-ID: <BANLkTi=WTWa4yj+ysta8jiHs9r4MX5Gf_g@mail.gmail.com>
Subject: Re: [PATCH] ubifs: Use empty_iops and empty_fops consistently
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 9:04 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Mon, 2011-04-04 at 01:55 +0200, Sedat Dilek wrote:
>> Follow the nomenclature as we did for empty_aops and rename
>> to empty_iops and empty_fops.
>>
>> This patch is on top of linux-2.6-block.git#for-linus.
>>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>> CC: Artem Bityutskiy <dedekind1@gmail.com>
>> CC: Adrian Hunter <adrian.hunter@nokia.com>
>> CC: Jens Axboe <jaxboe@fusionio.com>
>> ---
>>  fs/ubifs/xattr.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
>> index 3299f46..16f19f5 100644
>> --- a/fs/ubifs/xattr.c
>> +++ b/fs/ubifs/xattr.c
>> @@ -80,8 +80,8 @@ enum {
>>       SECURITY_XATTR,
>>  };
>>
>> -static const struct inode_operations none_inode_operations;
>> -static const struct file_operations none_file_operations;
>> +static const struct inode_operations empty_iops;
>> +static const struct file_operations empty_fops;
>>
>>  /**
>>   * create_xattr - create an extended attribute.
>> @@ -131,8 +131,8 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
>>
>>       /* Re-define all operations to be "nothing" */
>>       inode->i_mapping->a_ops = &empty_aops;
>> -     inode->i_op = &none_inode_operations;
>> -     inode->i_fop = &none_file_operations;
>> +     inode->i_op = &empty_iops;
>> +     inode->i_fop = &empty_fops;
>>
>>       inode->i_flags |= S_SYNC | S_NOATIME | S_NOCMTIME | S_NOQUOTA;
>>       ui = ubifs_inode(inode);
>
> Well, this re-naming looks strange for me. I could understand if you had
> a global exported empty_*ops which you could share and shrink the .data
> size a bit. But this re-naming just looks useles, if you take into
> account the breakage and the men-hours we spend to write e-mails to this
> thread - really did not worth it. Or I miss something?
>

Sorry for having flooded your inbox.
The last days might be the first time I noticed UBIFS at all and
looked into its code.
I did so because I fell over a build-error when pulling
linux-block-2.6.git#for-linus into linux-next (next-20110404).

The current code in linux-next (next-20110404) looks in the meantime like this:

[ fs/ubifs/xattr.c ]
...
static const struct inode_operations none_inode_operations;
static const struct file_operations none_file_operations;
...
        /* Re-define all operations to be "nothing" */
        inode->i_mapping->a_ops = &empty_aops;
        inode->i_op = &none_inode_operations;
        inode->i_fop = &none_file_operations;
...

First seeing this was strange to me, so you try via code-grep-ping to
understand the correlations in the complete fs-tree.
So, let's do some code-grep:

$ egrep 'empty_aops|mpty_iops|empty_fops' -r fs/ include/linux/
fs/ubifs/xattr.c:       inode->i_mapping->a_ops = &empty_aops;
fs/open.c:      static const struct file_operations empty_fops = {};
fs/open.c:              f->f_op = &empty_fops;
fs/inode.c:const struct address_space_operations empty_aops = {
fs/inode.c:EXPORT_SYMBOL(empty_aops);
fs/inode.c:     static const struct inode_operations empty_iops;
fs/inode.c:     static const struct file_operations empty_fops;
fs/inode.c:     inode->i_op = &empty_iops;
fs/inode.c:     inode->i_fop = &empty_fops;
fs/inode.c:     mapping->a_ops = &empty_aops;
fs/nilfs2/page.c:       mapping->a_ops = &empty_aops;
include/linux/fs.h:extern const struct address_space_operations empty_aops;

Hope you can understand now, why I did this.

It's up to you how you name your variables, function-names etc.

- Sedat -
