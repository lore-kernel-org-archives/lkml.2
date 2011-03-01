Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1CAA2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:28:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143Ab1CAA2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:28:43 -0500
Date: Mon, 28 Feb 2011 16:28:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, dhowells@redhat.com,
        oleg@mail.hallyn.com, dlezcano@mail.hallyn.com,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 01/10] Add a user_namespace as creator/owner of
 uts_namespace
Message-Id: <20110228162830.35a051a8.akpm@linux-foundation.org>
In-Reply-To: <20110224150150.GA8262@mail.hallyn.com>
References: <20110224150150.GA8262@mail.hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 15:01:51 +0000
"Serge E. Hallyn" <serge@hallyn.com> wrote:

> Cc: oleg@mail.hallyn.com, dlezcano@mail.hallyn.com

I don't think those addresses do what you think they do.

> copy_process() handles CLONE_NEWUSER before the rest of the
> namespaces.  So in the case of clone(CLONE_NEWUSER|CLONE_NEWUTS)
> the new uts namespace will have the new user namespace as its
> owner.  That is what we want, since we want root in that new
> userns to be able to have privilege over it.
> 

Well this sucks.  Anyone who is reading this patch series really won't
have a clue what any of it is for.  There's no context provided.

A useful way of thinking about this is to ask yourself "what will Linus
think when this stuff hits his inbox".  If the answer is "he'll say
wtf" then we're doing it wrong.

Sigh.

I shall (again) paste in the below text, which I snarfed from the wiki.
Please check that it is complete, accurate and adequate.  If not,
please send along replacement text.


: The expected course of development for user namespaces targeted
: capabilities is laid out at https://wiki.ubuntu.com/UserNamespace.
: 
: Goals:
: 
: - Make it safe for an unprivileged user to unshare namespaces.  They
:   will be privileged with respect to the new namespace, but this should
:   only include resources which the unprivileged user already owns.
: 
: - Provide separate limits and accounting for userids in different
:   namespaces.  
: 
: Status:
: 
:   Currently (as of 2.6.38) you can clone with the CLONE_NEWUSER flag to
:   get a new user namespace if you have the CAP_SYS_ADMIN, CAP_SETUID, and
:   CAP_SETGID capabilities.  What this gets you is a whole new set of
:   userids, meaning that user 500 will have a different 'struct user' in
:   your namespace than in other namespaces.  So any accounting information
:   stored in struct user will be unique to your namespace.
: 
:   However, throughout the kernel there are checks which
: 
:   - simply check for a capability.  Since root in a child namespace
:     has all capabilities, this means that a child namespace is not
:     constrained.
: 
:   - simply compare uid1 == uid2.  Since these are the integer uids,
:     uid 500 in namespace 1 will be said to be equal to uid 500 in
:     namespace 2.  
: 
:   As a result, the lxc implementation at lxc.sf.net does not use user
:   namespaces.  This is actually helpful because it leaves us free to
:   develop user namespaces in such a way that, for some time, user
:   namespaces may be unuseful.  
: 
: 
: Bugs aside, this patchset is supposed to not at all affect systems which
: are not actively using user namespaces, and only restrict what tasks in
: child user namespace can do.  They begin to limit privilege to a user
: namespace, so that root in a container cannot kill or ptrace tasks in the
: parent user namespace, and can only get world access rights to files. 
: Since all files currently belong to the initila user namespace, that means
: that child user namespaces can only get world access rights to *all*
: files.  While this temporarily makes user namespaces bad for system
: containers, it starts to get useful for some sandboxing.
: 
: I've run the 'runltplite.sh' with and without this patchset and found no
: difference.

