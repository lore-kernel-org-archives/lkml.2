Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab1GDQAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:00:49 -0400
Received: from acsinet14.oracle.com ([141.146.126.236]:41989 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1GDQAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:00:46 -0400
X-Greylist: delayed 5119 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jul 2011 12:00:46 EDT
Subject: Re: [PATCH] nfs: Don't deref potentially NULL pointer returned by strsep
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <alpine.LNX.2.00.1107041102001.24059@swampdragon.chaosbits.net>
Date: Mon, 4 Jul 2011 10:34:48 -0400
Cc: linux-nfs@vger.kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-kernel@vger.kernel.org, Gero Kuhlmann <gero@gkminix.han.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <EEDBC51B-F721-451D-9156-0B5B28240015@oracle.com>
References: <alpine.LNX.2.00.1107030938430.16316@swampdragon.chaosbits.net> <14B45086-2D98-4706-B1FE-7EBB8E777EEF@oracle.com> <alpine.LNX.2.00.1107041102001.24059@swampdragon.chaosbits.net>
To: Jesper Juhl <jj@chaosbits.net>
X-Mailer: Apple Mail (2.1084)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4E11CF94.0089:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 4, 2011, at 5:04 AM, Jesper Juhl wrote:

> On Sun, 3 Jul 2011, Chuck Lever wrote:
> 
>> 
>> On Jul 3, 2011, at 3:40 AM, Jesper Juhl wrote:
>> 
>>> In fs/nfs/nfsroot.c:root_nfs_parse_options() we call strsep(), which
>>> may return NULL, but we do not test the return value before
>>> dereferencing the pointer.
>>> 
>>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>>> ---
>>> fs/nfs/nfsroot.c |    2 ++
>>> 1 files changed, 2 insertions(+), 0 deletions(-)
>>> 
>>> Compile tested only.
>>> 
>>> diff --git a/fs/nfs/nfsroot.c b/fs/nfs/nfsroot.c
>>> index c4744e1..b6ac860 100644
>>> --- a/fs/nfs/nfsroot.c
>>> +++ b/fs/nfs/nfsroot.c
>>> @@ -191,6 +191,8 @@ static int __init root_nfs_parse_options(char *incoming, char *exppath,
>>> 	 * Set the NFS remote path
>>> 	 */
>>> 	p = strsep(&incoming, ",");
>>> +	if (!p)
>>> +		return -1;
>> 
>> strsep() may return NULL only if the value of "incoming" is NULL.  But 
>> callers ensure that "incoming" always contains the address of a fixed 
>> buffer.  Thus if strsep() returns NULL here there is some kind of 
>> programming error; it's not the result of invalid input.
>> 
>> Do you have a reproducible test case to make this fail?
>> 
> Nope. I simply spotted the unchecked strsep() call and thought that it 
> would be better to be defensive and check it in case callers change in the 
> future and a bug creeps in that causes a NULL incoming to be passed. 
> Perhaps a BUG_ON(!incoming) would be better - or perhaps just forget about 
> it.

While I personally prefer an explicit assertion in cases like this one, the community preference is to avoid cluttering the code with BUG_ONs, since the code would crash anyway in that case.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



