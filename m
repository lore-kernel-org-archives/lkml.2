Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab1LOWOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:14:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64629 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1LOWOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:14:03 -0500
MIME-Version: 1.0
In-Reply-To: <20111215190846.GA2709@thunk.org>
References: <E1RauNd-0008W1-02@tytso-glaptop.cam.corp.google.com>
 <CA+55aFw6n=WaDWRn7NqtBei1x0-w1PkH5x6r3iQSSPZvxYvDhQ@mail.gmail.com> <20111215190846.GA2709@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Dec 2011 14:13:41 -0800
X-Google-Sender-Auth: tcyOOTGrRAVRYhSv8P4ZxsHZHdc
Message-ID: <CA+55aFxc3f4mDf4bJhQF41KdzRfa+TGWKEDsVjGKKsuUD5a-VQ@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 bugfixes for 3.2-rc5
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 11:08 AM, Ted Ts'o <tytso@mit.edu> wrote:
>
> Cool!  Does it save enough that GPG signature information can be
> verified later?

Yes, it saves the whole tag object data, and the verification really
is very simple.

Do the command line I suggested:

  git cat-file commit 2240a7bb479c |
       awk '/^mergetag /,/^$/ { print }' |
       sed 's/^mergetag//' |
       sed 's/^ //'

(ok, that can almost certainly be done smarter, but it's a
step-by-step trivial thing: the "awk" line to get everything in the
commit object header 'mergetag' line to tne end of the commit header
(empty line), followed by removing the "mergetag" part, followed by
removing the continuation space at the beginning of the line.

Now, save the end result to a file, and then split the file so that
the gpg signature part (-----BEGIN PGP SIGNATURE----- etc) is in
"file.sign", and the part before it, which in this case is

  object 5a0dc7365c240795bf190766eba7a27600be3b3e
  type commit
  tag tytso-for-linus-20111214
  tagger Theodore Ts'o <tytso@mit.edu> 1323890113 -0500

  tytso-for-linus-20111214

is in the file "file", and now you can just do

  [torvalds@i5 linux]$ gpg --verify file.sign file
  gpg: Signature made Wed 14 Dec 2011 11:15:13 AM PST using RSA key ID C11804F0
  gpg: Good signature from "Theodore Ts'o <tytso@mit.edu>"
  gpg:                 aka "Theodore Ts'o <tytso@debian.org>"
  gpg:                 aka "Theodore Ts'o <tytso@google.com>"

>                   I'm a little fuzzy on what is covered by the
> signature which gets verified when you run the command "git verify-tag
> tytso-for-linus-20111214".  Better yet, does the new version of git
> have a command that will automatically verify the digital signature
> found in a merge commit?

See above, the pgp signature logic is *really* simple: it's literally
"the pgp signature at the end covers everything up until the pgp
signature part".

And it's unambiguous even in the case of multiple lines of "-----BEGIN
PGP SIGNATURE-----" - you just need to take the last block. Whether we
do that right in the actual implementation, I have no idea, but the
thing is at least designed to allow that.

This all literally used to be a couple of lines of shell script in the
original git implementation of "git verify-tag".

You can just go to the git sources, and do

   git log -p -- git-verify-tag.sh

to see that old historic implementation, of course. Here's the very
original one:

  #!/bin/sh
  . git-sh-setup || die "Not a git archive"

  tag=$(git-rev-parse $1) || exit 1

  git-cat-file tag $tag > .tmp-vtag || exit 1
  cat .tmp-vtag | sed '/-----BEGIN PGP/Q' | gpg --verify .tmp-vtag - || exit 1
  rm -f .tmp-vtag

which gets it wrong for the case of multiple lines of "BEGIN PGP", but
whatever.

> And this isn't in 1.7.8 yet, right?  I'd have to build version of git
> based on the next branch to play with this new signatury goodness?

If you actually want to merge signed tags with the save-the-tag-info
feature, yes. It's in the current master branch of git, but not in any
released version yet.

                    Linus
