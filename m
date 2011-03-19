Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab1CSWxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 18:53:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:12719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1CSWxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 18:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xZG98016TP2bNHAZ6gzw1Fz5iHlYhJWED+lkkfI9/N61J/UG6MJwLtSgLOlzxyrSus
         W4e2EvMvksNtMdSVLKMA==
Date: Sat, 19 Mar 2011 15:52:57 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Kenny Simpson <theonetruekenny@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: remap_file_pages doesn't like MAP_ANONYMOUS (but used to?)
In-Reply-To: <11649.19421.qm@web39421.mail.mud.yahoo.com>
Message-ID: <alpine.LSU.2.00.1103191525180.1609@sister.anvils>
References: <11649.19421.qm@web39421.mail.mud.yahoo.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-707722628-1300575216=:1609"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-707722628-1300575216=:1609
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 16 Mar 2011, Kenny Simpson wrote:
> Hello,
> =A0 In older kernels (2.6.15-2.6.18?) I was able to make an anonymous map=
ping and remap part of it back over itself to create a circular buffer:
> =A0 p =3D mmap(0, sz, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,=
 -1, 0)
> =A0 remap_file_pages(p + sz/2, sz/2, 0/*prot*/, 0/*offset*/, 0/*flags*/)
>=20
> I find the same method fails with EINVAL on the remap_file_pages call in =
2.6.35/38.  Making a dummy file or shared memory object works, but seems a =
bit more messy.
>=20
> Why drop support for ANONYMOUS?  Is there another way to get the same eff=
ect?

Thanks for reporting.  It was a simple oversight: and until you came
along, nobody noticed.  Here's the patch, I'll pass it upstream shortly.

[PATCH] shmem: let shared anonymous be nonlinear again

Up to 2.6.22, you could use remap_file_pages(2) on a tmpfs file or a
shared mapping of /dev/zero or a shared anonymous mapping.  In 2.6.23
we disabled it by default, but set VM_CAN_NONLINEAR to enable it on
safe mappings.  We made sure to set it in shmem_mmap() for tmpfs files,
but missed it in shmem_zero_setup() for the others.  Fix that at last.

Reported-by: Kenny Simpson <theonetruekenny@yahoo.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- 2.6.38/mm/shmem.c=092011-03-14 18:20:32.000000000 -0700
+++ linux/mm/shmem.c=092011-03-19 15:09:26.000000000 -0700
@@ -2791,5 +2791,6 @@ int shmem_zero_setup(struct vm_area_stru
 =09=09fput(vma->vm_file);
 =09vma->vm_file =3D file;
 =09vma->vm_ops =3D &shmem_vm_ops;
+=09vma->vm_flags |=3D VM_CAN_NONLINEAR;
 =09return 0;
 }
--8323584-707722628-1300575216=:1609--
