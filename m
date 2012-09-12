Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab2ILONC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:13:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55648 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758990Ab2ILOM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:12:58 -0400
MIME-Version: 1.0
In-Reply-To: <871ui84l4l.fsf@devron.myhome.or.jp>
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
	<20120904161747.GJ23464@ZenIV.linux.org.uk>
	<CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
	<87harc34d9.fsf@devron.myhome.or.jp>
	<CAKYAXd-8aztDe1QiFT=NSQX8J+h_FM+cAWwo+Q+fUQHpNGTctw@mail.gmail.com>
	<87y5knz6l5.fsf@devron.myhome.or.jp>
	<CAKYAXd_mxq26bhRYd-YM9OBjYMO12TD4wHxm6PqHBLjgGFHaZg@mail.gmail.com>
	<CAKYAXd-QtSYy4SQErVTXrxcv=YhFzhOm3PKpj=HoZKmpAG7vGQ@mail.gmail.com>
	<1347020137.2223.13.camel@iscandar.digidescorp.com>
	<87oblfpmnb.fsf@devron.myhome.or.jp>
	<87k3w3ph8d.fsf@devron.myhome.or.jp>
	<CAKYAXd-k4yVV3h8k0kcFMsyGnOVckYRjXi8fkZrLtjuWVi7Eqw@mail.gmail.com>
	<87har6kmfx.fsf@devron.myhome.or.jp>
	<CAKYAXd-ZNmCbHqmFX=YXti7XprhD_Hgvmnd=TnKPVoFc88Sc4A@mail.gmail.com>
	<87oblc4u6f.fsf@devron.myhome.or.jp>
	<CAKYAXd-gO5Pw=0unjB=YQJhu6W=g7VpZYnmHXkve-k8_4VjpgA@mail.gmail.com>
	<871ui84l4l.fsf@devron.myhome.or.jp>
Date: Wed, 12 Sep 2012 23:12:56 +0900
Message-ID: <CAKYAXd89CKZa9nV3pBiFgcpGsYzX1-iCB+UJ8bBvst88GnB4mg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        bfields@fieldses.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/12 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> I think that it is unfixable because we can not know i_pos of inode
>>>> changed by rename.
>>>> And even though we know it, there is no rebuild inode routine in -mm.
>>>> And It even can not fix in our patches.
>>>
>>>>> And are you tried https://lkml.org/lkml/2012/6/29/381 patches? It sounds
>>>>> like to improve performance by enabling lookupcache.
>>>> We checked this patches when facing estale issue in -mm.
>>>> But It is no use, these patches just retry system call one more when
>>>> estale error.
>>>
>>> What happens if client retried from lookup() after -ESTALE? (client NFS
>>> doesn't have the name of entry anymore?)
>> Need to rebuild inode routine because inode cache is already evicted on Server.
>>>
>>> I'm assuming the retry means - it restarts from building the NFS file
>>> handle. I might be just wrong here though.
>> As I remember, just retry in VFS of NFS client..I heard this patch is
>> needed for
>> a very specific set of circumstances where an entry goes stale once
>> between the lookup and the actual operation(s).
>> It is not related with current issues(inode cache eviction on server).
>
> Supposing, the server/client state is after cold boot, and client try to
> rename at first without any cache on client/server.
>
> Even if this state, does the server return ESTALE? If it doesn't return
> ESTALE, I can't understand why it is really unfixable.
Hi OGAWA.
Server will not return ESTALE in this case. because the client does
not have any information for files yet.
I mean NFS client does not have any old NFS FH(containing old inode
number) for this.

>
> If it returns ESTALE, why does it return? I'm assuming the previous code
> path is the cached FH path.
The main point for observation is the file handle-which is used for
all the NFS operation.
So for all the NFS operation(read/write....) which makes use of the
NFS file handle in between if there is a change in inode number
It will result in ESTALE.
Changing inode number on rename happened at NFS server by inode cache
eviction with memory pressure.

lookupcache is used at NFS client to reduce number of LOOKUP operations.
But , we can still get ESTALE if inode number at NFS Server change
after LOOKUP, although lookupcache is disable.

LOOKUP return NFS FH->[inode number changed at NFS Server] ->
But we still use old NFS FH returned from LOOKUP for any file
operation(write,read,etc..)
-> ESTALE will be returned.

Thanks!
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
