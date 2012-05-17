Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179Ab2EQCIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 22:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760843Ab2EQCID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 22:08:03 -0400
Message-ID: <4FB45D7C.3090306@redhat.com>
Date: Wed, 16 May 2012 22:07:56 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: manfred@colorfullife.com, levinsasha928@gmail.com, npiggin@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch] ipc/mqueue: add rbtree node caching support
References: <34c33c51dbd2ab946a19563b790b5e1be8f751d2.1337196473.git.dledford@redhat.com> <20120516151219.e4d55c81.akpm@linux-foundation.org>
In-Reply-To: <20120516151219.e4d55c81.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.1
OpenPGP: id=0E572FDD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig50FFBC5E5877E8582EE7FE22"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig50FFBC5E5877E8582EE7FE22
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 5/16/2012 6:12 PM, Andrew Morton wrote:
> On Wed, 16 May 2012 15:28:56 -0400
> Doug Ledford <dledford@redhat.com> wrote:
>=20
>> When I wrote the first patch that added the rbtree support for message=

>> queue insertion, it sped up the case where the queue was very full
>> drastically from the original code.  It, however, slowed down the
>> case where the queue was empty (not drastically though).
>>
>> This patch caches the last freed rbtree node struct so we can quickly
>> reuse it when we get a new message.  This is the common path for any
>> queue that very frequently goes from 0 to 1 then back to 0 messages
>> in queue.
>>
>> Andrew Morton didn't like that we were doing a GFP_ATOMIC allocation
>> in msg_insert, so this patch attempts to speculatively allocate a
>> new node struct outside of the spin lock when we know we need it, but
>> will still fall back to a GFP_ATOMIC allocation if it has to.
>>
>> Once I added the caching, the necessary various ret =3D ; spin_unlock
>> gyrations in mq_timedsend were getting pretty ugly, so this also sligh=
tly
>> refactors that function to streamline the flow of the code and the
>> function exit.
>>
>> Finally, while working on getting performance back I made sure that al=
l
>> of the node structs were always fully initialized when they were first=

>> used, rendering the use of kzalloc unnecessary and a waste of CPU cycl=
es.
>>
>> The net result of all of this is:
>>
>> 1) We will avoid a GFP_ATOMIC allocation when possible, but fall back =
on
>> it when necessary.
>> 2) We will speculatively allocate a node struct using GFP_KERNEL if ou=
r
>> cache is empty (and save the struct to our cache if it's still empty a=
fter
>> we have obtained the spin lock).
>> 3) The performance of the common queue empty case has significantly
>> improved and is now much more in line with the older performance for
>> this case.
>>
>> The performance changes are:
>>
>>             Old mqueue      new mqueue      new mqueue + caching
>> queue empty
>> send/recv   305/288ns       349/318ns       310/322ns
>>
>> I don't think we'll ever be able to get the recv performance back, but=

>> that's because the old recv performance was a direct result and conseq=
uence
>> of the old methods abysmal send performance.  The recv path simply mus=
t
>> do more so that the send path does not incur such a penalty under high=
er
>> queue depths.
>>
>> As it turns out, the new caching code also sped up the various queue f=
ull
>> cases relative to my last patch.  That could be because of the differe=
nce
>> between the syscall path in 3.3.4-rc5 and 3.3.4-rc6, or because of the=

>> change in code flow in the mq_timedsend routine.  Regardless, I'll tak=
e
>> it.  It wasn't huge, and I *would* say it was within the margin for er=
ror,
>> but after many repeated runs what I'm seeing is that the old numbers
>> trend slightly higher (about 10 to 20ns depending on which test is the=

>> one running).
>>
>=20
> LGTM.  Here be some coding-style fixes:
>=20
> --- a/ipc/mqueue.c~ipc-mqueue-add-rbtree-node-caching-support-fix
> +++ a/ipc/mqueue.c
> @@ -141,16 +141,18 @@ static int msg_insert(struct msg_msg *ms
>  	} else if (new_leaf) {
>  		leaf =3D *new_leaf;
>  		*new_leaf =3D NULL;
> -	} else
> +	} else {
>  		leaf =3D kmalloc(sizeof(*leaf), GFP_ATOMIC);
> +	}
>  	if (!leaf)
>  		return -ENOMEM;
>  	if (!info->node_cache) {
>  		rb_init_node(&leaf->rb_node);
>  		INIT_LIST_HEAD(&leaf->msg_list);
>  		info->qsize +=3D sizeof(*leaf);
> -	} else
> +	} else {
>  		info->node_cache =3D NULL;
> +	}
>  	leaf->priority =3D msg->m_type;
>  	rb_link_node(&leaf->rb_node, parent, p);
>  	rb_insert_color(&leaf->rb_node, &info->msg_tree);
> @@ -196,8 +198,9 @@ try_again:
>  		if (info->node_cache) {
>  			info->qsize -=3D sizeof(*leaf);
>  			kfree(leaf);
> -		} else
> +		} else {
>  			info->node_cache =3D leaf;
> +		}
>  		goto try_again;
>  	} else {
>  		msg =3D list_first_entry(&leaf->msg_list,
> @@ -208,8 +211,9 @@ try_again:
>  			if (info->node_cache) {
>  				info->qsize -=3D sizeof(*leaf);
>  				kfree(leaf);
> -			} else
> +			} else {
>  				info->node_cache =3D leaf;
> +			}
>  		}
>  	}
>  	info->attr.mq_curmsgs--;
> @@ -1033,9 +1037,11 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
>  	msg_ptr->m_ts =3D msg_len;
>  	msg_ptr->m_type =3D msg_prio;
> =20
> -	/* msg_insert really wants us to have a valid, spare node struct so
> -	 * it doesn't have to kmalloc a GFP_ATOMIC allocation, but it will
> -	 * fall back to that if necessary. */
> +	/*
> +	 * msg_insert really wants us to have a valid, spare node struct so i=
t
> +	 * doesn't have to kmalloc a GFP_ATOMIC allocation, but it will fall
> +	 * back to that if necessary.
> +	 */
>  	if (!info->node_cache)
>  		new_leaf =3D kmalloc(sizeof(*new_leaf), GFP_KERNEL);
> =20
> @@ -1058,8 +1064,10 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
>  			wait.msg =3D (void *) msg_ptr;
>  			wait.state =3D STATE_NONE;
>  			ret =3D wq_sleep(info, SEND, timeout, &wait);
> -			/* wq_sleep must be called with info->lock held, and
> -			 * returns with the lock released */
> +			/*
> +			 * wq_sleep must be called with info->lock held, and
> +			 * returns with the lock released
> +			 */
>  			goto out_free;
>  		}
>  	} else {
> @@ -1136,9 +1144,11 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t,=20
>  		goto out_fput;
>  	}
> =20
> -	/* msg_insert really wants us to have a valid, spare node struct so
> -	 * it doesn't have to kmalloc a GFP_ATOMIC allocation, but it will
> -	 * fall back to that if necessary. */
> +	/*
> +	 * msg_insert really wants us to have a valid, spare node struct so i=
t
> +	 * doesn't have to kmalloc a GFP_ATOMIC allocation, but it will fall
> +	 * back to that if necessary.
> +	 */
>  	if (!info->node_cache)
>  		new_leaf =3D kmalloc(sizeof(*new_leaf), GFP_KERNEL);
> =20
>=20
>=20
>> @@ -132,15 +134,24 @@ static int msg_insert(struct msg_msg *msg, struc=
t mqueue_inode_info *info)
>>  		else
>>  			p =3D &(*p)->rb_right;
>>  	}
>> -	leaf =3D kzalloc(sizeof(*leaf), GFP_ATOMIC);
>> +	if (info->node_cache) {
>> +		leaf =3D info->node_cache;
>> +	} else if (new_leaf) {
>> +		leaf =3D *new_leaf;
>> +		*new_leaf =3D NULL;
>> +	} else
>> +		leaf =3D kmalloc(sizeof(*leaf), GFP_ATOMIC);
>>  	if (!leaf)
>>  		return -ENOMEM;
>> -	rb_init_node(&leaf->rb_node);
>> -	INIT_LIST_HEAD(&leaf->msg_list);
>> +	if (!info->node_cache) {
>> +		rb_init_node(&leaf->rb_node);
>> +		INIT_LIST_HEAD(&leaf->msg_list);
>> +		info->qsize +=3D sizeof(*leaf);
>> +	} else
>> +		info->node_cache =3D NULL;
>=20
> So you have
>=20
> : 	if (info->node_cache) {
> : 		leaf =3D info->node_cache;
> : 	} else if (new_leaf) {
> : 		leaf =3D *new_leaf;
> : 		*new_leaf =3D NULL;
> : 	} else {
> : 		leaf =3D kmalloc(sizeof(*leaf), GFP_ATOMIC);
> : 	}
> : 	if (!leaf)
> : 		return -ENOMEM;
> : 	if (!info->node_cache) {
> : 		rb_init_node(&leaf->rb_node);
> : 		INIT_LIST_HEAD(&leaf->msg_list);
> : 		info->qsize +=3D sizeof(*leaf);
> : 	} else {
> : 		info->node_cache =3D NULL;
> :	}
> =20
> But I think it's a bit simpler to do
>=20
> : 	if (info->node_cache) {
> : 		leaf =3D info->node_cache;
> : 		info->node_cache =3D NULL;
> : 	} else {
> : 		if (new_leaf) {

Hmm, there be a bug there.  That should be if (*new_leaf) {

> : 			leaf =3D *new_leaf;
> : 			*new_leaf =3D NULL;
> : 		} else {
> : 			leaf =3D kmalloc(sizeof(*leaf), GFP_ATOMIC);
> : 			if (!leaf)
> : 				return -ENOMEM;
> : 		}
> : 		rb_init_node(&leaf->rb_node);
> : 		INIT_LIST_HEAD(&leaf->msg_list);
> : 		info->qsize +=3D sizeof(*leaf);
> : 	}
>=20
> and my version generates 25 bytes less text.
>=20
> But why did we need to initialise *leaf's fields if the caller passed
> us something in *new_leaf?  sys_mq_timedsend() already initialised the
> fields for us?

Because in mq_timedsend if info->node_cache was NULL, then we would
speculatively allocate new_leaf.  Then we would call
spin_lock(&info->lock);.  We could end up waiting on a different thread
that is currently getting a message, and even though info->node_cache
was NULL when we checked it before the spin lock, it might not be
afterwards (although we are guaranteed to have an entry in node_cache at
that point, so I guess in mq_timedsend we could check if node_cache was
NULL, if so move new_leaf to node_cache and initialize it, and if not
free new_leaf because we are guaranteed that we will keep node_cache
through msg_insert since we don't release the spin lock in that time.

Let me send a new version of the patch that I like more.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig50FFBC5E5877E8582EE7FE22
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPtF2BAAoJELgmozMOVy/d+7MP/30Wzc3UHmpjnQ7YWb35OO+c
nQazTWSJkz7+d2BmI8w1J/ZJGKQ4EH+9gEpSkq99nnnv7No1taGkn/zWZ0x4xX+J
mCqk+/lQbQbUK6lc+hrMklPfKoUHYI5gzbKGlC8gZfnARlupIJjhKaxIphZpVjlu
hZXm9C/kPWYREShdB7qo6JIhWAWGvnfhsdpagNTNLmD+Izh5pFMjxV24ccoyniAf
HVMeKwTUmV1IyM2ZvZj0JTtCHDX6WSvSm6tOUkbyBCNbmKj+xoJKfGElAS3weZ9e
DN6Fv3YhOpHMybsnD/0b49DseCNd/6tuInQBBA3JiuFmSRWCNhZQkcTSlwtYRj2L
thxVrHLr3LoVHH+0bhAxquwjB91FG7m8KncvrXnHUActbG1isLR+Ky5sLNw5Wjpg
YYX4421dE8az6tO/BnAEadutI5Mw6ZE1xEa5p4JY3L6LQ8VIKAr9ieWPo4fSQ1Gl
9H5cTI9j0Fi6HrGM3oDuuc3CCoOqdDdPYyfMytzEnK0Z/J3eKkY99cUjA7q59UzL
3l9rFEx0/Nu81TSuX/Z5Girc/XRxUGpM5oQ89+17ORnttdofpX0ER5Wz8F38b2YW
KJZ6XNrKRSWp5wLUBstQD9aWcdHMBGHf3ELcA4Z6DjzOSB/4AEdoDpXLVUt954VM
YYA6S9CX4CkKmQVuDFMY
=+Bep
-----END PGP SIGNATURE-----

--------------enig50FFBC5E5877E8582EE7FE22--
