Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967181Ab2EPAiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:38:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45880 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480Ab2EPAiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:38:08 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
 <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
 <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
 <1337112446.20904.50.camel@falcor> <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 May 2012 17:37:46 -0700
X-Google-Sender-Auth: tP2qzdDy7JRc0FFVMOkpLio5QDo
Message-ID: <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So here's a COMPLETELY UNTESTED patch that does what I think might be
the right thing.

To simplify the calling convention, I'm just making the security layer
compute the whole "requested protections" vs "actual protections". It
might be a good idea to have a helper function to do that, of course,
but that sounds like an independent cleanup (the mprotect() code also
has this same logic, and does it incompletely).

It does change some things, like say that "->mmap_file()" is only ever
called for actual files, not for anonymous mappings. It doesn't seem
to be sensible to have a security model for anonymous mappings -
there's nothing there to really target. Whatever.

It also makes security_mmap_addr() always call the standard capability
check (*after* having called the security model version), so the
security model no longer needs to care. All of them did seem to do so.

And again: this is totally untested. I'm not committing this, it's
more of a "hey, I tried it out, might as well send it out for
comments" thing.

                      Linus
