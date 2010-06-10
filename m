Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab0FJMJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:09:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57130 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980Ab0FJMJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:09:51 -0400
Message-ID: <4C10D600.60209@oracle.com>
Date: Thu, 10 Jun 2010 20:09:36 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Tao Ma <tao.ma@oracle.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Joel Becker <joel.becker@oracle.com>,
       mfasheh@suse.com
Subject: Re: [PATCH v3] ocfs2: Let ocfs2_setattr use new truncate sequence.
References: <20100610044234.GD26335@laptop> <1276146485-9346-1-git-send-email-tao.ma@oracle.com> <20100610082711.GA2173@lst.de> <20100610084707.GG30672@mail.oracle.com>
In-Reply-To: <20100610084707.GG30672@mail.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C10D604.0055:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Becker wrote:
> On Thu, Jun 10, 2010 at 10:27:11AM +0200, Christoph Hellwig wrote:
>   
>> You just leave the duplicate inode_newsize_ok in, but still have
>> one as part of inode_change_ok.  See the previous thread - we'll
>> need to move inode_change_ok to under the cluster locks, both
>> for the truncate and non-truncate case.
>>     
>
> 	Is your concern that the u/gid checks may be against stale ids?
>   
So I think we should have one inode_change_ok before the cluster lock 
and another after the cluster lock.
The first one will save us a lot of cluster lock effort if the user pass 
us the wrong arguments while the later
one will test again with the refreshed inode info.

Regards,
Tao
>   
>>> +		truncate_setsize(inode, attr->ia_size);
>>>       
>> But any reason this isn't done inside the
>>
>>         if (size_change && attr->ia_size != inode->i_size) {
>>
>> conditional above?  You'll never get size and uid/gid changes in the
>> same request, so there won't be any change in behaviour.
>>     
>
> 	I think the code exists as-is so that the i_size update only
> happens after the quota transfer has been approved.  Jan added the quota
> bits in this location.
> 	I can't see a standard posix op that changes size and ids at the
> same time.  I think we just add BUG_ON expressions that ensure such a
> behavior, right?
>
> Joel
>
>   

