Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454Ab2BOBiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:38:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622Ab2BOBiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:38:03 -0500
Date: Wed, 15 Feb 2012 12:37:50 +1100
From: NeilBrown <neilb@suse.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
Message-ID: <20120215123750.3333141f@notabene.brown>
In-Reply-To: <1329265750.2340.17.camel@work-vm>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	<1328832993-23228-2-git-send-email-john.stultz@linaro.org>
	<20120214051659.GH14132@dastard>
	<1329198932.2753.62.camel@work-vm>
	<20120214235106.GL7479@dastard>
	<1329265750.2340.17.camel@work-vm>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TS3eXNpKOSdGkX7h4ikbMK+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TS3eXNpKOSdGkX7h4ikbMK+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Feb 2012 16:29:10 -0800 John Stultz <john.stultz@linaro.org> wro=
te:

> But I'm open to other ideas and arguments.

I didn't notice the original patch, but found it at
https://lwn.net/Articles/468837/
and had a look.

My first comment is -ENODOC.  A bit background always helps, so let me try =
to
construct that:

 The goal is to allow applications to interact with the kernel's cache
 management infrastructure.  In particular an application can say "this
 memory contains data that might be useful in the future, but can be
 reconstructed if necessary, and it is cheaper to reconstruct it than to re=
ad
 it back from disk, so don't bother writing it out".

 The proposed mechanism - at a high level - is for user-space to be able to
 say "This memory is volatile" and then later "this memory is no longer
 volatile".  If the content of the memory is still available the second
 request succeeds.  If not, it fails.. Well, actually it succeeds but repor=
ts
 that some content has been lost. (not sure what happens then - can the app=
 do
 a binary search to find which pages it still has or something).

 (technically we should probably include the cost to reconstruct the page,
 which the kernel measures as 'seeks' but maybe that isn't necessary).

 This is implemented by using files in a 'tmpfs' filesystem.  These file
 support three new flags to fadvise:

 POSIX_FADV_VOLATILE - this marks a range of pages as 'volatile'.  They may=
 be
        removed from the page cache as needed, even if they are not 'clean'.
 POSIX_FADV_NONVOLATILE - this marks a range of pages as non-volatile.
        If any pages in the range were previously volatile but have since b=
een
        removed, then a status is returned reporting this.
 POSIX_FADV_ISVOLATILE - this does not actually give any advice to the kern=
el
        but rather asks a question: Are any of these pages volatile?


Is this an accurate description?

My first thoughts are:
 1/ is page granularity really needed?  Would file granularity be sufficien=
t?
 2/ POSIX_FADV_ISVOLATILE is a warning sign to me - it doesn't actually
    provide advice.  Is this really needed?  What for?  Because it feels li=
ke
    a wrong interface.
 3/ Given that this is specific to one filesystem, is fadvise really an
    appropriate interface?

(fleshing out the above documentation might be an excellent way to answer
these questions).

As a counter-point,  this is my first thought of an implementation approach
(-ENOPATCH, sorry)

- new mount option for tmpfs e.g. 'volatile'.  Any file in a filesystem
  mounted with that option and which is not currently open by any process c=
an
  have blocks removed at any time.  The file name must remain, and the file
  size must not change.
- lseek can be used to determine if anything has been purged with 'SEEK_DAT=
A'
  and 'SEEK_HOLE'.

So you can only mark volatility on a whole-file granularity (hence the
question above).
 'open' says "NONVOLATILE".
 'close' says "VOLATILE".
 'lseek' is used to check if anything was discarded.

This approach would allow multiple processes to share a cache (might this be
valuable?) as it doesn't become truly volatile until all processes close
their handles.


Just a few thoughts ... take or discard as you choose.

NeilBrown



--Sig_/TS3eXNpKOSdGkX7h4ikbMK+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzsMbjnsnt1WYoG5AQJZCBAApWmHwvCPiyRhizlGPpXcNL1yyTEq4UCP
jFAdEwIzLuIOotM9skvRuQnXGwSQZY2K0EDvhqCFS1FtnoDtgg7IuMYWXvZzgd/S
Xryt039DSV7SqhLDGMnwTSb4Kd2VFQPZjomw82HXOR0pAZ7ebe+dpEooEmv94jNs
su7kjKqHJMoQCai3vU6IOH/GnWPhKrxbVzXBGGf4uuNR0jh3f9Wvx5X2vf2GHVyJ
svudr2UdKRVlk6CEQZn37+VoaEsv1ydwgBMjEjvxtO12fF9bTf9U75T/jVd5YMsi
VBvIqlyCyKcZGLlJwPV5NvuoP/jz500lhakfEjbM84jhU3IQ2rUBG0DRJZj+lGnh
aekElqCvX06an/hOzKWlUvrXK8pdWjFVA/DIN9SIQqqeazP/jWHXcjOO6YJFVKdt
gaYXDb1ZouQsX96l6MNrCbnCK+HSEBCfxbq3ohsuQopEv5ml0uSPVTgf7IDLAWwn
AuTK6hihiqDAtCiVdkYG9oDyZi/NEsA7yKYLqdmOJTYYnnId3nfIQSd9XnYh30Hz
M3vo7mCSDj2UlIQ2beAoMKtFmc7U2bugzTDJYbvV7CXx7zILVIVKTjNQu2jCx6AH
vId2hoV4trSh/x+dHF6gnF9kJ+q1HvzaU9uEA5Qq1vfaqMTPeJxuuzLfX0bt1jEo
htbb+/pP2r4=
=74nP
-----END PGP SIGNATURE-----

--Sig_/TS3eXNpKOSdGkX7h4ikbMK+--
