Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2JJWRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:17:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215Ab2JJWRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:17:11 -0400
Date: Thu, 11 Oct 2012 09:17:12 +1100
From: NeilBrown <neilb@suse.de>
To: =?utf-8?Q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 06/16] f2fs: add node operations
Message-ID: <20121011091712.410a3a71@notabene.brown>
In-Reply-To: <000d01cda2f1$037771b0$0a665510$%kim@samsung.com>
References: <000d01cda2f1$037771b0$0a665510$%kim@samsung.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qw/ewglxfceaE6Q8rU4nX/J"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Qw/ewglxfceaE6Q8rU4nX/J
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Oct 2012 21:00:29 +0900 =EA=B9=80=EC=9E=AC=EA=B7=B9 <jaegeuk.kim=
@samsung.com> wrote:


> +static struct nat_entry *grab_nat_entry(struct f2fs_nm_info *nm_i, nid_t=
 nid)
> +{
> +	struct nat_entry *new;
> +
> +	new =3D kmem_cache_alloc(nat_entry_slab, __GFP_HIGH | __GFP_NOFAIL);
> +	memset(new, 0, sizeof(struct nat_entry));
> +	nat_set_nid(new, nid);
> +	__add_to_nat_cache(nm_i, new);
> +	return new;
> +}
> +
> +static void cache_nat_entry(struct f2fs_nm_info *nm_i, nid_t nid,
> +						struct f2fs_nat_entry *ne)
> +{
> +	struct nat_entry *e;
> +
> +	write_lock(&nm_i->nat_tree_lock);
> +	e =3D __lookup_nat_cache(nm_i, nid);
> +	if (!e) {
> +		e =3D grab_nat_entry(nm_i, nid);
> +		nat_set_blkaddr(e, le32_to_cpu(ne->block_addr));
> +		nat_set_ino(e, le32_to_cpu(ne->ino));
> +		nat_set_version(e, ne->version);
> +		e->checkpointed =3D true;
> +	}
> +	write_unlock(&nm_i->nat_tree_lock);
> +}

Hi,

cache_nat_entry takes an rwlock (like a spinlock), then calls grab_nat_cach=
e,
which calls kmem_cache_alloc().  Doing mem alloc under a spinlock is not
really a good idea, though it is sometimes OK for GFP_ATOMIC.

You use __GFP_HIGH which is equivalent to GFP_ATOMIC, but add __GFP_NOFAIL.
I'm not really sure exactly what this will do when memory is tight, but I
suspect it will spin trying to find memory and there by slow down any other
code that is trying to free memory.

Also, there is a comment in page_alloc.c:
			 * __GFP_NOFAIL is not to be used in new code.
			 *
			 * All __GFP_NOFAIL callers should be fixed so that they
			 * properly detect and handle allocation failures.
			 *

I suggest you fix this code to follow the standard pattern where if the
lookup_nat_cache fails you check if you have already allocated something and
if so use it.  If not, drop the lock, do the allocation with GFP_KERNEL, th=
en
loop back to the top.
At the end, if you allocated something without using it, kfree it.

> +static int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
> +{
> +	struct f2fs_nm_info *nm_i =3D NM_I(sbi);
> +
> +	if (nm_i->nat_cnt < 2 * NM_WOUT_THRESHOLD)
> +		return 0;
> +
> +	write_lock(&nm_i->nat_tree_lock);
> +	while (nr_shrink-- && !list_empty(&nm_i->nat_entries)) {
> +		struct nat_entry *ne;
> +		ne =3D list_first_entry(&nm_i->nat_entries,
> +					struct nat_entry, list);
> +		__del_from_nat_cache(nm_i, ne);
> +	}
> +	write_unlock(&nm_i->nat_tree_lock);
> +	return nr_shrink;
> +}


This code looks wrong to me, in a small way.
The return value is only ever tested for whether it is zero or not.
For that last 'return', nr_shrink will only be zero if the original nr_shri=
nk
is exactly one more than the number of items in nat_entries.  If nr_shrink =
is
more than that, the function will return "-1".
I suspect that is not what is desired.

I would suggest changing the test in the while loop to
      while (nr_shrink && !list_empty(...)) {
and add
      nr_shrink--;
somewhere inside the loop.


Regards,
NeilBrown

--Sig_/Qw/ewglxfceaE6Q8rU4nX/J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHXz6Dnsnt1WYoG5AQIovhAAl7d6rtovpfWM9vozU3PUT5QHP2Da2f9f
+YokfAyeXP0Wi8u5HTZLgX8BF31z8ofOj14Iy/RwFDk6fLBm0rb2vQLyBJeckJhY
+F43O3n9WJ3lsilnoENTGTbeVmKN8Qhd8GuJBMSKEP5f3FPJFHADDXTsswX104rH
qjuELJFulflS6MJAUSQ4u18OStMW6e/GGeUyK6EM5JDt+/vwulKCNKMgdo6UfpR2
uwpORxueYSrZQiT8Pz2xa141D9g/KLk9xGCF2MgTOBucslH0hqX1z7ctayKyptvf
8V2YMSrB9cwprsokTbiuLWJvgCAb0lVxK3uKqABl44nSiVIJ4fn7KncCilY+2Bnj
yyBLGd+3od8D/0q4l5UlLpHjljKV4gBz9GxhURxcSWkUCJpmqOC9/sydj1nx6cVO
bt1pFcOerM2vtMODONupaRk186/tzbTcfOvQfbNxF0DHNIJEV3gdc6Dd//HCEPfI
Rhw7CpijIlXy+EIKJBQNzZ87+fbhdrFs5MTZjXqf3xYIaddo/3m/akdlJpLFXuUE
B/UySvUQYYQaj5nj/UBE4wRS59Y5c+7xSqDTnwR9OSUhSRn+fjnPscdnUdVXCNpc
7NG8FgrR4HldsFPrRW1axZkSMiEeZb6X2Zb4sjPB1/TsWhCiFa1y58cxlKn8/USb
+Yox/noForY=
=Vo0V
-----END PGP SIGNATURE-----

--Sig_/Qw/ewglxfceaE6Q8rU4nX/J--
