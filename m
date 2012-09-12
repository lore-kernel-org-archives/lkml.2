Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab2ILREH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:04:07 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38019 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab2ILRD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:58 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
References: <1347020137.2223.13.camel@iscandar.digidescorp.com>
	<87oblfpmnb.fsf@devron.myhome.or.jp>
	<87k3w3ph8d.fsf@devron.myhome.or.jp>
	<CAKYAXd-k4yVV3h8k0kcFMsyGnOVckYRjXi8fkZrLtjuWVi7Eqw@mail.gmail.com>
	<87har6kmfx.fsf@devron.myhome.or.jp>
	<CAKYAXd-ZNmCbHqmFX=YXti7XprhD_Hgvmnd=TnKPVoFc88Sc4A@mail.gmail.com>
	<87oblc4u6f.fsf@devron.myhome.or.jp>
	<CAKYAXd-gO5Pw=0unjB=YQJhu6W=g7VpZYnmHXkve-k8_4VjpgA@mail.gmail.com>
	<871ui84l4l.fsf@devron.myhome.or.jp>
	<CAKYAXd89CKZa9nV3pBiFgcpGsYzX1-iCB+UJ8bBvst88GnB4mg@mail.gmail.com>
	<20120912143227.GE3009@fieldses.org>
Date: Thu, 13 Sep 2012 02:03:51 +0900
In-Reply-To: <20120912143227.GE3009@fieldses.org> (J. Bruce Fields's message
	of "Wed, 12 Sep 2012 10:32:27 -0400")
Message-ID: <87vcfjfa14.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

>> > Supposing, the server/client state is after cold boot, and client try to
>> > rename at first without any cache on client/server.
>> >
>> > Even if this state, does the server return ESTALE? If it doesn't return
>> > ESTALE, I can't understand why it is really unfixable.
>> Hi OGAWA.
>> Server will not return ESTALE in this case. because the client does
>> not have any information for files yet.
>
> It does if the client mounted before the server rebooted.  NFS is
> designed so that servers can reboot without causing clients to fail.
> (Applications will just see a delay during the reboot.)
>
> It probably isn't possible to this work in the case of fat.
>
> But from fat's point of view there probably isn't much difference
> between a filehandle lookup after a reboot and a filehandle lookup after
> the inode's gone from cache.

This is talking about to retry by client side, not server side solution.
What happens if client retry after got ESTALE? (Yes, this would not be
the solution for all NFS clients. But, I guess this solution can be for
linux NFS client.)

> I really don't see what you can do to help here.  Won't anything that
> allows looking up an uncached inode by filehandle also risk finding the
> wrong file?

On other view (as server side solution), we are thinking there is
possible to make the stable filehandle on FAT if we disabled some
operations (e.g. rename(), unlink()) which change inode location in FAT.

Yes, it would be stable, but supporting limited operations.

This is server side solution, and we comparing it with client solution.

>> > If it returns ESTALE, why does it return? I'm assuming the previous code
>> > path is the cached FH path.
>> The main point for observation is the file handle-which is used for
>> all the NFS operation.
>> So for all the NFS operation(read/write....) which makes use of the
>> NFS file handle in between if there is a change in inode number
>> It will result in ESTALE.
>> Changing inode number on rename happened at NFS server by inode cache
>> eviction with memory pressure.
>> 
>> lookupcache is used at NFS client to reduce number of LOOKUP operations.
>> But , we can still get ESTALE if inode number at NFS Server change
>> after LOOKUP, although lookupcache is disable.
>> 
>> LOOKUP return NFS FH->[inode number changed at NFS Server] ->
>> But we still use old NFS FH returned from LOOKUP for any file
>> operation(write,read,etc..)
>> -> ESTALE will be returned.

Yes.  And I'm expecting as client side solution,

-> ESTALE will be returned -> discard old FH -> restart from LOOKUP ->
make cached inode -> use returned new FH.

Yeah, I know this is unstable (there is no perfect solution for now),
but if this works, this doesn't limit any operations.

We would want to compare client solution (-mm) and server solution
(stable ino). Or I'd like to know which my knowledges/understanding are
wrong here.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
