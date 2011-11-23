Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab1KWEbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 23:31:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab1KWEbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 23:31:05 -0500
Message-ID: <4ECC76F3.9050001@redhat.com>
Date: Wed, 23 Nov 2011 12:30:43 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [V2 PATCH] tmpfs: add fallocate support
References: <1321612791-4764-1-git-send-email-amwang@redhat.com> <20111122140630.9f37c907.akpm@linux-foundation.org>
In-Reply-To: <20111122140630.9f37c907.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月23日 06:06, Andrew Morton 写道:
> On Fri, 18 Nov 2011 18:39:50 +0800
> Cong Wang<amwang@redhat.com>  wrote:
>
>> It seems that systemd needs tmpfs to support fallocate,
>> see http://lkml.org/lkml/2011/10/20/275. This patch adds
>> fallocate support to tmpfs.
>>
>> As we already have shmem_truncate_range(), it is also easy
>> to add FALLOC_FL_PUNCH_HOLE support too.
>>
>>
>> ...
>>
>> +static long shmem_fallocate(struct file *file, int mode,
>> +				loff_t offset, loff_t len)
>> +{
>> +	struct inode *inode = file->f_path.dentry->d_inode;
>> +	pgoff_t start = offset>>  PAGE_CACHE_SHIFT;
>> +	pgoff_t end = DIV_ROUND_UP((offset + len), PAGE_CACHE_SIZE);
>> +	pgoff_t index = start;
>> +	loff_t i_size = i_size_read(inode);
>> +	struct page *page = NULL;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&inode->i_mutex);
>
> It would be saner and less racy-looking to read i_size _after_ taking
> i_mutex.
>
> And if you do that, there's no need to use i_size_read() - just a plain
> old
>
> 	i_size = inode->i_size;
>
> is OK.

Fair enough, I will fix that in V3.

Thanks, Andrew!
