Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1LFXM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 18:12:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42366 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab1LFXM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 18:12:28 -0500
Message-ID: <4EDEA152.90804@canonical.com>
Date: Tue, 06 Dec 2011 15:12:18 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
References: <20111206154854.GH2203@ZenIV.linux.org.uk> <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com> <20111206205346.GK2203@ZenIV.linux.org.uk> <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com> <4EDE94DC.8010106@canonical.com> <20111206224100.GM2203@ZenIV.linux.org.uk>
In-Reply-To: <20111206224100.GM2203@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 02:41 PM, Al Viro wrote:
> On Tue, Dec 06, 2011 at 02:19:08PM -0800, John Johansen wrote:
>> On 12/06/2011 01:07 PM, Linus Torvalds wrote:
>>> On Tue, Dec 6, 2011 at 12:53 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>>>
>>>> The trouble is, might very well stop *NOT* at the global root.  Consider
>>>> a race with umount -l; we have no way to tell "it had been outside of
>>>> chroot jail" from "it had walked up to the place where ->mnt_parent had
>>>> been already reset, sorry, no idea what it was".
>>>
>>> Sure, but you made that case return NULL already as part of the "no
>>> bastard" case, didn't you?
>>>
>>> That part of the patch looked fine.
>>>
>>> It was just the extra convolutions around 'bastard' that seemed to be
>>> over-designed, and made for just a single use that seems very
>>> peripheral anyway.
>>>
>> it is, and the plan is to not need the bastard even.  What apparmor should
>> be doing is lazy labeling the live objects, and anything that is disconnected
>> is evaluated based on the previous labeling.
> 
> I still don't understand how you deal with objects seen by processes in
> different namespaces.  Please, explain lazy labeling in details...
> 
Right now we leverage the file->cred, which is very crude, and fails in
a lot of situations forcing us, to do a revalidation (file and permission
lookup), and then return an error based on that.  At the moment it can
thought of more as caching based on the original cred that was used opening
the file, if the tasks cred matches it gets to avoid the path lookup.

What should be is when a task goes to access an object, it checks the label,
if it doesn't pass the check, it falls backs to doing a path lookup, if that
succeeds the label is updated, if it fails access is denied.  And yes this
does necessitate the labeling being on something that can be updated.

I have been working on a better, much longer writeup, but its still needs a
lot of work.

> You do realize that there's no hope whatsoever for prohibiting access
> to struct file opened in parent's namespace and already written into
> there, right?
> 
so with the caveat that I may have misunderstood what you wrote, yes.

>> This will also remove its
>> use of passing root = { NULL, NULL } to __d_path.
> 
> One word: tomoyo...  You are not the only weird one.  They want an absolute
> pathname and don't care about races with umount.  Whatever it's relative
> to, the thing just goes ahead and plays with itse^Wthe string it got.  As
> long as they are not dereferencing pointers to free objects, I Don't Want To
> Know(tm).
> 
>> Right now we could drop the bastard parameter and passing root = { NULL, NULL }
> 
> OK, please tell me what do you need from __d_path().  Suppose it has missed
> the supplied root; what do you want to know about the place it had stopped
> in?  If we don't do extra arguments, we are limited by this:
> 	* some condition is checked by __d_path(); if it's satisfied,
> pointer to relative pathname (based hell-knows-where) is returned as
> usual; we *can't* tell that from normal "reached root, here's your
> pathname" case.
> 	* if it isn't satisfied, we return NULL.  No relative pathname
> to look at, etc.
> 
> Unless you are OK with what __d_path(path, root, NULL, buf, buflen) is doing
> with this patch, we'd need to split it; seq_path_root()/show_mountinfo()
> requirements leave no wiggling space for case root->mnt != NULL,
> bastard == NULL.

What we want to know is if we missed the supplied root, so that we don't
mediate off of that path.  And it would be nice to get a partial path for
the purposes of logging, so that there is some guidance on how to update
policy.

