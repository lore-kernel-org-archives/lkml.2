Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1LFWs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:48:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38323 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab1LFWsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:48:23 -0500
Message-ID: <4EDE9BAE.50003@canonical.com>
Date: Tue, 06 Dec 2011 14:48:14 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
References: <20111206154854.GH2203@ZenIV.linux.org.uk> <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com> <20111206205346.GK2203@ZenIV.linux.org.uk> <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com> <20111206214126.GL2203@ZenIV.linux.org.uk>
In-Reply-To: <20111206214126.GL2203@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 01:41 PM, Al Viro wrote:
> On Tue, Dec 06, 2011 at 01:07:56PM -0800, Linus Torvalds wrote:
>> On Tue, Dec 6, 2011 at 12:53 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>>
>>> The trouble is, might very well stop *NOT* at the global root. ?Consider
>>> a race with umount -l; we have no way to tell "it had been outside of
>>> chroot jail" from "it had walked up to the place where ->mnt_parent had
>>> been already reset, sorry, no idea what it was".
>>
>> Sure, but you made that case return NULL already as part of the "no
>> bastard" case, didn't you?
>>
>> That part of the patch looked fine.
>>
>> It was just the extra convolutions around 'bastard' that seemed to be
>> over-designed, and made for just a single use that seems very
>> peripheral anyway.
>>
>> Apart from AppArmor, afaik nobody even really cared where they ended
>> up, and even AppArmor really didn't want to know - it just had this
>> totally crazy special case about "/sys".
> 
> It's not /sys, actually, it's implicit /proc/sys/something from sysctl() ;-/
> 
> Hell knows.  Frankly, the whole "let's build a pathname and decide basing
> on it" thing had been insane from the very beginning.  For many reasons,
> starting with "pathname in which namespace?" and continuing through "who said
> that it still means what it used to at the moment of operation" to "what
> if it's not a part of any namespace anymore/had never been in one".
> 
> Hey, it wasn't me who insisted that pathname-based stuff made any sense
> whatsoever...  But "path to the nearest thing that has no ancestor now"
> is _meaningless_ if we know nothing about that ancestor.  Cases include
> 	* that ancestor is the root of our namespace.
> 	* that ancestor is a solitary vfsmount we'd started in, never had
> been mounted in any namespace (e.g. procfs internal vfsmount, etc.)
> 	* that ancestor is a random vfsmount in a subtree that had been
> hit by umount -l, just as we'd been looking at it.  Might be its root,
> might be equal to path->mnt, might be something in between.
> 	* cases 1 and 3 in another process' namespace
> 
> In case 3 and analogs the path we'd obtained is pure junk, so I can agree
> with "let's just return NULL on those".  The trouble is, how do you tell
> (3) from (2)?  And do we want (1)-not-our-namespace to be distinguished
> from (1)-our-namespace?

You don't, and the chroot case of walking back to the namespace while sort
of possible isn't something I like either.  This whole mess with bastard
comes about because apparmor is supposed to deny access to the disconnected
paths, so it needs to know where it stopped so it can disconnect the path
that __d_path so helpfully attaches to /.  As I said early its insane to
mediate off of disconnected paths, and it can only be done via a previous
labeling.

The path value we get in these disconnected path cases is used for logging
to help the user figuring out why/where the access was denied.  Having
this information when building policy his helpful, but isn't critical as
it can only be used as a guide.

The current labeling in apparmor is crude and needs to be updated/replaced,
It is the only way to correctly handle fs namespaces.  As I offered before
we can break the one case that is currently problematic, until we can get
our labeling in order.

It would be nice to still be able to get a path back, in the cases where
the path isn't connected to root so we can log it but if we have to we can
live without it.

