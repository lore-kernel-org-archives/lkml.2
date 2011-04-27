Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1D0SkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:40:17 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60570 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1D0SkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=L3FgqoqMVLiSI+fy3iORmkX42LRu1eaFfqcGqwvpxKSUUY4n2cCH7RbobCHPq+M3An
         6ji2hw+PGhQ1WcXsMZE9t8DQx3JZw3RO/p6IxJS4b3ug9UhE5RMiXZpBnbmyumDxRrAH
         PpGggr4+qT4tJI0pmb+Ti8CCGHqRai4UK/JkI=
MIME-Version: 1.0
In-Reply-To: <20110427183308.GA16716@parisc-linux.org>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com> <20110427183308.GA16716@parisc-linux.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 27 Apr 2011 14:39:53 -0400
X-Google-Sender-Auth: KJxmay3xM1dJkSbFI7fCMiRyFS8
Message-ID: <BANLkTinPTPMWPN+JELtCZDjrVepLetX6FQ@mail.gmail.com>
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrea Righi <andrea@betterlinux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 14:33, Matthew Wilcox wrote:
> On Wed, Apr 27, 2011 at 08:13:47PM +0200, Andrea Righi wrote:
>> @@ -127,6 +128,12 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>>                       invalidate_mapping_pages(mapping, start_index,
>>                                               end_index);
>>               break;
>> +     case POSIX_FADV_DONTNEED_FS:
>> +             if (capable(CAP_SYS_ADMIN))
>> +                     drop_pagecache_sb(file->f_dentry->d_sb, NULL);
>> +             else
>> +                     ret = -EPERM;
>> +             break;
>>       default:
>>               ret = -EINVAL;
>>       }
>
> Mmm ... what if I open /dev/sdxyz and call fadvise() on it?  I think
> you end up flushing /dev's page cache entries, instead of the filesystem
> which is on /dev/sdxyz.

i was thinking of that, but was trying to come up with situations
where there might not have a node to work on.  fs's in a file go
through loop devs, dm/lvm have ones created, and flash fs's still have
a mtd block.  how about network based fs's ?  how you going to signal
dropping of pages for nfs or cifs or fuse ones ?
-mike
