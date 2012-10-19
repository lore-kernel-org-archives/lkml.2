Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945923Ab2JSWEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:04:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36262 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab2JSWEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:04:24 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx339WquJEjijeRQ+12Aw0sa+MoL+kFttjbJLJ6S1Jy+Q@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <87txtso9xw.fsf@rustcorp.com.au> <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com>
 <871ugwny1n.fsf@rustcorp.com.au> <CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com>
 <87fw5bp858.fsf@rustcorp.com.au> <CA+55aFx339WquJEjijeRQ+12Aw0sa+MoL+kFttjbJLJ6S1Jy+Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Oct 2012 15:04:03 -0700
X-Google-Sender-Auth: JKjWzxEdsAjcXrSye2aMiKKZsk4
Message-ID: <CA+55aFyDW4z5x8YcbQ8CYJvwHE3poK9iX8Sfgbg2fVaS3Bio4w@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Miller <davem@davemloft.net>, David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 12:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Tssk. I fixed it up, and now it works-for-me(tm), but some perl person
> probably really should try to make that sign-file and x509keyid merge.
> My fix made the thing even slower, doing two extra "wc -c" invocations
> since it can't do "${#..}" expansion due to the locale problem.

Hmm. I haven't seen this breakage personally yet, but looking more at
Rusty's last changes I'm pretty sure my fixes are potentially not
sufficient.

In particular, this line from Rusty's sign-file script simplification
makes me worry:

  KEYID="`perl $keyid_script $x509 keyid`"

and the problem is that the 'keyid' is a binary blob.

And I'm pretty damn sure that assigning random binary data to shell
variables is going to break eventually. In particular, I tested NUL
characters, and bash is not happy about doing things like

   a="`echo -en '\000'`"

and 'a' ends up empty, not containing a one-byte string containing a
NUL character. Not to mention that even if the shell were to handle
this correctly, if you do

  echo -n "$a"

then even *if* the shell remembered that 'a' contains one NUL
character, when it then executes the 'echo' binary, that will
certainly not be able to handle it. With a built-in 'echo' it _could_
work, with an external one it fundamentally could not. NUL is special,
and terminates strings at execve(). You cannot have NUL bytes in
arguments.

Of course, I don't know the rules for x509 key id blobs. Maybe they
aren't allowed to contain NUL anyway?

Possible solutions:

 - Linus is a worry-wart, and key id's never contain NUL.

 - somebody with the appropriate perl-fu does the perl conversion, and
keeps it all in perl.

 - somebody with (slightly less) perl-fu makes the x509 keyid_script
return a quoted string, so that we can save that *quoted* version for
the shell interatction (perhaps in a similar format that we now use
for the "prologue" variable, ie just a list of hex bytes)

otherwise we need to go back to putting the binary blob in a file
(which shell won't corrupt).

Rusty, David?

               Linus
