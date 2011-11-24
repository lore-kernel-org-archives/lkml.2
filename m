Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab1KXS14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 13:27:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61528 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1KXS1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 13:27:55 -0500
MIME-Version: 1.0
In-Reply-To: <20111124074526.GA3652@boyd>
References: <20111123222555.GA1094@boyd> <CA+55aFyZvp=SsBG=SroMDLMEFGgazK1EM3b-Fejpgwf41+_e3w@mail.gmail.com>
 <20111124074526.GA3652@boyd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Nov 2011 10:27:33 -0800
X-Google-Sender-Auth: ulaFSlyJ98-xxWG1dRXrItJfPWo
Message-ID: <CA+55aFy2QWwvY17q_AVwVj9_g3DSLnUrEOD897Bu2_rQgVsv3w@mail.gmail.com>
Subject: Re: [GIT PULL] eCryptfs fixes for 3.2-rc3
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, ecryptfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:45 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
>
>> In general, I'd urge people to *not* use "->flush" at all as a
>> "correctness issue". It's useful to return EIO to "close()" and to be
>> *polite* (ie the return value of "flush()" will be returned to user
>> space at close time), but it really should be seen as a "we try to
>> flush now to try to give user space nice error reports where
>> possible", but it's important to understand that it's not the last
>> close, and if you rely on it for correctness, you're doing something
>> wrong. It's "release()" that is the "get rid of all your state now",
>> and is about correctness. "flush" is purely about being polite.
>
> But it *could* be the last close, so it seems that using flush() for
> politeness *and* release() for correctness is not an option.

You can certainly do both, there is nothing wrong with it.

Note that even if "flush()" returns an error, we *will* close the fd.
It is not going to abort the close or anything like that: it's just a
signal to the user that something is wrong.

For example, a filesystem like NFS may do delayed writes, so when you
do a "write()" system call, and the server diskspace is full, you may
not get the ENOSPC at "write()" time. You may get it at a subsequent
write(), or you may get it at close() time - because NFS does try to
write it synchronously at that time.  The user cannot *recover* from
the error (the file is closed and you don't know how much of it made
it), but a careful writer can check the error code of close() and at
least know to alert the user that something went wrong.

So there is nothing *wrong* with using "flush()", and it exists for a
reason: so that careful writers *can* be careful.

But when you do use flush(), you also need to be aware that most
writers aren't careful. Even if they don't use mmap(), they also don't
necessarily care about close(). And there are situations where
"flush()" is used as a "let's try to flush, but we will time it out or
still react to SIGINT, so we're doing a 'best effort' kind of flush,
not any correctness guarantees".

In fact, that "best effort" kind of flush is one of the original
reasons for the callback: the flushing of characters of a serial line.
It's timed out (because the close() does have to finish in a timely
manner even if the other end has stopped receiving and i no longer
asserting DTS), and it's not really even about the error code - it's
literally just about "delay until the pending stuff has actually been
sent".

So having both flush (to do a "best effort" try at waiting for stuff
and maybe returning an error) and a release (to actually finish
everything off and get rid of reference counts etc) is perfectly fine
and normal.

> Theoretically, flush() could fail, followed by a successful release(),
> resulting in close() returning an error when it shouldn't since the
> return value of release() is ignored.

That's not even theoretical, it's quite normal. If flush fails, it
*will* be followed by the release() if it's the last close, and the
release is by definition always successful - the release is just a
"ok, we're done now".

So the case you describe is what flush() is designed for. Something
did a best effort to inform the user that things probably didn't work
out. But the user may well not care. If the user close()'d the file
before the last mmap was done, or if the user simply ignores the
return value of close, the kernel doesn't really care. The kernel
basically says "ok, I can *try* to give you relevant errors, but I'm
not going to force the issue, and I'm not going to care if you don't
care".

                       Linus
