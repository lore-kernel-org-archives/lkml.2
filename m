Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1LFWTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:19:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59691 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab1LFWTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:19:19 -0500
Message-ID: <4EDE94DC.8010106@canonical.com>
Date: Tue, 06 Dec 2011 14:19:08 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
References: <20111206154854.GH2203@ZenIV.linux.org.uk> <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com> <20111206205346.GK2203@ZenIV.linux.org.uk> <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
In-Reply-To: <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 01:07 PM, Linus Torvalds wrote:
> On Tue, Dec 6, 2011 at 12:53 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> The trouble is, might very well stop *NOT* at the global root.  Consider
>> a race with umount -l; we have no way to tell "it had been outside of
>> chroot jail" from "it had walked up to the place where ->mnt_parent had
>> been already reset, sorry, no idea what it was".
> 
> Sure, but you made that case return NULL already as part of the "no
> bastard" case, didn't you?
> 
> That part of the patch looked fine.
> 
> It was just the extra convolutions around 'bastard' that seemed to be
> over-designed, and made for just a single use that seems very
> peripheral anyway.
> 
it is, and the plan is to not need the bastard even.  What apparmor should
be doing is lazy labeling the live objects, and anything that is disconnected
is evaluated based on the previous labeling.  This will also remove its
use of passing root = { NULL, NULL } to __d_path.

> Apart from AppArmor, afaik nobody even really cared where they ended
> up, and even AppArmor really didn't want to know - it just had this
> totally crazy special case about "/sys".
> 

right it only cared about where it endup in the cases of reaching the fs->root
or own_mnt.  The sys case really is just broken, I started looking at it when
Al poked me and said wtf, and have been looking at ways to remove it.

Right now we could drop the bastard parameter and passing root = { NULL, NULL }
__d_path and only break in the case of some chroot situations, which is not the
standard use case anyways.  We are willing to drop support for this, and it can
be picked backup when the labeling patch is done.

