Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab2CWPgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 11:36:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:9456 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab2CWPf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 11:35:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="124329199"
Message-ID: <1332517132.18717.102.camel@sauron.fi.intel.com>
Subject: Re: [patch] Add design document for UBIFS secure deletion
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Mar 2012 17:38:52 +0200
In-Reply-To: <alpine.DEB.2.00.1203231448520.22944@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	   <1329152067.22240.214.camel@sauron.fi.intel.com>
	   <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>
	   <alpine.DEB.2.00.1202231628360.13720@eristoteles.iwoars.net>
	  <1331277476.22872.2.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1203191752300.22256@eristoteles.iwoars.net>
	 <1332346218.14983.20.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203231448520.22944@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-P2thkQUaCgQEndNqJzDG"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-P2thkQUaCgQEndNqJzDG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've pushed this patch to the joel branch, but still have comments. Feel
free to send incremental changes - I'll just squash them in.

On Fri, 2012-03-23 at 14:50 +0100, Joel Reardon wrote:
> +Introduction
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +UBIFSec provides efficient secure deletion for the flash file system UBI=
FS.
> +Trivial secure deletion by overwriting the deleted data does not work fo=
r
> +UBI-accessed flash memory, as there is a large difference between the si=
ze of
> +the I/O unit (page) and the erasure unit (logical erase block or LEB).
> +UBIFSec encrypts each data node with a distinct key and stores the keys
> +colocated in a key storage area (KSA).  Secure deletion is achieved by
> +updating the (small) set of LEBs that constitute the KSA to remove keys
> +corresponding to deleted data, thereby deleting the data nodes they encr=
ypted.
> +The additional wear due to flash erasure is small, only the LEBs contain=
ing
> +the keys, and the operation of removing old keys---called purging---is d=
one
> +periodically so the actual increase in wear is controlled by the user.
> +Moreover, the use of UBI's logical interface means that the additional w=
ear is
> +evenly spread over the flash memory and the new version of a LEB contain=
ing
> +the keys can be written using UBI's atomic update proceedure to ensure n=
o keys
> +are lost during an update.

How about: s/during an update/in case of a power cut/

> +Key Storage Area (KSA)
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +UBIFSec uses a small set of LEBs to store all the data node's keys---thi=
s set
> +is called the Key Storage Area (KSA). The KSA is managed separately from=
 the
> +rest of the file system.

> In particular, it does not behave like a
> +log-structured file system: when a KSA LEB is updated, its contents are
> +written to a new physical location on the flash memory, UBI's logical ma=
p is
> +then updated to this new physical address and the previous version of th=
e KSA
> +LEB is then erased. =20

Am I right that you basically wanted to say that when you update a KSA
LEB, you make sure that the physical flash does not contain the old
contents of this LEB? Would be nice to re-phrase.

Side question - how do you do this?

> Thus, except while updating the KSA, only one copy of the
> +data in the KSA is available on the storage medium.  When the file syste=
m is
> +created, cryptographically-suitable random data is written from random_b=
ytes()
> +to each of the KSA's LEBs and all the keys are marked as unused. Purging
> +writes new versions of the KSA LEBs using UBI's atomic update feature.

Just a general question about: I guess you have to call ubi_sync() then
to make sure the old version is actually erased, right?

> +Each data node's header stores the logical KSA position that contains it=
s
> +decryption key. The LEBs in the KSA are periodically erased to securely =
delete
> +any keys that decrypt deleted data. When the file system no longer needs=
 a
> +data node---i.e, it is removed or updated---we mark the data node's
> +corresponding key in the KSA as deleted.  This is independent of the not=
ion of
> +files; keys are marked as deleted whenever a data node is discarded.  A =
key
> +remains marked as deleted until it is removed from the storage medium an=
d its
> +location is replaced with fresh, unused random data, which is then marke=
d as
> +unused.

Read this far, and have 2 big questions:

1. How keys are marked as deleted (I guess in some in-memory data
structure)
2. When deleted keys are removed from the medium (probably on commit?)

I guess I'll find the answers below.

> +When a new data node is written to the storage medium, an unused key is
> +selected from the KSA and its position is written to the data node's hea=
der.

Questions arises - how the key is selected?

> +The keys are in a protected area of the file system, so only users with =
root
> +access to the storage medium are capable of reading the keys that encryp=
t
> +data.

Hmm, what is the protected area? What prevents anyone from reading them
by finding them in /dev/ubiX_Y or /dev/mtdZ ?

> +Purging
> +=3D=3D=3D=3D=3D=3D=3D
> +Purging is a periodic procedure that securely deletes keys from the KSA.

I guess you mean deleted keys?

> +Purging proceeds iteratively over each of the KSA's LEBs: a new version =
of the
> +LEB is prepared where the used keys remain in the same position and all =
other
> +keys (i.e., unused and deleted keys) are replaced with fresh, unused,
> +cryptographically-appropriate random data from a source of hardware
> +randomness.

Hmm, why is it necessary to re-initialize unused keys?

>  This fresh random data is then assigned to new keys as needed. We
> +keep used keys logically-fixed because their corresponding data node has
> +already written its logical position. The new version of the LEB is then
> +written to an arbitrary empty LEB on the storage medium.  After completi=
on,
> +the LEB containing the old version is erased, thus securely deleting the
> +unused and deleted keys along with the data nodes they encrypt.
> +
> +If a KSA LEB becomes a bad block while erasing it, it is possible that i=
ts
> +contents will remain readable on the storage medium without the ability =
to
> +remove them. In this case, it is necessary to re-encrypt any data node w=
hose
> +encryption key remains available and force the garbage collection of tho=
se
> +LEBs on which the data nodes reside.

Good point. UBI will always try to erase and re-write a PEB several
times before marking it as bad, so hopefully the keys will disappear,
but there is no guarantee.

> +Key State Map
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +The key state map is an in-memory map that maps key positions to key sta=
tes
> +{unused, used, deleted}.=20

Is it 2 bits per key?

> Unused keys can be assigned and then marked used.
> +Used keys are keys that encrypt some valid data node, so they must be
> +preserved to ensure availability of the file system's data. Deleted keys=
 are
> +keys used to encrypt deleted data---i.e., data nodes that are no longer
> +referenced by the index---and should be purged from the system to achiev=
e
> +secure deletion.
> +
> +A correct key state map is one that has the following three properties:
> +1. every unused key must not decrypt any data node---either valid or inv=
alid
> +2. every used key must have exactly one data node it can decrypt and thi=
s data
> +node must be valid according to the index
> +3. every deleted key must not decrypt any data node that is valid accord=
ing to
> +the index.

I guess you do not enforce these rules, you just rely on the randomness?

> +
> +The operation of purging performed on a correct key state map guarantees
> +soundness: purging securely deletes any key in the KSA marked as
> +deleted---afterwards, every key either decrypts one valid data node or n=
othing
> +at all and every valid data node can be decrypted.  A correct key state =
map
> +also guarantees the integrity of our data during purging, because no key=
 that
> +is used to decrypt valid data will be removed.
> +
> +The key state map is stored, used, and updated in volatile memory. Initi=
ally,
> +the key state map of a freshly-formatted UBIFSec file system is correct =
as it
> +consists of no data nodes, and every key is fresh random data that is ma=
rked
> +as unused. While mounted, UBIFSec performs appropriate key management to
> +ensure that the key state map is always correct when new data is written=
,
> +deleted, etc. We now show that we can always create a correct key state =
map
> +when mounting an arbitrary UBIFSec file system.

You'd also need to teach mkfs.ubifs to write correct KSA.

> +The key state map is built from a periodic checkpoint combined with a re=
play
> +of the most recent changes while mounting.  We checkpoint the current ke=
y
> +state map to the storage medium whenever the KSA is purged.

, which happens when UBIFS commits?

>  After a purge,
> +every key is either unused or used, and so a checkpoint of this map can =
be
> +stored using one bit per key---less than 1% of the KSA's size---which is=
 then
> +compressed.  A special LEB is used to store checkpoints, where each new
> +checkpoint is appended; when the LEB is full then the next checkpoint is
> +written at the beginning using an atomic update.

Hmm, interesting how you manage checkpoints. I guess the easiest would
be to have a special inode (not visible for users) and store checkpoints
there?

--=20
Best Regards,
Artem Bityutskiy

--=-P2thkQUaCgQEndNqJzDG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPbJkMAAoJECmIfjd9wqK04ekQAKsnbh4PaOnoU76j1dyeGDQY
sbkI9qudMAIL1TE8KSdLb+SDqlCWxcCWgyRK69TFShOvhpt5ao/z9ZSJ8wZf1xtE
4VRtHAHt7YZYhkDWqjKDRTiaVujsU0tegdqm9U4O/ZE+aNQwN8CsA3ie2kO0ux7v
06dErouVXf/BOxEmtprwIkm9d+H2qK6oFdstbwa1PZBj8303sxcX0kWIYdFyVo/P
RyRoSmkg7DYOSXmaEh9CwuebgsD1ISKveAaL2qjo6qK2ACw57W9F/4tacWRbc6ZG
wsPdeCYV8yMtUVfPG1hVWY8M/9UhWadMd2CVvqRde+QFHJlzZ7DlnNYNMF4+wi2Z
lY20c/zyzdZZkIIKlW5DSYD7QjqHt85mJo6GSeXmnLNKm13okiIhUI2pPyQdTyYf
eOFCMpzKp+MdVIea2h91A/SOw8wxcnJCZEocIR10SCmEnkDM4xz/jOwGtum77121
IZpWgdbPIzxC9LIwpSdLgxZXhOr65ghb5AIyfgob91En463fqmrEnMooXFMJKFT9
xYaJWHOrzlNEfvrZtxXYnwc9wWf6wKqjebCzK0swW8fVz5A2M0AIBMWWKZ0+iceb
4zsqrMkK2l6db2zKbEQEVvZA3sPPx8NnOOMaVuOuXioBP+wgiL80xTpe+ItUDenn
LGYVuIuAmLaefnky9VtN
=aUid
-----END PGP SIGNATURE-----

--=-P2thkQUaCgQEndNqJzDG--

