Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab2ACAfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 19:35:45 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:49575 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2ACAfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 19:35:43 -0500
Date: Tue, 3 Jan 2012 11:35:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yongqiang Yang <xiaoqiangnk@gmail.com>, Jan Kara <jack@suse.cz>
Subject: linux-next: build failure after merge of the ext4 tree
Message-Id: <20120103113533.b2fdd68aff5b6d3c100d41b6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jan_2012_11_35_33_+1100_irc9iOhFtMonO.H7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jan_2012_11_35_33_+1100_irc9iOhFtMonO.H7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

After merging the ext4 tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/jbd2/built-in.o: In function `journal_clear_buffer_revoked_flags':
(.opd+0x5b8): multiple definition of `journal_clear_buffer_revoked_flags'
fs/jbd/built-in.o:(.opd+0x570): first defined here
fs/jbd2/built-in.o: In function `.journal_clear_buffer_revoked_flags':
(.text+0x7e80): multiple definition of `.journal_clear_buffer_revoked_flags'
fs/jbd/built-in.o:(.text+0x7970): first defined here

Caused by commit 7834c98154f1 ("jbd2: clear revoked flag on buffers
before a new transaction started") interacting with commit 8c111b3f5633
("jbd: clear revoked flag on buffers before a new transaction started")
form the ext3 tree.

I applied this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 3 Jan 2012 11:31:37 +1100
Subject: [PATCH] jbd2: sanitize a new global symbol
 (journal_clear_buffer_revoked_flags)

Fixes these build errors (when combined with the ext3 tree):

fs/jbd2/built-in.o: In function `journal_clear_buffer_revoked_flags':
(.opd+0x5b8): multiple definition of `journal_clear_buffer_revoked_flags'
fs/jbd/built-in.o:(.opd+0x570): first defined here

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/jbd2/commit.c     |    2 +-
 fs/jbd2/revoke.c     |    2 +-
 include/linux/jbd2.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 7f99e17..3f5c545 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -433,7 +433,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * Clear revoked flag to reflect there is no revoked buffers
 	 * in the next transaction which is going to be started.
 	 */
-	journal_clear_buffer_revoked_flags(journal);
+	jbd2_journal_clear_buffer_revoked_flags(journal);
=20
 	/*
 	 * Switch to a new revoke table.
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 1c36138..c99d839 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -487,7 +487,7 @@ int jbd2_journal_cancel_revoke(handle_t *handle, struct=
 journal_head *jh)
  * revoke table to reflect there is no revoked buffers in the next
  * transaction which is going to be started.
  */
-void journal_clear_buffer_revoked_flags(journal_t *journal)
+void jbd2_journal_clear_buffer_revoked_flags(journal_t *journal)
 {
 	struct jbd2_revoke_table_s *revoke =3D journal->j_revoke;
 	int i =3D 0;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 17bf089..44b8072 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1151,7 +1151,7 @@ extern int	jbd2_journal_set_revoke(journal_t *, unsig=
ned long long, tid_t);
 extern int	jbd2_journal_test_revoke(journal_t *, unsigned long long, tid_t=
);
 extern void	jbd2_journal_clear_revoke(journal_t *);
 extern void	jbd2_journal_switch_revoke_table(journal_t *journal);
-extern void	journal_clear_buffer_revoked_flags(journal_t *journal);
+extern void	jbd2_journal_clear_buffer_revoked_flags(journal_t *journal);
=20
 /*
  * The log thread user interface:
--=20
1.7.8.197.g73c6b

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__3_Jan_2012_11_35_33_+1100_irc9iOhFtMonO.H7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPAk1VAAoJEECxmPOUX5FEHtsP/3YBqW95jI6DO3A97Bv5dUfA
vx771nLikQr13xHAKYdH/kAWZi/wdi6sgjahq7X/B/h7efKYOTPGtDNGHnm/rqQv
OPaHU52F+SGIl4OMOCwHdn8aFSHl5DdoT1lMlv7xlixV2gS3+7cb1Qahl8oZfLqk
/kZpL9i+/MiCyPikjgJZ64zVL4BH5DWLJqsYlZODimriEzeRtGA2eftmm3CcpfUP
7r/F2R8DLdKjG37dHadHVqqLX8MBE823XQ/7G1kVfBBarpEw1DhDjulDo+Oyof8W
ajSWq/1Q5PWfLJrPVvQizHAvHwO5wzfzPKfFUgw3Zue/ooYIm3Yq15n4rDw8fDY8
kS1PYP9gr7JZWWeWE9A7d/vBncYgp3KMCC3KBArMFj74EPB9JDeeUZhPPX0DLZtv
LxvsNsMlGu6sxUeOhkRVE16pm8X8ClRoCyMqmcA6YJL1heu0TQLhD6ZYj843L/5c
vgac6ix09hLaKrNVVeWesUF0U1uMJ/N1BYGLTdGPotf+iwD3H8C8xge5hnq+oOjn
/XbNUVLEUzN+6qb9mBaZ3IXbMFInjWn4J0SJaJgNO9hmngP2xxiKxen17NI2gmW4
p5hD80hqqijXAb5Mca9BnG0AlaKtNFLOROwFZChQ0ZjFhhu3SjV7eAr7dMCjVwIR
c/O0BRG+ZkS4A6P57srB
=l4/H
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jan_2012_11_35_33_+1100_irc9iOhFtMonO.H7--
