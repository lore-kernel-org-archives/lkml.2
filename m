Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0EIKQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 06:16:48 -0400
Received: from daytona.panasas.com ([67.152.220.89]:54140 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751777Ab0EIKQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 06:16:46 -0400
Message-ID: <4BE68B86.50707@panasas.com>
Date: Sun, 09 May 2010 13:16:38 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Benny Halevy <bhalevy@panasas.com>,
       Avishay Traeger <avishay@gmail.com>, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] exofs: confusion between kmap() and kmap_atomic() api
References: <20100507090532.GD27064@bicker>
In-Reply-To: <20100507090532.GD27064@bicker>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 May 2010 10:16:40.0080 (UTC) FILETIME=[B7122900:01CAEF60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 12:05 PM, Dan Carpenter wrote:
> For kmap_atomic() we call kunmap_atomic() on the returned pointer.
> That's different from kmap() and kunmap() and so it's easy to get them
> backwards.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Thank you Dan, I'll push it ASAP. 

Looks like a bad bug. So this is actually a leak, right? kunmap_atomic
would detect the bad pointer and do nothing?

Thanks again
Boaz

> diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
> index 4cfab1c..d91e9d8 100644
> --- a/fs/exofs/dir.c
> +++ b/fs/exofs/dir.c
> @@ -608,7 +608,7 @@ int exofs_make_empty(struct inode *inode, struct inode *parent)
>  	de->inode_no = cpu_to_le64(parent->i_ino);
>  	memcpy(de->name, PARENT_DIR, sizeof(PARENT_DIR));
>  	exofs_set_de_type(de, inode);
> -	kunmap_atomic(page, KM_USER0);
> +	kunmap_atomic(kaddr, KM_USER0);
>  	err = exofs_commit_chunk(page, 0, chunk_size);
>  fail:
>  	page_cache_release(page);

