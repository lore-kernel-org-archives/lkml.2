Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab2IGG3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:29:31 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47082 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2IGG3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:29:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1209061255530.509@new-host-2>
References: <5040C11C.4060505@gmail.com>
	<alpine.LFD.2.00.1209061255530.509@new-host-2>
Date: Fri, 7 Sep 2012 08:29:28 +0200
Message-ID: <CANGUGtB9-DuypSnT0zobd9CK88SW8x=FGCnwaHZEDjtkJ33doQ@mail.gmail.com>
Subject: Re: [PATCH 00/21] drop vmtruncate
From: Marco Stornelli <marco.stornelli@gmail.com>
To: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/6 Lukáš Czerner <lczerner@redhat.com>:
> On Fri, 31 Aug 2012, Marco Stornelli wrote:
>
>> Date: Fri, 31 Aug 2012 15:50:20 +0200
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>> To: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org
>> Cc: Linux Kernel <linux-kernel@vger.kernel.org>
>> Subject: [PATCH 00/21] drop vmtruncate
>>
>> Hi all,
>>
>> with this patch series I try to clean the vmtruncate code. The theory of
>> operation:
>>
>> old               new
>> vmtruncate() =>   inode_newsize_ok+truncate_setsize+fs truncate
>>
>> Where vmtruncate was used without any error check, the code now is:
>>
>> if (inode_newsize_ok() == 0) {
>>       truncate_setsize();
>>       fs truncate();
>> }
>>
>> So, performance and semantic nothing change at all. I think that maybe in some
>> point we can skip inode_newsize_ok (where the error check of vmtruncate wasn't
>> used) but since there is a swap check in case of no-extension, maybe it's
>> better to avoid regressions. After this clean, of course, each fs can clean in
>> a deeply way.
>>
>> With these patches even the inode truncate callback is deleted.
>>
>> Any comments/feedback/bugs are welcome.
>
> Could you explain the reason behind this change a little bit more ?
> This does not make any sense to me since you're replacing
> vmtruncate() which does basically
>
> if (inode_newsize_ok() == 0) {
>         truncate_setsize();
>         fs truncate();
> }
>
> as you mentioned above by exactly the same thing but doing it within
> the file system. It does not seem like an improvement to me ... how
> is this a clean up ?
>
> Thanks!
> -Lukas
>

First of all we have one function less in our stack :) Vmtruncate (see
comments) is deprecated, so it's better to remove it completly. In
this way we can remove even the truncate call back in inode operations
(so save 4byte/8byte per struct for the pointer). The first goal of
this cleaning activity, however, is remove a "deprecated" function to
have a code much more readable. As I said, this patch series is only a
*first* cleanup, each fs can of course clean its code in a deeply way.
As you can see, the patch span over several fs, to be *safe* I
preferred to use a conservative approach. Where vmtruncate was called
without error check, as I said, maybe we can remove
inode_newsize_ok(), but since in this way we skip a check, I preferred
that approach. It seems that for NTFS and Raiserfs it's ok.

Marco

Marco
