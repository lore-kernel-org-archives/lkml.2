Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0FJFHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:07:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19119 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0FJFHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:07:11 -0400
Message-ID: <4C1072D3.4020109@oracle.com>
Date: Thu, 10 Jun 2010 13:06:27 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joel Becker <joel.becker@oracle.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] ocfs2: Let ocfs2_setattr use new truncate sequence.
References: <1276141986-9200-1-git-send-email-tao.ma@oracle.com> <20100610044234.GD26335@laptop>
In-Reply-To: <20100610044234.GD26335@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C1072F5.00D6:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On 06/10/2010 12:42 PM, Nick Piggin wrote:
> On Thu, Jun 10, 2010 at 11:53:06AM +0800, Tao Ma wrote:
>> Let ocfs2 use the new truncate sequence. The changes include:
>> 1. Remove the extra check for inode_newsize_ok since Christoph
>>     has moved it into inode_change_ok. So we will check it at the
>>     beginning of ocfs2_setattr.
>
> So this deals with our questions regarding check of i_size outside
> the inode cluster lock? (see fsdevel discussion)
oh, I forget about this. yes, we should have cluster lock and shouldn't 
remove this check.
>
>
>> 2. Use truncate_setsize directly since we don't implement our
>>     own ->truncate and what we need is "update i_size and
>>     truncate_pagecache" which truncate_setsize now does.
>> 3. For direct write, ocfs2 actually don't allow write to pass
>>     i_size(see ocfs2_prepare_inode_for_write), so we don't have
>>     a chance to increase i_size. So remove the bogus check.
>>
>> Cc: Joel Becker<joel.becker@oracle.com>
>> Cc: Christoph Hellwig<hch@lst.de>
>> Cc: Nick Piggin<npiggin@suse.de>
>> Signed-off-by: Tao Ma<tao.ma@oracle.com>
>> ---
>>   fs/ocfs2/file.c |   34 +++++-----------------------------
>>   1 files changed, 5 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 1fb0985..764fffb 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -983,10 +983,6 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>>   	}
>>
>>   	if (size_change&&  attr->ia_size != i_size_read(inode)) {
>> -		status = inode_newsize_ok(inode, attr->ia_size);
>> -		if (status)
>> -			goto bail_unlock;
>> -
>>   		if (i_size_read(inode)>  attr->ia_size) {
>
> While you're here, you should be able to use inode->i_size if you're
> under i_mutex, no?
ok, will change it and the correpsonding part in truncate_setsize.

Regards,
Tao
