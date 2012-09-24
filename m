Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab2IXLlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:41:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41381 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab2IXLlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:41:18 -0400
Date: Mon, 24 Sep 2012 21:41:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Moody <pmoody@google.com>
Subject: linux-next: manual merge of the userns tree with the security tree
Message-Id: <20120924214116.211935861448f95b82f7f722@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_21_41_16_+1000__4imXXQe./5WVn86"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_21_41_16_+1000__4imXXQe./5WVn86
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
kernel/auditsc.c between commit e23eb920b0f3 ("audit: export
audit_log_task_info") from the security tree and commits e1760bd5ffae
("userns: Convert the audit loginuid  to be a kuid") and cca080d9b622
("userns: Convert audit to work with user namespaces enabled") from the
userns tree.

I fixed it up (I think - see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/auditsc.c
index 37f52f2,ff4798f..0000000
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@@ -1160,32 -1151,8 +1152,38 @@@ void audit_log_task_info(struct audit_b
  	char name[sizeof(tsk->comm)];
  	struct mm_struct *mm =3D tsk->mm;
  	struct vm_area_struct *vma;
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
- 			 tsk->loginuid, cred->uid, cred->gid,
- 			 cred->euid, cred->suid, cred->fsuid,
- 			 cred->egid, cred->sgid, cred->fsgid,
++			 from_kuid(&init_user_ns, tsk->loginuid),
++			 from_kuid(&init_user_ns, context->uid),
++			 from_kgid(&init_user_ns, context->gid),
++			 from_kuid(&init_user_ns, context->euid),
++			 from_kuid(&init_user_ns, context->suid),
++			 from_kuid(&init_user_ns, context->fsuid),
++			 from_kgid(&init_user_ns, context->egid),
++			 from_kgid(&init_user_ns, context->sgid),
++			 from_kgid(&init_user_ns, context->fsgid),
 +			 tsk->sessionid, tty);
 =20
  	get_task_comm(name, tsk);
  	audit_log_format(ab, " comm=3D");
@@@ -1208,10 -1175,8 +1206,10 @@@
  	audit_log_task_context(ab);
  }
 =20
 +EXPORT_SYMBOL(audit_log_task_info);
 +
  static int audit_log_pid_context(struct audit_context *context, pid_t pid,
- 				 uid_t auid, uid_t uid, unsigned int sessionid,
+ 				 kuid_t auid, kuid_t uid, unsigned int sessionid,
  				 u32 sid, char *comm)
  {
  	struct audit_buffer *ab;

--Signature=_Mon__24_Sep_2012_21_41_16_+1000__4imXXQe./5WVn86
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJQYEbcAAoJEECxmPOUX5FEBOoP92n7m0NaU8GD51FBSayDGgbL
Id3hWdV9yANn12xPGmnVCi5DX9MMutYU0viYdzM9QXU7SIgdnS61lePCKodz7d06
kUfDI1hOUAiin49Ye2FtaQT4rO+LAT2jdr09KewlfnU1K6U0dFtzdqDawQdal9oC
TQkM161Jdk6I027Ms2pzUZ3nbUCLmvvW1EIkMj0TFe07wTR7Q0n485/EeeK4n/E9
xgSKfTnC5CCfUefCHhse8fYlEiJkFiKFLiFB8tz3etRTO6IL8BpzDd9vLtICkSKM
RsUPOcH9dET0N6Eyjw4/yaJiqvwLA7/WGKTSn2HvN5xdFasjwtjtPhNAsFZ+NUVS
CIxmT72slQbr5cw/+ejVoNdXYGlmRkQrIhEfWbrEyyvccWmu+uZJ3wn5w15DND5e
EFwuiTWIWUn7o074ILY8C2eKmSow1TDcmv7THe6mBkm/qjzTCH2NOiCHREd4EcQt
G/Z0zB6YPqThNvR2npU/TsJFOwYv4Fk+3ZshCaPW/vo/8Crg55YkVbuh1UZ6+R6S
oj2aOhl8m7b4azsRPRkEc884KE6A2ghXmHdyoAr0GP/dStEsmmnzGZKd6nhpmwvt
OfOgpegkwWQT6q1JlvC8V27PWf8DzeVRt7bqwyqFRKY5R0MLUjM+vkCV/UZHO87j
5dvwMqUD2sE3sSB8SeA=
=Bkox
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_21_41_16_+1000__4imXXQe./5WVn86--
