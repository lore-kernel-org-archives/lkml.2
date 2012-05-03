Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2ECND7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:03:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab2ECND6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:03:58 -0400
Message-ID: <4FA28230.5080507@redhat.com>
Date: Thu, 03 May 2012 09:03:44 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        sfr@canb.auug.org.au
Subject: Re: [Patch 1/4] ipc/mqueue: improve performance of send/recv
References: <1335894655-11398-1-git-send-email-dledford@redhat.com> <5b62749cb9227016ed5965fa57b96c0dccce37a8.1335894230.git.dledford@redhat.com> <20120503092105.GA6603@mwanda>
In-Reply-To: <20120503092105.GA6603@mwanda>
X-Enigmail-Version: 1.4.1
OpenPGP: id=0E572FDD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE6D6B8EEEE76F04144C54E82"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE6D6B8EEEE76F04144C54E82
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 5/3/2012 5:21 AM, Dan Carpenter wrote:
> On Tue, May 01, 2012 at 01:50:52PM -0400, Doug Ledford wrote:
>> @@ -150,16 +241,25 @@ static struct inode *mqueue_get_inode(struct sup=
er_block *sb,
>>  			info->attr.mq_maxmsg =3D attr->mq_maxmsg;
>>  			info->attr.mq_msgsize =3D attr->mq_msgsize;
>>  		}
>> -		mq_msg_tblsz =3D info->attr.mq_maxmsg * sizeof(struct msg_msg *);
>> -		if (mq_msg_tblsz > PAGE_SIZE)
>> -			info->messages =3D vmalloc(mq_msg_tblsz);
>> -		else
>> -			info->messages =3D kmalloc(mq_msg_tblsz, GFP_KERNEL);
>> -		if (!info->messages)
>> -			goto out_inode;
>> +		/*
>> +		 * We used to allocate a static array of pointers and account
>> +		 * the size of that array as well as one msg_msg struct per
>> +		 * possible message into the queue size. That's no longer
>> +		 * accurate as the queue is now an rbtree and will grow and
>> +		 * shrink depending on usage patterns.  We can, however, still
>> +		 * account one msg_msg struct per message, but the nodes are
>> +		 * allocated depending on priority usage, and most programs
>> +		 * only use one, or a handful, of priorities.  However, since
>> +		 * this is pinned memory, we need to assume worst case, so
>> +		 * that means the min(mq_maxmsg, max_priorities) * struct
>> +		 * posix_msg_tree_node.
>> +		 */
>> +		mq_treesize =3D info->attr.mq_maxmsg * sizeof(struct msg_msg) +
>> +			min_t(unsigned int, info->attr.mq_maxmsg, MQ_PRIO_MAX) *
>> +			sizeof(struct posix_msg_tree_node);
>=20
> "info->attr.mq_maxmsg" is a long, but the min_t() truncates it to an
> unsigned int.  I'm not familiar with this code so I don't know if
> that's a problem...

It's fine.  We currently cap mq_maxmsg at a hard limit of 65536, and
MQ_PRIO_MAX is 32768, so both well within the limits of truncating a
long to unsigned int.  In order for this to ever be a problem, we would
first have to change the accounting of mq bytes in the user struct from
a 32bit type to a 64bit type.  As long as it's still 32 bits, and as
long as mq_maxmsg * (sizeof(struct msg_msg) + mq_msgsize) must fit
within that 32bit struct, we will never have an mq_maxmsg large enough
to truncate in this situation.

> We do the same thing in mqueue_evict_inode() and mq_attr_ok().

All of the math in here would need an audit if we increased the maximum
mq bytes from 32bit to 64bit.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigE6D6B8EEEE76F04144C54E82
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPooI3AAoJELgmozMOVy/dVxUQALOT1iY1Xu83MHkedcJ9i5FF
D/L7Q4VGAMUtPJNk4zMczZp/7QQQQOF5PIULXq4DLVC9CykthJjkySL1o/Fr0pwo
sj0PIrlNc+ei4dRfpwj2M5IR6vbM3Km/KEt7RZjATAdUCC0KFVx5ncqreOBT1UC4
skmAh93ABgobv0MXCV4d0pKO6m8GljJw1uRd32C0jrdANK+aL6b4pil1hvr7Va+y
3lx1+4MKUmRgTN/IkJSO8ou2YHIUW1UIpmn9ohkp/hLP2wA9Kgw+TQ2DjeMCruqv
/cDJ04Q0PFa/BrFDCCcpaOQdeShw88OanUO1/H/rsovQ7BArpHTuqIZ7kBkQ1u+G
N98S/5FRWH2+iTDa7UAZKbhspQC6X9BP6DP/nm8rzHrXvIJJh10o65sC1qtXxFRw
aGjx1BiQM4TImEppeUw0E21A/f3OfKk/WFi8WsHSOz76kb1obzt9bs0pU4beQrAX
Se/QJvG4x367EfsIb9h6tAXn3mF60/N3URsIQ7yFVYIS6KD+IXTEey8DbVVZ2vr1
DfNx9PXIOdjc0bdQdF63e54CqFYKgeoY//BxFUmEUDS+qQO4UMvCHyrCyKRIpIQl
zuxnecxEyacb9nWD23Hyt7zpNi2SQjhgd+Pkx9fX1W1w71CMSqHklEP7L4aunECh
P8HijWFLEoSBaIDyz6x0
=Qd/w
-----END PGP SIGNATURE-----

--------------enigE6D6B8EEEE76F04144C54E82--
