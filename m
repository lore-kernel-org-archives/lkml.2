Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1GQXby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 19:31:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3375 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab1GQXbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:31:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=xIaAQ6yNLlYsYX/Wm4aJrL8zEB8WRkgv1OXlwS3mLI2lYc8emur0uaI18NGScxTyT
	8wGO5CmlRsq8SmFwrMhTg==
Date: Sun, 17 Jul 2011 16:31:37 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
In-Reply-To: <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1107171604150.1237@sister.anvils>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils> <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-268545250-1310945505=:1237"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-268545250-1310945505=:1237
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 17 Jul 2011, Linus Torvalds wrote:
> On Sun, Jul 17, 2011 at 2:03 PM, Hugh Dickins <hughd@google.com> wrote:
> >
> > That -ENOENT in walk_component: isn't it assuming we found a negative
> > dentry, before reaching the read_seqcount_retry which complete_walk
> > (or nameidata_drop_rcu_last before 3.0) would use to confirm a successf=
ul
> > lookup?
>=20
> Hmm. I think you're right. The ENOENT will basically short-circuit the
> full proper checks.
>=20
> > =A0And can't memory pressure prune a dentry, coming to dentry_kill
> > which __d_drops to unhash before dentry_iput resets d_inode to NULL, bu=
t
> > the dentry_rcuwalk_barrier between those is ineffective if the other en=
d
> > ignores the seqcount?
>=20
> Yes. However, looking at it, I'm not very happy with your patch. It
> doesn't really make sense to me to special-case the NULL inode and
> only do a seq_retry for that case.
>=20
> I kind of see why you do it for that particular bug, but at the same
> time, it just makes me go "Eww". If that inode isn't NULL yet, you
> then return the dentry that can get a NULL d_inode later. So the only
> special thing there is that we happen to check for a NULL inode there.
> What protects *later* checks for a NULL d_inode?

I was imagining that all the later uses of the inode were using
walk_component()'s local struct inode *inode, or nd->inode which
it sets on success.  Until complete_walk(), or the next level down
of lookup, has validated that stage by checking nd->seq.

If any does dereference dentry->d_inode in between, then it would
already be oopsing in this situation, which I've not seen.

>=20
> So my gut feel is that we should instead
>=20
>  - either remove the -ENOENT return at that point entirely, and move
> it to after we have re-verified the dentry lookup for other reasons.
> That looks pretty involved, though, and those paths do end up
> accessing inode data structures etc, so it looks less than trivial.
>=20
> OR
>=20
>  - simply just not clear d_inode at all in d_kill(), so that when we
> prune a dentry due to memory pressure, it doesn't actually change the
> state of the dentry.

But whether my imagining was right or wrong, your -1 line patch
looks a much nicer solution.

>=20
> and I think the second solution is the right one. It's kind of odd:
> we'll have called down to the iput() routine, and the inode will be
> "gone", but that is already true for the *normal* race of actually
> deleting a file too, and we have that whole "inodes are RCU-released",
> so the inode allocation will still exist.

Yes, the inodes are RCU-released too, so that side of it fits okay.

>=20
> So my gut feel is that we should instead just do this:
>=20
>   --- a/fs/dcache.c
>   +++ b/fs/dcache.c
>   @@ -187,7 +187,6 @@ static void dentry_iput(struct dentry * dentry)
>    {
>           struct inode *inode =3D dentry->d_inode;
>           if (inode) {
>   -               dentry->d_inode =3D NULL;
>                   list_del_init(&dentry->d_alias);
>                   spin_unlock(&dentry->d_lock);
>                   spin_unlock(&inode->i_lock);
>=20
> and see what the fall-out from that would be. Nobody should then *use*
> the stale inode, because __d_drop has done that
> dentry_rcuwalk_barrier(). So we avoid the NULL inode special case
> entirely.
>=20
> Comments?

At first it looked worrying to interfere with the sequence
"inode =3D dentry->d_inode; if (inode) { dentry->d_inode =3D NULL;"
but seeing as dentry_iput() is only called from the one place,
I think the test is merely about negative dentries, and setting
d_inode to NULL is just long-standing tidiness, nothing vital.

>=20
> The above (whitespace-damaged) patch may look trivial, but it is
> *entirely* untested, and maybe my gut feel that the above is the right
> way to solve the problem is just wrong.
>=20
> Al, any reactions? Hugh, does the above patch work for your
> stress-test case? Or, indeed, at all?

Well, my stress tests don't blow up in the first half hour.
But I was not successful in re-reproducing the issue (I got
yesterday in 2.5 hours) within 7 hours, so it's probably going
to take days to be sure that your minus-1-liner fixes it.

I certainly like your patch, though I'm not quite as confident
with it as I was with mine (until you pointed out its inconsistency).
Just a nagging doubt that leaving d_inode set may be wrong for somewhere.

Hugh
--8323584-268545250-1310945505=:1237--
