Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1L1HmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 02:42:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57687 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1L1HmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 02:42:20 -0500
Date: Wed, 28 Dec 2011 11:42:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111228074214.GC27266@moon>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.661126615@openvz.org>
 <20111227152344.c8c140d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111227152344.c8c140d3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 03:23:44PM -0800, Andrew Morton wrote:
> On Fri, 23 Dec 2011 16:47:42 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > The routine XORs the given pointer with a random value
> > producing an ID (32 or 64 bit, depending on the arch).
> > 
> > Since it's a valuable information -- only CAP_SYS_ADMIN
> > is allowed to obtain it.
> > 
> >  - Tejun worried about the single poison value was a weak side -
> >    leaking one makes all the IDs vulnerable. To address this
> >    several poison values - one per object type - are introduced.
> >    They are stored in a plain array.
> >  - Pekka proposed to initialized poison values in the late_initcall callback
> >  - ... and move the code to mm/util.c
> 
> I'm trying to remember what this is all about, and I don't want to have
> to remember all the discussion from last time this came up!
> 
> Please, do cover all this in the changelogs: tell us what the code is
> all for and try to capture the design decisions thus far.  It's a
> useful reminder for current reviewers and is very valuable for new
> reviewers.
> 

Actually, not much was changed here, but indeed I've missed some changelong
snippets, sorry, will update next time. In short -- if to export these values
to unprivilege users we're to use strong encryption with some expansion of
the former pointers, and even more -- since kernel pointers do cover not
that big space (espec in case of x86-32) one could prehash all possible values
and if (for some reason) the cookie vector become known to an attacker, the
plain encryption would not work, but require some additional security
protection. Ie, none of scheme such as sha1(pointer ^ cookie) will be
enough.

So as a first step I thought root-only access should be better until more
clever scheme would be developed. Actually there is an option to simply
inject counters into kernel structures which we compare (ie vm, files and etc),
but it increase kernel memory consumption too much.

> The root-only restriction sounds like a pretty bad one.  I suspect it
> really isn't that bad but again, the changelog should discuss the pros
> and cons here.
> 
> A thought: if all we're trying to do here is to check for the sameness
> of objects, can we push the comparison into the kernel so we don't have
> this exporting-sensitive-info problem at all?  Just return a boolean to
> userspace?
> 
> Something like
> 
> int sys_pid_fields_equal(pid_t pid1, pid_t pid2, enum pid_field field_id);
> 
> ?
> 
> For /proc/pid/fdinfo/* userspace can open /proc/pid1/fdinfo/0 and
> /proc/pid2/fdinfo/0 and call sys_are_these_files_the_same(fd1, fd2, ...).
> 
> Perhaps sys_pid_fields_equal() can use sys_are_these_files_the_same()
> as well, if we can think up a way of passing it two fds to represent
> the two pids.
> 
> Have a think about it ;)
> 

Good idea! Maybe we could simply extend prctl then?
And thanks a lot for feedback, Andrew!

	Cyrill
