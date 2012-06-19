Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab2FSF1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:27:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab2FSF1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:27:46 -0400
Message-ID: <4FE00DBF.7080405@suse.com>
Date: Tue, 19 Jun 2012 10:57:27 +0530
From: Suresh Jayaraman <sjayaraman@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Justin Lecher <jlec@gentoo.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-cachefs@redhat.com
Subject: Re: [PATCH] [RESEND] fs: cachefiles: Add support for large files
 in filesystem caching
References: <4FD5844D.4010900@suse.com> <20120618160408.8d0dd792.akpm@linux-foundation.org>
In-Reply-To: <20120618160408.8d0dd792.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 04:34 AM, Andrew Morton wrote:
>> From: Justin Lecher <jlec@gentoo.org>
>>
>> Support the caching of large files.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=31182
>>
>> Signed-off-by: Justin Lecher <jlec@gentoo.org>
>> Tested-by: Suresh Jayaraman <sjayaraman@suse.com>
>> ---
>>  fs/cachefiles/rdwr.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
>> index 0e3c092..d136686 100644
>> --- a/fs/cachefiles/rdwr.c
>> +++ b/fs/cachefiles/rdwr.c
>> @@ -919,7 +919,7 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
>>  	dget(object->backer);
>>  	mntget(cache->mnt);
>>  	file = dentry_open(object->backer, cache->mnt, O_RDWR,
>> -			   cache->cache_cred);
>> +			   (O_RDWR | O_LARGEFILE), cache->cache_cred);
> 
> Doesn't compile.

Oops, my bad. While refreshing the original patch against the latest
kernel, I seemed to have introduced an extra argument while attempting
to limit the characters to 80. Extremely sorry about that.

> How extensively was this change tested?  Please describe the testing
> which was performed?
> 

The original patch was tested by mounting a NFS share with fscache
option enabled, do a md5sum on a nfs file larger than 2GB and ensure
that the file is getting cached by fscache (watch cache size growing)
on x86_64. 

Please find below the fixed one.


From: Justin Lecher <jlec@gentoo.org>
Subject: [PATCH] fs: cachefiles: Add support for large files in filesystem caching

Support the caching of large files.

https://bugzilla.kernel.org/show_bug.cgi?id=31182

Tested by mounting a NFS share with fscache option enabled, do a
md5sum on a nfs file larger than 2GB and ensure that the file is getting
cached by fscache (watch cache size growing) on x86_64.

Signed-off-by: Justin Lecher <jlec@gentoo.org>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.com>
Tested-by: Suresh Jayaraman <sjayaraman@suse.com>
Cc: David Howells <dhowells@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/rdwr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 0e3c092..cc7ef95 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -918,7 +918,7 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
 	 * own time */
 	dget(object->backer);
 	mntget(cache->mnt);
-	file = dentry_open(object->backer, cache->mnt, O_RDWR,
+	file = dentry_open(object->backer, cache->mnt, (O_RDWR | O_LARGEFILE),
 			   cache->cache_cred);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
