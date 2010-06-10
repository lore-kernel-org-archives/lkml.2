Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab0FJIpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 04:45:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36596 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab0FJIpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 04:45:14 -0400
Message-ID: <4C10A5F9.3050507@oracle.com>
Date: Thu, 10 Jun 2010 16:44:41 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joel Becker <joel.becker@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH v3] ocfs2: Let ocfs2_setattr use new truncate sequence.
References: <20100610044234.GD26335@laptop> <1276146485-9346-1-git-send-email-tao.ma@oracle.com> <20100610082711.GA2173@lst.de>
In-Reply-To: <20100610082711.GA2173@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4C10A60B.0052:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/10/2010 04:27 PM, Christoph Hellwig wrote:
> On Thu, Jun 10, 2010 at 01:08:05PM +0800, Tao Ma wrote:
>> Let ocfs2 use the new truncate sequence. The changes include:
>> 1. Use truncate_setsize directly since we don't implement our
>>     own ->truncate and what we need is "update i_size and
>>     truncate_pagecache" which truncate_setsize now does.
>> 2. For direct write, ocfs2 actually don't allow write to pass
>>     i_size(see ocfs2_prepare_inode_for_write), so we don't have
>>     a chance to increase i_size. So remove the bogus check.
>
> You just leave the duplicate inode_newsize_ok in, but still have
> one as part of inode_change_ok.  See the previous thread - we'll
> need to move inode_change_ok to under the cluster locks, both
> for the truncate and non-truncate case.
uh, I just don't change the original inode_change_ok, and maybe you are 
right that we should check all these under cluster lock. But it looks as 
if it is written like this intentionally.

Mark and Joel, do you have any option that why we write like this or it 
is a bug?
>
>>   	/*
>> +	 * Since all the work for a size change has been done above.
>> +	 * Call truncate_setsize directly to change size and truncate
>> +	 * pagecache.
>>   	 */
>>   	if ((attr->ia_valid&  ATTR_SIZE)&&
>> +	    attr->ia_size != inode->i_size)
>
> this could be on one line now.
ok, I will regenerate the patch after I get the feedback from Mark and Joel.
>
>> +		truncate_setsize(inode, attr->ia_size);
>
> But any reason this isn't done inside the
>
>          if (size_change&&  attr->ia_size != inode->i_size) {
>
> conditional above?  You'll never get size and uid/gid changes in the
> same request, so there won't be any change in behaviour.
Because we want the inode change in a transaction. In the above 
condition, we do truncate/extend in a transaction. And after it is done, 
we start a new transaction that update the inode info.

Regards,
Tao
