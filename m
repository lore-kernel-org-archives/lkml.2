Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab2LDTEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 14:04:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58220 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2LDTEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 14:04:40 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Vitaly Andrianov <vitalya@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-keystone@list.ti.com,
        Cyril Chemparathy <cyril@ti.com>
Subject: Re: [linux-keystone] [PATCH v2] drivers: cma: fix addressing on PAE machines
In-Reply-To: <50BE100E.1060007@ti.com>
Organization: http://mina86.com/
References: <1354549570-21445-1-git-send-email-vitalya@ti.com> <50BD9C45.7070501@ti.com> <xa1tsj7m3qza.fsf@mina86.com> <50BE100E.1060007@ti.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 04 Dec 2012 20:04:30 +0100
Message-ID: <xa1tsj7l3agx.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On Tuesday 04 December 2012 06:37 PM, Michal Nazarewicz wrote:
>> They are all related to the very same issue, and what the whole patch
>> does is change the type used to store physical addresses from unsigned
>> long to phys_addr_t.  This is really a single change.

On Tue, Dec 04 2012, Santosh Shilimkar wrote:
> Thanks for clarification. 64 bit alignment fix and the allocation
> range checks can be two separate fixes and that is exactly what change
> log describes.  You have a last say though :-) No problem if you want
> to commit the patch as is.

I don't have strong feelings on this one, but I feel like it's really
a single change which manifests itself in a few ways.  If this is
confusing, maybe commit message could be improved, to something like:

------------- >8 -------------------------------------------------------
drivers: cma: represent physicall addresses as phys_addr_t

This commit changes the CMA early initialisation code to use phys_addr_t
for representing physical addresses instead of unsigned long.

Without this change, among other things, dma_declare_contiguous() simply
discards any memory regions whose address is not represtible as unsigned
long.

This is a problem on 32-bit PAE machines where unsigned long is 32-bit
but physical address space is larger.
------------- 8< -------------------------------------------------------

Vitaly, if you could resend with that description, it would be awesome,
and sorry for so much trouble in what appears to be a trivial patch. :P

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQvkk+AAoJECBgQBJQdR/0HIwP/ju85z7U/DKc6973F+5dBNCm
AET3S94uYVSQZ/WA/cXP2BTnUSrEONc1dmut2tCQqj12CV5UkQ0hNl3QMKf08dCt
fUoZDTfH5E7MJWbQAe60qd6QA9PNE0fatG7IlKhsPjEmiDa7ZiCT6SBPoWlP38tB
tpaFbBmCdVXUSphN5BaAMZCkVMoz+rt6qj+S0MChvpidjg+edKwiSAY0H1ndgfkJ
eh+ZiQp6PsIKUD+xrGsrh6Dp6QX9HuGjreZtcXQzWz5W7xJx1deUrOa9jd3FrqhJ
8VfKEteWB2ZEt8NyTbduZnqSsCFJDRLP3Nf/U0QUVnK1TL+mlRSbeG100c0g9r2r
C19hiXAoAk5WfTSurZLF0vgfxOPAEleWyUHPTksGGymV2sx6G1qYc33Bo7D41FA5
ySsZg7/9CoRnBgfSP0ysWZ/WRIiXbq7EomUaxuVWD6xig+ANv25qgiL3NnkaxYhc
kw+uKkwRE8SNIWkr8SrBUC7qOLOs6VmY9JTMNVLoFtZBmETXikMhnM7nmrcsAsru
8FOPj/uvaMISAOx65GaFVN6pq0Jig+iSu8Lzf+izUpO0Pb40KsnteevjIivyXT3v
tpCan+nYTjBmGvctuzuCJOILLz6DjiylBtT6IaQzS40JbsnaTwLYggyu3ag8W5Wc
ZXJOm/0Q6Ezka+hgjfum
=GDIc
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
