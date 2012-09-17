Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2IQKpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:45:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45795 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2IQKpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:45:50 -0400
Date: Mon, 17 Sep 2012 20:45:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, Peter Moody <pmoody@google.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: linux-next: manual merge of the akpm tree with the security tree
Message-Id: <20120917204548.569b1095b26b98b88f768ee5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_20_45_48_+1000_r=ptKes+oigpDSkc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_20_45_48_+1000_r=ptKes+oigpDSkc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/audit.h between commit e23eb920b0f3 ("audit: export
audit_log_task_info") from the security tree and commit "mm: use
mm->exe_file instead of first VM_EXECUTABLE vma->vm_file" from the akpm
tree.

I fixed it up (I hope - see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/auditsc.c
index 37f52f2,31cf885..0000000
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@@ -1154,38 -1154,12 +1154,37 @@@ error_path
 =20
  EXPORT_SYMBOL(audit_log_task_context);
 =20
 -static void audit_log_task_info(struct audit_buffer *ab, struct task_stru=
ct *tsk)
 +void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
  {
 +	const struct cred *cred;
  	char name[sizeof(tsk->comm)];
  	struct mm_struct *mm =3D tsk->mm;
- 	struct vm_area_struct *vma;
 +	char *tty;
 +
 +	if (!ab)
 +		return;
 =20
  	/* tsk =3D=3D current */
 +	cred =3D current_cred();
 +
 +	spin_lock_irq(&tsk->sighand->siglock);
 +	if (tsk->signal && tsk->signal->tty && tsk->signal->tty->name)
 +		tty =3D tsk->signal->tty->name;
 +	else
 +		tty =3D "(none)";
 +	spin_unlock_irq(&tsk->sighand->siglock);
 +
 +
 +	audit_log_format(ab,
 +			 " ppid=3D%ld pid=3D%d auid=3D%u uid=3D%u gid=3D%u"
 +			 " euid=3D%u suid=3D%u fsuid=3D%u"
 +			 " egid=3D%u sgid=3D%u fsgid=3D%u ses=3D%u tty=3D%s",
 +			 sys_getppid(),
 +			 tsk->pid,
 +			 tsk->loginuid, cred->uid, cred->gid,
 +			 cred->euid, cred->suid, cred->fsuid,
 +			 cred->egid, cred->sgid, cred->fsgid,
 +			 tsk->sessionid, tty);
 =20
  	get_task_comm(name, tsk);
  	audit_log_format(ab, " comm=3D");

--Signature=_Mon__17_Sep_2012_20_45_48_+1000_r=ptKes+oigpDSkc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVv9cAAoJEECxmPOUX5FE3EQP/1JdWpVWOlClzd82zCHIhU73
SyiROlYMhgiNYmajfMR/f1LeQduLiAn76i43SoZObbQbiTZrBl9E5t4nWlA7BbAs
Mj5HQEibIpfkY/1bS3V6M+sMyMQDPEljUlOBOJP85ftw9rqPuloZZ4FJJVnPWTKY
WmraF0ZDaMQ1MYw2Ac0e56eaHiuYUgSKfPFiXrTwf6buMYewaAM+BMyV/2ETm1NG
5ApSFpC/xs4FrklLdQgV0MUH+mYMMoyxmFDSUZyl4KLf2I4qfz1lYSo5rFfV4rCH
M+0QiQKr5jFy2j3rTD20o5TWJR1CU/b7Km9Qt8tPyxl+pBv/trTAC8ZNR8ir7zhS
kynxj6Bz73dnDRi95NWiwlN3KA2ILOvdYCsu1wYNlV0SayUZ3MPQjUJ33bFZ8hED
fOUb98F6q4Z+0M/uBiq6YaaQoLiqY4Qrc+0xlVBcYaUNJ34vdVyKFYMWaG31CQL9
Ka9cRWdHnEh3gSARnEtnoVsa3BPDv9yCwgFdCv6wWu5Yl2SkQy0JPoAZ86cwoEDY
QajaUrFKndeK1XRJ8Ns4wEGMs5ReCuqKE/2uipaPVJIbijtDVPrY1QfiJ+XAlXFt
SbudrlcjfA2mUuQNSLAYBFWhsXfKWor5Wu/dYIdg0eKeGScwO0RIplDHjAysON7N
bsK2CLQeW+VathgXdnIv
=yXPJ
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_20_45_48_+1000_r=ptKes+oigpDSkc--
