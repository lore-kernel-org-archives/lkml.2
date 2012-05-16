Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab2EPBx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:53:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34794 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab2EPBxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:53:55 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
 <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
 <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
 <1337112446.20904.50.camel@falcor> <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
 <20120516004251.GO22082@ZenIV.linux.org.uk> <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 May 2012 18:53:33 -0700
X-Google-Sender-Auth: 57qpUwPxDpntApXqfp31kpV5iec
Message-ID: <CA+55aFy1qQkGXAr=0Zqk=qJeGTpfMOVC2=rdRWzQ1qsUZ5P0_g@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Eric Paris <eparis@parisplace.org>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 5:45 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Oops. Err.. I meant to do that. Right. To check that you're awake.
>
> Here.

Btw, a few notes:

 - this adds the new security_mmap_file() calls to the same places
that Mimi added the ima_file_mmap() call.

   HOWEVER. There are other callers that call do_mmap[_pgoff].
Notably, do_shmat(). IMA probably doesn't care, but other security
models might - even if the file in question there will be one just
allocated by the shm layer.

   So it does change semantics a bit, in that not only does the
->mmap_file() function no longer get called when 'file' is NULL, it
also doesn't get called with a couple of special files (the other one
I noticed was the i810 driver doing it's do_mmap() dance)

 - the fact that we don't call the security function for a NULL-file
mmap() is actually consistent with what do_brk() has always done (it
used to do "addr_only=1", now it obviously does just
security_mmap_addr() instead). So that part looks sane, and no
security model can possibly care.

 - I booted the patch. Not that I actually *tested* it any real way,
but at least it boots and doesn't seem to break anything obvious.

Hmm?

                  Linus
