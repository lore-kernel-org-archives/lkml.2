Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0HQNPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:15:02 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:61869 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab0HQNPA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=am1ek9Z3FXSAKzlQpAI/CrIDmrBZ+LBeonB1c/EbDfyVTr/9S/qIupKBsH2xB3sQib
         vHd4bTTKQv7frx2Gh5dvFmW4PNfC1/wpp6ZWBMHxhRmpsNxIfvgPSwxi6hOMGJC/TkbM
         j/uBAOwHL8RC9HZZ7zpODfTZnfJsxm4EIbguM=
MIME-Version: 1.0
In-Reply-To: <20100810033536.GA31363@ZenIV.linux.org.uk>
References: <20100810033536.GA31363@ZenIV.linux.org.uk>
Date: Tue, 17 Aug 2010 16:14:58 +0300
Message-ID: <AANLkTimh30b=Dfv41zQ9Q+rmkmVCP8X7oOtt6VQyw9ap@mail.gmail.com>
Subject: Re: [git pull] vfs series, part 1
From: Jouni Malinen <jkmalinen@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 6:35 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        Assorted work from the last cycle; among other things, there's
> a filesystem API change (->evict_inode() series), a lot of truncate
> rework stuff (mostly by Chris) and a bunch of fixes.

Linux 2.6.36-rc1 seemed to break my UML hostfs setup or well, make it
behave in very odd ways.. No matter what directory I'm trying to read
from hostfs in UML, the root directory seems to be returned. I have
hostfs mounted in UML into /mnt/host and "ls /mnt/host" and "ls
/mnt/host/etc" show the same directory. Actually, any unknown
directory like "/mnt/host/does-not-exist" shows the same root
directory.. Obviously something is going quite wrong in mapping the
path name to directory entry.

 Based on a quick git bisect, the main part of the issue seems to be
caused or at least triggered by a change in this set:

>      hostfs: fix races in dentry_name() and inode_name()

e9193059b1b3733695d5b80e667778311695aa73 is the first bad commit
commit e9193059b1b3733695d5b80e667778311695aa73
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Jun 6 23:16:34 2010 -0400

    hostfs: fix races in dentry_name() and inode_name()

    calculating size, then doing allocation, then filling the
    path is a Bad Idea(tm), since the ancestors can be renamed,
    leading to buffer overrun.

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

In addition, reverting just that commit allows hostfs to be used with
2.6.36-rc1. Though, there seems to be some additional issues with
symlinks, so there could be something else related to this change that
is actually causing the problems. The other issues result in memory
allocation failing when reading symlinks:

# ls /mnt/host/
ls: cannot read symbolic link /mnt/host/vmlinuz: Cannot allocate memory
ls: cannot read symbolic link /mnt/host/vmlinuz.old: Cannot allocate memory

(this is not only limited to ls; "ln -s p.patch a.patch; cat a.patch"
results in same from cat)

Other than that, hostfs seems to be working, though.

Any idea what caused this regression and how to fix it properly? I can
work around this by reverting the patch pointed out by git bisect, but
surely that is not the proper fix for the issues.

- Jouni
