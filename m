Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab1I3K5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 06:57:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab1I3K5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 06:57:02 -0400
Message-ID: <4E85A074.6060201@xsintricity.com>
Date: Fri, 30 Sep 2011 06:56:52 -0400
From: Doug Ledford <dledford@xsintricity.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Fix up return value from mq_open()
References: <4E85263D.3030905@xsintricity.com> <4E856476.6060808@suse.cz>
In-Reply-To: <4E856476.6060808@suse.cz>
X-Enigmail-Version: 1.3.2
OpenPGP: id=D30533DF
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8D16CBEF2D1F375C11310424"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8D16CBEF2D1F375C11310424
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/30/2011 2:40 AM, Jiri Slaby wrote:
> On 09/30/2011 04:15 AM, Doug Ledford wrote:
>> Commit d40dcdb ipc/mqueue.c: fix mq_open() return value
>> changed the return value for mq_open() to return
>>
>> EMFILE - The process already has the maximum number of files and
>>                message queues open.
>>
>> instead of
>>
>> ENOMEM - Insufficient memory.
>>
>> While the portion of d40dcdb that introduced using ERR_PTR() to
>> propagate the condition were helpful, the change to the type of error
>> was not.  The specific test that was failing was a memory space test.
>> It can fail if there are too many message queues open and this one wou=
ld
>> cause us to exceed the tasks counter for memory bytes capacity (aka, i=
nt
>> wrap) or it can fail if the total number of bytes already allocated pl=
us
>> this allocation will exceed the user's RLIMIT for POSIX message queues=
=2E
>=20
> Yes, then it should not definitely return ENOMEM, right? You exceeded a=

> limit, not ran out of memory. At least for the latter case.

I would prefer another return myself, but there doesn't seem to be one.
 I had originally toyed with the idea of returning EPERM because you
don't have permissions to exceed the limit, but that's usually for file
permissions so I decided that would be confusing.  In the end, I stuck
with ENOMEM because that's what you would get if the ulimit for memory
was set low and you tried to exceed it.  In theory, ENOMEM means out of
memory in the system, in practice it's also used for memory consumption
in excess of limits.

>>  However, depending on the values passed in via an attribute struct,
>> this could happen on the 1st file or the 100th file. There is no direc=
t
>> relationship to file count in this test.  There is only a direct
>> correlation to memory usage.  Therefore return the code to giving ENOM=
EM
>> instead of EMFILE.
> ...
>> commit b80e4058e2b4234fb33a9fd84b4ce288e8ba65cb
>> Author: Doug Ledford <dledford@redhat.com>
>> Date:   Thu Sep 29 19:02:47 2011 -0400
>>
>>     ipc/mqueue: make the error returns match the conditions
>>    =20
>>     We should not return -EMFILE when the problem is memory usage.
>=20
> Sorry, I still don't udnerstand, how this test:
>   u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)
> is about running out of memory.

Type ulimit -a, you'll see that RLIMIT_MSGQUEUE is specifically for the
number of bytes of memory consumed by POSIX message queues as reported
by bash anyway.  That's memory.  And it's being compared against the
total amount of memory consumed in bytes after the allocation, not
against the number of queues created.

> I see only a test for exceeding some
> quota. Should this be changed, change it to something like ENOSPC.

Or fix the man page...

Your original quote about ENOMEM was from the man page, just update it
to read something like:

ENOMEM - Insufficient memory.  The application has tried to open a POSIX
message queue and there is either A) insufficient memory in the system
to create the queue or B) the application has exceeded the user specific
RLIMIT for the number of message queue bytes allocation to the
application or C) the application has run into the linux implementation
specific limit of 2GB of POSIX message queue bytes per application
across all open message queues.

>> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
>> index 0474ddb..3e53604 100644
>> --- a/ipc/mqueue.c
>> +++ b/ipc/mqueue.c
>> @@ -165,7 +165,7 @@ static struct inode *mqueue_get_inode(struct super=
_block *sb,
>>  		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
>>  			spin_unlock(&mq_lock);
>>  			/* mqueue_evict_inode() releases info->messages */
>> -			ret =3D -EMFILE;
>> +			ret =3D -ENOMEM;
>=20
> The code now looks like:
> int ret =3D -ENOMEM;
> ...
> if (sth)
>   ret =3D -ENOMEM;
> ...
> return ret;
>=20
> which is not good.

I agree, but I left it because we hadn't heard from you yet and if it
needed to be set to something other than ENOMEM it would be easy to do
if the infrastructure for supporting it had not been ripped out already.


--=20
Doug Ledford <dledford@xsintricity.com>
              GPG KeyID: D30533DF



--------------enig8D16CBEF2D1F375C11310424
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6FoHoACgkQBJO4D9MFM9+0SQCcDLPqRmnd7J89DIOcfNYu5hvi
OKsAoJwh5qp7Id25V4WLgoc700fxcfMk
=VPOK
-----END PGP SIGNATURE-----

--------------enig8D16CBEF2D1F375C11310424--
