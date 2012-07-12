Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab2GLNNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:13:50 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58826 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab2GLNNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:13:48 -0400
X-Greylist: delayed 26093 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2012 09:13:48 EDT
X-AuditID: 0ac90646-9aac7ba000003485-78-4ffecd8aa98c
X-AuditID: 0ac90646-9aac7ba000003485-78-4ffecd8aa98c
Message-ID: <4FFECD6F.5070308@hitachi.com>
Date: Thu, 12 Jul 2012 22:13:19 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 5/5] fuse: add documentation of sysfs parameter to
 limit maximum fuse request size
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp> <20120705105115.17812.93681.stgit@ltc137.sdl.hitachi.co.jp> <4FF6DFFE.10203@landley.net>
In-Reply-To: <4FF6DFFE.10203@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

Thank you for your comments.


(2012/07/06 21:54), Rob Landley wrote:
> On 07/05/2012 05:51 AM, Mitsuo Hayasaka wrote:
>> Add an explantion about the sysfs parameter to the limit
>> maximum read/write request size.
>>
>> Signed-off-by: Mitsuo Hayasaka<mitsuo.hayasaka.hu@hitachi.com>
>> Cc: Rob Landley<rob@landley.net>
>> Cc: Miklos Szeredi<miklos@szeredi.hu>
>> ---
>>
>>   Documentation/filesystems/fuse.txt |   17 ++++++++++++++++-
>>   1 files changed, 16 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/filesystems/fuse.txt b/Documentation/filesystems/fuse.txt
>> index 13af4a4..e6ffba3 100644
>> --- a/Documentation/filesystems/fuse.txt
>> +++ b/Documentation/filesystems/fuse.txt
>> @@ -108,13 +108,28 @@ Mount options
>>
>>     With this option the maximum size of read operations can be set.
>>     The default is infinite.  Note that the size of read requests is
>> -  limited anyway to 32 pages (which is 128kbyte on i386).
>> +  limited to 32 pages (which is 128kbyte on i386) if direct_io
>> +  option is not specified. When direct_io option is specified,
>> +  the request size is limited to max_pages_per_req sysfs parameter.
>
> "Note that the maximum size of read requests defaults to 32 pages (128k
> on i386), use max_pages_per_req to change this default."
>
> And then describe max_page_per_req sufficiently thoroughly below, all in
> one place.

OK, I will revise it.

>
> (By the way, has anybody actually tested it with a single page as the
> limit? Does that work?)


This patch series enables the maximum request size to change to arbitrary
number from 32 to 256, and cannot set it to less than 32 pages.

>
>>   'blksize=N'
>>
>>     Set the block size for the filesystem.  The default is 512.  This
>>     option is only valid for 'fuseblk' type mounts.
>>
>> +Sysfs parameter
>> +~~~~~~~~~~~~~~~
>> +
>> +The sysfs parameter max_pages_per_req limits the maximum page size per
>> +FUSE request.
>
> No, it limits the maximum size of a data request and the units are
> decimal number of pages. It doesn't change the size of memory pages in
> the system.

You are right. I will revise it.


>
> Also, your first hunk implies this setting only takes effect if they
> mounted with "-o direct_io", is that true?


The request size increases using max_pages_per_req for read operation w/
direct_io, and write operation w/ and w/o direct_io. But it is not changed
for read operation w/o direct_io. So, it is true if only focusing on read
operation.


>
>> +	/sys/fs/fuse/max_pages_per_req
>> +
>> +The default is 32 pages. It can be changed from 32 to 256 pages, which
>> +may improve the read/write throughput optimizing it. This change is
>> +effective per mount. Therefore, the re-mounting of FUSE filesystem
>> +is required after changing it.
>
> I'd say "Changing it to 256 pages may improve read/write throguhput on
> systems with enough memory. Existing FUSE mounts must be remounted for
> this change to take effect."
>
> I.E. don't imply 32 and 256 are the only options unless they are. (Is
> there some requirement that it be a power of 2, or just a good idea?)


Here, I wanted to imply that the max_paegs_per_req can be changed to
arbitrary number from 32 to 256. I will revise it since this explanation
is misleading.

Also, there is no requirement that it be a power of 2 although it is a
good idea if only focusing on kmalloc(). One of the reasons to introduce
the max_pages_per_req sysfs parameter is to let the libfuse get the
current maximum request size and change the MIN_BUFSIZE limitation
according to it to avoid an waste of memory in userspace.


>
> And per-mount sounds like you're setting it for a specific mount point,
> so if I have three mounts there would be three entries under
> /sys/fs/fuse, which does not seem to be the case. (Which is odd, because
> you'd think there would be an "-o max_pages_per_req=128" that _would_
> set this per-mount if the value actually used is cached in the
> superblock, but I'm not seeing one...)


The max_pages_per_req is a system limitation controlled by the administrator.
The actual number of allocated pages per request can be changed using
max_read/max_write mount options below this system limitation.

I will revise and resubmit this patch series soon.

Thanks,

>
> Rob
