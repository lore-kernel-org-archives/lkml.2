Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab2EAULk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:11:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757956Ab2EAULj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:11:39 -0400
Message-ID: <4FA04373.6090100@redhat.com>
Date: Tue, 01 May 2012 16:11:31 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        sfr@canb.auug.org.au
Subject: Re: [Patch 3/4] ipc/mqueue: strengthen checks on mqueue creation
References: <1335894655-11398-1-git-send-email-dledford@redhat.com> <d280fa846e9093a3cc82d9e75da4bb8074c7d4c7.1335894230.git.dledford@redhat.com> <4FA04131.2040004@gmail.com>
In-Reply-To: <4FA04131.2040004@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5F5600D12C2957F965E6AD9E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5F5600D12C2957F965E6AD9E
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: quoted-printable

On 05/01/2012 04:01 PM, KOSAKI Motohiro wrote:
> (5/1/12 1:50 PM), Doug Ledford wrote:
>> We already check the mq attr struct if it's passed in, but now that th=
e
>> admin can set system wide defaults separate from maximums, it's actual=
ly
>> possible to set the defaults to something that would overflow.  So,
>> if there is no attr struct passed in to the open call, check the defau=
lt
>> values.
>>
>> While we are at it, simplify mq_attr_ok() by making it return 0 or an
>> error condition, so that way if we add more tests to it later, we have=

>> the option of what error should be returned instead of the calling
>> location having to pick a possibly inaccurate error code.
>>
>> Signed-off-by: Doug Ledford<dledford@redhat.com>
>> ---
>>   ipc/mqueue.c |   27 ++++++++++++++++++---------
>>   1 files changed, 18 insertions(+), 9 deletions(-)
>>
>> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
>> index 4b2892e..6089f73 100644
>> --- a/ipc/mqueue.c
>> +++ b/ipc/mqueue.c
>> @@ -673,27 +673,27 @@ static int mq_attr_ok(struct ipc_namespace *ipc_=
ns, struct mq_attr *attr)
>>   	int mq_treesize;
>>
>>   	if (attr->mq_maxmsg<=3D 0 || attr->mq_msgsize<=3D 0)
>> -		return 0;
>> +		return -EINVAL;
>>   	if (capable(CAP_SYS_RESOURCE)) {
>>   		if (attr->mq_maxmsg>  HARD_MSGMAX ||
>>   		    attr->mq_msgsize>  HARD_MSGSIZEMAX)
>> -			return 0;
>> +			return -EINVAL;
>>   	} else {
>>   		if (attr->mq_maxmsg>  ipc_ns->mq_msg_max ||
>>   				attr->mq_msgsize>  ipc_ns->mq_msgsize_max)
>> -			return 0;
>> +			return -EINVAL;
>>   	}
>>   	/* check for overflow */
>>   	if (attr->mq_msgsize>  ULONG_MAX/attr->mq_maxmsg)
>> -		return 0;
>> +		return -ENOMEM;
>>   	mq_treesize =3D attr->mq_maxmsg * sizeof(struct msg_msg) +
>>   		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
>>   		sizeof(struct posix_msg_tree_node);
>>   	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize +
>>   			    mq_treesize)<
>>   	(unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
>> -		return 0;
>> -	return 1;
>> +		return -ENOMEM;
>> +	return 0;
>=20
> But ENOMEM is more inaccurate. It almostly is used for kmalloc failure.=


I chose ENOMEM for that particular error because above there we have
checked the passed in arguments to make sure that they don't violate our
allowances for max message or max message size.  If we violate either of
those items, we return EINVAL.  In this case, neither of the values is
invalid, it's just that together they make an overly large allocation.
I would see that as more helpful to a programmer than EINVAL when the
values are within the maximums allowed.  At least with ENOMEM the
programmer knows they have to reduce their combined message size and
message count in order to get things working.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig5F5600D12C2957F965E6AD9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPoENzAAoJELgmozMOVy/dS4UQAJ2/PZiY+NVjgQK/ja1vOsiw
9jT4VqgsFyVMHNSJXH3QZ2ois3T+VNMPuSd2hpVLiya1S1Gv4OFF+vzbgxNCYFK3
g6IsAyg+OdsWl9UuNVEnODsYE7Q+4jjWJ+GR/d7BUjgLEDHWaXpzGm+gJk5Qsne0
nFGqNkfMq2aR1p8/Y760OuGROl2VVnQHkujecjvP9xe7Ej5yFpBCIFR8cgoPtMP8
HaDGPLuhyhpQK+QJ+LEl0csEBQX1qiTEYH1lfc38U9GXt5VuyLZeoKOxIbiZwaad
vhdJnRzeppbvNu3969leumv6KZhNYUroKWtoHG7a31Fg1UaY/4cAk2rWwpCdp0ZM
Y09NuzC3LxohO6lTEG3XHTWmBxY7elKNbMudX51+Wf8Z93bmSgmVBzEgriL4FJFt
BrxC2rt1ntsRlZdHm3FqsLmHAGGkkvXk+nyEWGBsBPYpG3Z7gS2G2uubmnGJ9Jm+
SCyg/Dcc6m4sw7R4saYJQp4+n+z+K99UoES1qO6qINqqCGvyvwzHFs/A9zU1NrWc
ot7uHmLyzIfbEGetkkOyN8eK7FHFH27GeRNpHVQ7pbzKS9eZ02/7TaV+MsEebRit
XPotjcWeeijfHvaeJ79Bb/mXjezF0PAbHPM/bocNsInuBCM8Y1O7ND58nUN4fTCB
BkDjmNccxstXGrb4Xo09
=youm
-----END PGP SIGNATURE-----

--------------enig5F5600D12C2957F965E6AD9E--
