Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab2EPPOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:14:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36173 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2EPPOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:14:21 -0400
MIME-Version: 1.0
In-Reply-To: <CACLa4pspOFx638fn6aDHpESVZrKmWCnrO999qoO+Mna4ccF_7g@mail.gmail.com>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
 <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
 <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
 <1337112446.20904.50.camel@falcor> <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com> <CACLa4pspOFx638fn6aDHpESVZrKmWCnrO999qoO+Mna4ccF_7g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 May 2012 08:13:59 -0700
X-Google-Sender-Auth: BN3XFSaDOPhaGzdp7g3suFcfUaA
Message-ID: <CA+55aFwNqGN7PYsFudUKdTZikUn=Sr1tHCim3jySUfPnM4neag@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Eric Paris <eparis@parisplace.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 7:13 AM, Eric Paris <eparis@parisplace.org> wrote:
>
> So we would have no checks for anonymous mappings?  We actually do
> have some controls around them today
>
> http://www.akkadia.org/drepper/selinux-mem.html
>
> It's mostly around W+X memory.  (or was W now X memory)

Ahh, ok. So I guess that won't work.

That said, I think do_brk() can already today be used to avoid those
checks, since it does a mmap with VM_DATA_DEFAULT_FLAGS, which
includes exec if the current personality includes READ_IMPLIES_EXEC -
which is trivial yo do.

I wonder if the rwx checks could be split up too - the access
protection from the *file* is really a separate issue from the access
protection of the *mapping*, if you see what I mean.. Then we could do
it at do_brk() time too.

                      Linus

>
> Admittedly with the growing prevalence of JiT stuff we are using those
> protections less and less and less....
>
> Not certain how happy some will be to see them completely disappear....
