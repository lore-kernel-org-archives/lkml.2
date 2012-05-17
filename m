Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967151Ab2EQPat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:30:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57641 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966713Ab2EQPar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:30:47 -0400
Message-ID: <4FB51998.2030000@gmail.com>
Date: Thu, 17 May 2012 17:30:32 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Eliminating UDF iocharset!=utf8 code (Re: [PATCH 6/8] Support
 non-BMP characters in UDF)
References: <4FB2E25E.900@gmail.com> <20120516143448.GD27661@quack.suse.cz> <4FB3C44F.6080409@gmail.com> <20120516200459.GD1687@quack.suse.cz> <4FB44856.40102@gmail.com> <4FB44AF1.4060103@gmail.com> <20120517144032.GA10676@quack.suse.cz>
In-Reply-To: <20120517144032.GA10676@quack.suse.cz>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig1FE5E920F1EDC67B4B4A5E0E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1FE5E920F1EDC67B4B4A5E0E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 17.05.2012 16:40, Jan Kara wrote:

> On Thu 17-05-12 02:48:49, Vladimir '=CF=86-coder/phcoder' Serbinenko wr=
ote:
>>
>>> I've noticed another duplication in the UDF code: there
>>> is NLS support and separate UTF-8 support. UTF-8 is support by 2 ways=

>>> actually: with -o utf8 and -o iocharset=3Dutf8 which imply different
>>> codepaths. Specific UTF-8 support is probably slightly faster by
>>> avoiding calls and basically doing everything with shifts (or can be
>>> made so with a small patch). Should I perhaps kill one of them? Is
>>> iocharset!=3Dutf8 still of any importance? I haven't seen it in ages.=

>>> Perhaps we could keep just the performant UTF-8 support and map
>>> iocharset=3Dutf8 to it and drop iocharset!=3Dutf8? iocharset!=3Dutf8 =
probably
>>> has no users anyway so keeping it we're likely to keep bugs and code
>>> duplication with no benefit.
>>>
>>
>> Linux seems to support UTF-8-only pretty strongly: http://yarchive.net=
/comp/linux/utf8.html
>> (message from Sun, 15 Feb 2004 02:42:45 GMT).
>> And I completely agree.
>> If it's ok to kill iocharset!=3Dutf8 I'll propose a series of 3 patche=
s (killing iocharset!=3Dutf8,
>> extending utf16toutf8/utf8toutf16 for unaligned input, changing UDF co=
de to use common functions)
>   Well, yes, utf8 is currently the only sane setting but that doesn't m=
ean
> someone isn't using (e.g. iso8859-2) for strange reasons...


What would be the correct behaviour if we encounter the characters which
can't be represented in the given charset? Currently the code replaces
them with question marks but since this doesn't complete round trip
successfully someone attempting to open or stat the file by name won't
be able to. So these files become pretty much "ghosts" that you see but
can't do anything with them. Hiding them altogether would lead to
situations when the disk appears empty but df shows that it's 100% full.
While encodings like iso-8859-1 are relatively straightforward, some
other (East Asian) encodings may produce '/' as part of another
character and so confuse the kernel. Such encodings are also stateful
and I'm pretty sure that current code bugs on them.
I don't know if these quirks can be used to make a program load a file
it wasn't intended to and whether it's of any security concern.
I'm aware of bash security problems with such characters when part of
Chinese character is interpreted as backtick.
I don't think that these problems can create a security hole on kernel
side, they can be used to confuse userspace but I doubt it's anything
exploitable but it's something I'd be doubtful about.

> We should
> regress in user visible functionality only for really good reasons and =
here
> I don't see a strong reason. So I'd like to keep current iocharset moun=
t
> option and make utf8 option equivalent to iocharset=3Dutf8. Since I don=
't
> think the speed benefit of dedicated CS0<->UTF8 functions is really tha=
t
> big and UDF isn't exactly a filesystem where it would matter anyway, I'=
d
> just remove those dedicated functions and use the generic ones instead.=


Ok, I'll prepare a patch.
--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig1FE5E920F1EDC67B4B4A5E0E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+1GaEACgkQNak7dOguQglXbAD/XF9EK4Yg68npO2aa326Dty3J
3CnVvx29PKZHo5bWPksA/R85O+LlPqnEExW5Cg57DswxqRjIt0e6cr6vQ70+MC6c
=mwHk
-----END PGP SIGNATURE-----

--------------enig1FE5E920F1EDC67B4B4A5E0E--
