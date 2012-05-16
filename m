Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2EPPXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:23:44 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33015 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab2EPPXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:23:41 -0400
MIME-Version: 1.0
In-Reply-To: <CACLa4psYWecSy9sRuV2Nf9BPU0xspjJF-ZD63biqv6erUYKyGQ@mail.gmail.com>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
 <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
 <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
 <1337112446.20904.50.camel@falcor> <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
 <20120516004251.GO22082@ZenIV.linux.org.uk> <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <CA+55aFy1qQkGXAr=0Zqk=qJeGTpfMOVC2=rdRWzQ1qsUZ5P0_g@mail.gmail.com>
 <alpine.LRH.2.02.1205162135320.10697@tundra.namei.org> <1337175731.2492.4.camel@localhost>
 <1337176336.3522.5.camel@falcor> <CACLa4psYWecSy9sRuV2Nf9BPU0xspjJF-ZD63biqv6erUYKyGQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 May 2012 08:23:19 -0700
X-Google-Sender-Auth: 8ZNzzhZ-gjvTcvOM0UApfjLMSG4
Message-ID: <CA+55aFyUnwjvS=WGOPxns8F1Ar=pYC3-4XFac41dZ14FFmdEUQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Eric Paris <eparis@parisplace.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 7:06 AM, Eric Paris <eparis@parisplace.org> wrote:
>
> But it would be flat wrong to put it there.  True historically we did
> things differently, but this patch is right given Linus is doing it a
> different way.

Indeed. As Eric points out, I'm forcing the address capability checks
on everybody, so defaulting to them is actively the wrong thing to do.

I think the NULL pointer games are from back when we inlined the
security hooks into the code directly, rather than have out-of-line
helper functions. At that point, the code expansion overhead of
loading the pointer, checking it for NULL, and then calling it was
quite noticeable.

But we uninlined them in 2007 (commit 20510f2f4e2d: "security: Convert
LSM into a static interface"), so I think the "set to default so that
you can do an unconditional jump" is not all that useful any more.

Of course, if all security models do export the fn, not having the
conditional is still useful. But defaulting to the capability one is
not in this case, since we will call the capability version later
anyway. So it should be defaulted to something that just returns 0.

                 Linus
