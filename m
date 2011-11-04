Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab1KDPPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:15:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45854 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1KDPPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:15:16 -0400
MIME-Version: 1.0
In-Reply-To: <20111104145908.GA3903@thunk.org>
References: <7vwrbjlj5r.fsf@alter.siamese.dyndns.org> <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org> <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
 <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
 <7v62j1gitn.fsf@alter.siamese.dyndns.org> <7vvcr1f38j.fsf@alter.siamese.dyndns.org>
 <CA+55aFyRawm9CoJMiEXDFCX4YTidPOiV4oqSS2d7nNv7Ecw8BQ@mail.gmail.com> <20111104145908.GA3903@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 4 Nov 2011 08:14:52 -0700
X-Google-Sender-Auth: g_0aJjAxucferXLsnG3GKm_YgG4
Message-ID: <CA+55aFw6JJDkkSJnp=X4cQuibXMHVBgbQ99iPqEbd7p_7J=VfQ@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Junio C Hamano <gitster@pobox.com>, Shawn Pearce <spearce@spearce.org>,
        git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 7:59 AM, Ted Ts'o <tytso@mit.edu> wrote:
>
> Note that a repository format change will break a bunch of other
> things as well, including references in commit descriptions ("This
> fixes a regression introduced in commit 42DEADBEEF")

No they won't. Not if you do it right. It's easy enough to
automatically replace the SHA1's in the description, the same way we
replace everything else.

Really.  It's *trivial*.

Maybe some current tools don't do it, but if I were to convert the
kernel tree, I'd absolutely *require* the conversion to be done right.
And "right" means "don't just get the parent SHA1's right, but the
ones hiding in the description too".

Any conversion tool has to keep track of the translation from "old
SHA1 to new SHA1" *anyway* because of all the other issues (ie exactly
things like parent pointers etc), so conversion tools by definition
have the information to do things like this right.

But "internal cryptographic signatures" are fundamentally different. A
conversion tool *cannot* convert them, since it won't have access to
the private keys in question, and thus cannot fix up the signature.

Sure, if I do the conversion, I could make *my* signatures match. And
that is true for every signer out there - individually. But only
individually, never collectively. Sure, we could all meet in one place
and synchronously re-sign things on our private machines with some
"distributed conversion tool", but realistically that really really
doesn't work.

It's a fundamental problem. And it really isn't a theoretical one -
it's one we know will happen *some* day.

I haven't worried about SHA1, exactly because I know it's not a real
problem - we can always convert. But internal signatures very
fundamentally change that.

And it really is about *internal* signatures. The kinds of signed tags
we have now are not a problem. Those can trivially be converted in a
distributed manner, exactly because they are "detatched" from what
they sign. We carry them along with the git repo, but they don't mess
up history, and they can be re-created individually without changing
anything else.

And yes, this was actually a design issue for me, which is why I feel
so strongly about it. I actually *thought* about issues like this
five+ years ago: I wanted to have cryptographic security, but I very
much on purpose wanted it to be "outside" the repo.

(Ok, so the git tag objects can sign other git tag objects
recursively, and in that case you have an ordering issue where a
conversion would first have to get somebody to re-sign their "inner"
tag before the "outer" signature can be re-created, but even if that
were to happen - and I don't think anybody does it - it's a trivial
problem with no real complexity issues).

>>  - they are ugly as heck, and you really don't want to see them in
>> 99.999% of all cases.
>
> So we can make them be hidden from "git log" and "gik" by default.
> That bit is a bit gross, I agree, but 3rd party verification really is
> a good thing, which I'm hoping can be added in a relatively clean
> fashion.

I agree that we can hide them - that's after all what the pgpsig thing
does in the "internal commit signature" that git has in pu/next. That
one hides ie even more specifically, by putting it in the headers of
the commit, but that's just a random implementation detail.

But I really think that "internal signatures" that actually affect the
SHA1 of the object and its history have fundamental design problems.
They may not be "insurmountably bad", but they are definitely real.

                        Linus
