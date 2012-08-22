Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117Ab2HVECb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:02:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47932 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2HVEC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:02:29 -0400
Date: Wed, 22 Aug 2012 14:02:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: linux-next: manual merge of the fsnotify tree with Linus' tree
Message-Id: <20120822140217.d64229c7e94091a9e8d27a1b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Aug_2012_14_02_17_+1000_WxEmVHmgAFtzCUTC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Aug_2012_14_02_17_+1000_WxEmVHmgAFtzCUTC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the fsnotify tree got a conflict in
kernel/audit_tree.c between commits a2140fc0cb03 ("audit: fix refcounting
in audit-tree") and b3e8692b4dde ("audit: clean up refcounting in
audit-tree") from Linus' tree and commit 3c183c233284 ("fsnotify: pass
group to fsnotify_destroy_mark()") from the fsnotify tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/audit_tree.c
index ed206fd,9cedf31..0000000
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@@ -249,7 -249,8 +249,7 @@@ static void untag_chunk(struct node *p
  		list_del_rcu(&chunk->hash);
  		spin_unlock(&hash_lock);
  		spin_unlock(&entry->lock);
- 		fsnotify_destroy_mark(entry);
+ 		fsnotify_destroy_mark(entry, audit_tree_group);
 -		fsnotify_put_mark(entry);
  		goto out;
  	}
 =20
@@@ -291,8 -292,8 +291,8 @@@
  		owner->root =3D new;
  	spin_unlock(&hash_lock);
  	spin_unlock(&entry->lock);
- 	fsnotify_destroy_mark(entry);
+ 	fsnotify_destroy_mark(entry, audit_tree_group);
 -	fsnotify_put_mark(entry);
 +	fsnotify_put_mark(&new->mark);	/* drop initial reference */
  	goto out;
 =20
  Fallback:
@@@ -443,9 -443,9 +443,9 @@@ static int tag_chunk(struct inode *inod
  	spin_unlock(&hash_lock);
  	spin_unlock(&chunk_entry->lock);
  	spin_unlock(&old_entry->lock);
- 	fsnotify_destroy_mark(old_entry);
+ 	fsnotify_destroy_mark(old_entry, audit_tree_group);
 +	fsnotify_put_mark(chunk_entry);	/* drop initial reference */
  	fsnotify_put_mark(old_entry); /* pair to fsnotify_find mark_entry */
 -	fsnotify_put_mark(old_entry); /* and kill it */
  	return 0;
  }
 =20

--Signature=_Wed__22_Aug_2012_14_02_17_+1000_WxEmVHmgAFtzCUTC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNFnJAAoJEECxmPOUX5FEUn4P/1lz1BgE7uZCN1zQCdpsw/7f
7ywzy89yV1zQI/txEP2aWzuj6v3JdXgdEMQTwK5vhXZT+xh1EIbMFfryHmN5R1up
T6KK1RTPVp5OJsMC7UQbsyfVtK9FpvlnPf6EqOsnZJ+Mk7RAFw693qd+TqFkepFD
jjwjJCy28SEZIhV1zRZ8MpL5K2fQKkLqiLKF8JyVvdbRL7u5qj3o9KRqByQAgkwH
Mlh6pnsqG0ijiNEOQy62AaTW0yBVkDVGGCHOQ/u3c8jg/fn+aScSMsVEHLWw3sOP
WG6l6TqaGP03+3k+mWt90UGXk5icx4xHFgPH+bcTkN2yUpc3mlIRvc9qQbmjwfGm
WGbun14a+JmYrjiY+uYXx+D/ij7sLchyONSxyNW4Alpnvyjl//eX8jzGo/fwgIBx
WAcr4np0enprUeEEy4QXV5D11OKWGtbfflpWre/ON16J65GgVFK1es88C0DRQIw0
naFu8vJnS5XeuIm7G7ZpHWYnw/q4utqwKYBlN6S9tFKAZ+Fatd2kj7/fYO9OnAUf
4lMDL9L1DOTD2Y7UP5Vf1h1ri+DikP2inUPJVu1In6FaTlF6ngC2nIX+7aedYs2x
Sg7RFT6n5PLJyHjNQbIWcklXUG2RTPApJnmSd4nTy6DpCqYN5kvcjz8g8B0UWQOw
g9E3/w3GecG9f5luucy2
=aG/R
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Aug_2012_14_02_17_+1000_WxEmVHmgAFtzCUTC--
