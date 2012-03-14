Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525Ab2CNVEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:04:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55943 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761135Ab2CNVEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:04:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120314205809.GJ23916@ZenIV.linux.org.uk>
References: <1331758710-16400-1-git-send-email-levinsasha928@gmail.com>
 <20120314201048.GI23916@ZenIV.linux.org.uk> <20120314205809.GJ23916@ZenIV.linux.org.uk>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 14 Mar 2012 23:03:43 +0200
Message-ID: <CA+1xoqcvXsx1vpAB7Jg-dWGVaadbF4sC3Cr2s5itHfdiPFQerA@mail.gmail.com>
Subject: Re: [PATCH] vfs namespace: Don't assume mount namespace has valid root
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 10:58 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Mar 14, 2012 at 08:10:48PM +0000, Al Viro wrote:
>> On Wed, Mar 14, 2012 at 04:58:30PM -0400, Sasha Levin wrote:
>> > This patch fixes the assumption that a mnt namespace will always have a valid
>> > root object.
>>
>> It's not an assumption, it's an invariant that should hold unless you have
>> run into a bug somewhere.
>>
>> Instances of struct mnt_namespace should *all* come from alloc_mnt_ns().
>> There are only two callers - dup_mnt_namespace() and create_mnt_ns().
>> The latter will assign non-NULL vfsmount to ->root or die NULL pointer
>> dereference in
>>                 mnt->mnt_ns = new_ns;
>> The former will either assign non-NULL to ->root or kfree() mnt_namespace
>> before anyone can see it.
>>
>> And nothing should modify ->root after that assignment for as long as
>> the instance of struct mnt_namespace is allocated.
>>
>> Mind explaining how have you managed to get mnt_namespace with NULL ->root
>> passed to dup_mnt_ns()?
>
> As the matter of fact, all of the above is easily verified; very few places
> see the internals of struct mnt_namespace (defined in fs/mount.h, included
> only in fs/dcache.c, fs/fhandle.c, fs/namei.c,
> fs/notify/{fanotify/fanotify_user.c,fsnotify.c,vfsmount_mark.c},
> and fs/pnode.h, which is included by fs/namespace.c, fs/pnode.c and
> fs/proc_namespace.c).  Nothing else knows what size the damn thing is,
> nevermind the actual layout.
>
> The lifetime rules are also simple and easy to verify: it's a plain refcount.
> No direct manipulators, everything happens via get_mnt_ns()/put_mnt_ns().
> As far as the outside cares,
>        nsproxy->mnt_ns contributes to refcount; copy_mnt_ns() always
> returns a new reference, either to exisiting instance or to freshly allocated
> one.  put_mnt_ns() needs to be called on the other side...
>        opened /proc/*/{mounts,mountinfo,mountstats} contributes to refcount
> for as long as it's opened.
>
> This is it; we actually end up acquiring one reference too many to initial
> mnt_namespace, but that's not going to cause such effect.
>
> The structure containing struct vfsmount has a pointer to struct mnt_namespace
> in it.  That one is protected by namespace_sem, does *not* contribute to
> refcount and is cleared when vfsmount (OK, struct mount containing it)
> gets removed from namespace's ->list and set when it gets placed there.
> Anything still on mnt_ns->list will get kicked out of there by umount_tree()
> call from put_mnt_ns(), so those references can't outlive the instance
> they point to.
>
> And that's all pointers to mnt_namespace that ever exist, aside of function
> arguments and local variables.  I'm not saying that I couldn't have possibly
> fucked it up, but from rereading that code it doesn't look like we could
> end up with dangling pointers to already freed instances...

I'm trying to find the exact chain of events leading it it at the
moment, but it reproduces rather easily - so if you have any ideas on
figuring it out I'm happy to try anything.
