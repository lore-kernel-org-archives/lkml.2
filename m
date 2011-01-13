Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab1AMLQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 06:16:34 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41674 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab1AMLQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 06:16:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FqWeeP1s0JP6wjWv1DTWB+GbaTPEvr739XDlx66UToDaykvmrQgvani6H48Jo5z4lY
         YKWGjAsIC870MPbHzrvs8aulagIp/znFy54cfyBS52hIgxkxPDZlZBAniFCGnOqBT/H5
         xHEUQq9zvSuJeNx9Ri4q25wIjpXqiwGjcuzY4=
MIME-Version: 1.0
In-Reply-To: <E1PdL3D-0003dx-EE@pomaz-ex.szeredi.hu>
References: <E1Pcd7R-0007XC-VO@pomaz-ex.szeredi.hu>
	<AANLkTik-=LqSHQ=7zDznx9oCJFViPpp406Yz7J5Z-quj@mail.gmail.com>
	<E1Pd1eC-0001hR-LW@pomaz-ex.szeredi.hu>
	<AANLkTikEStNgB58Q-797rQST3QW=maz9LiGFSC=A8kkc@mail.gmail.com>
	<E1PdL3D-0003dx-EE@pomaz-ex.szeredi.hu>
Date: Thu, 13 Jan 2011 22:16:31 +1100
Message-ID: <AANLkTi=He=Xy555NK5Nbe6gRdrdA+L=9Qct2di=QOWwj@mail.gmail.com>
Subject: Re: [PATCH] fuse: make fuse_permission() RCU aware
From: Nick Piggin <npiggin@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 10:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, 13 Jan 2011, Nick Piggin wrote:
>> >        inode = entry->d_inode;
>> >        if (inode && is_bad_inode(inode))
>> >                return 0;
>>
>> Now it can be the case that entry->d_inode is not stable -- it can
>> go away or even flip between inodes in the case of concurrent
>> unlink/creat activity. And you may be using a different inode than
>> the namei path walk is using!
>> This isn't as scary as it sounds actually, because any such changes
>> do get detected and the path walk restarted in that case.
>>
>> You might be OK becuse you do test for NULL (although it really
>> wants an ACCESS_ONCE() so it doesn't load a NULL or different
>> inodes, but that's quite theoretical).
>>
>> But this is a little unfriendly for filesystems, and I do want to impress
>> the rule to not touch ->d_parent or ->d_inode in rcu walk mode
>> (just to avoid any surprises).
>>
>> So what I have done in such cases is to update the API to provide
>> what the callers want. In this case, we could consider adding an
>> inode parameter to .d_revalidate, which callers can be sure matches
>> the inode used by vfs, and will not change.
>
> Yes, I think supplying an inode to ->d_revalidate() would be the right
> thing.

OK I'll work something up.


> I see that there's nd->inode, and it's documented in vfs.txt, but IMO
> we shouln'd be encouraging new uses of 'nd' inside filesystem
> callbacks, rather the opposite.  A 'flags' parameter too might make
> sense which, for the moment, would only have LOOKUP_RCU instead of all
> the lookup flags.

I have tried to avoid filesystems poking in nd (except for this case I
guess), so yes an inode * parameter should work.

Thanks,
Nick
