Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab2AEVGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:06:17 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:35021 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2AEVGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:06:15 -0500
Date: Fri, 6 Jan 2012 08:06:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yongqiang Yang <xiaoqiangnk@gmail.com>, Jan Kara <jack@suse.cz>
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-Id: <20120106080603.b4f9e591cf61204c94e84fed@canb.auug.org.au>
In-Reply-To: <20120103113533.b2fdd68aff5b6d3c100d41b6@canb.auug.org.au>
References: <20120103113533.b2fdd68aff5b6d3c100d41b6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_08_06_03_+1100_p7+pV6R9GHnI_9Od"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_08_06_03_+1100_p7+pV6R9GHnI_9Od
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Ted,

On Tue, 3 Jan 2012 11:35:33 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the ext4 tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> fs/jbd2/built-in.o: In function `journal_clear_buffer_revoked_flags':
> (.opd+0x5b8): multiple definition of `journal_clear_buffer_revoked_flags'
> fs/jbd/built-in.o:(.opd+0x570): first defined here
> fs/jbd2/built-in.o: In function `.journal_clear_buffer_revoked_flags':
> (.text+0x7e80): multiple definition of `.journal_clear_buffer_revoked_fla=
gs'
> fs/jbd/built-in.o:(.text+0x7970): first defined here
>=20
> Caused by commit 7834c98154f1 ("jbd2: clear revoked flag on buffers
> before a new transaction started") interacting with commit 8c111b3f5633
> ("jbd: clear revoked flag on buffers before a new transaction started")
> form the ext3 tree.
>=20
> I applied this merge fix patch:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 3 Jan 2012 11:31:37 +1100
> Subject: [PATCH] jbd2: sanitize a new global symbol
>  (journal_clear_buffer_revoked_flags)
>=20
> Fixes these build errors (when combined with the ext3 tree):
>=20
> fs/jbd2/built-in.o: In function `journal_clear_buffer_revoked_flags':
> (.opd+0x5b8): multiple definition of `journal_clear_buffer_revoked_flags'
> fs/jbd/built-in.o:(.opd+0x570): first defined here
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/jbd2/commit.c     |    2 +-
>  fs/jbd2/revoke.c     |    2 +-
>  include/linux/jbd2.h |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 7f99e17..3f5c545 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -433,7 +433,7 @@ void jbd2_journal_commit_transaction(journal_t *journ=
al)
>  	 * Clear revoked flag to reflect there is no revoked buffers
>  	 * in the next transaction which is going to be started.
>  	 */
> -	journal_clear_buffer_revoked_flags(journal);
> +	jbd2_journal_clear_buffer_revoked_flags(journal);
> =20
>  	/*
>  	 * Switch to a new revoke table.
> diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
> index 1c36138..c99d839 100644
> --- a/fs/jbd2/revoke.c
> +++ b/fs/jbd2/revoke.c
> @@ -487,7 +487,7 @@ int jbd2_journal_cancel_revoke(handle_t *handle, stru=
ct journal_head *jh)
>   * revoke table to reflect there is no revoked buffers in the next
>   * transaction which is going to be started.
>   */
> -void journal_clear_buffer_revoked_flags(journal_t *journal)
> +void jbd2_journal_clear_buffer_revoked_flags(journal_t *journal)
>  {
>  	struct jbd2_revoke_table_s *revoke =3D journal->j_revoke;
>  	int i =3D 0;
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 17bf089..44b8072 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1151,7 +1151,7 @@ extern int	jbd2_journal_set_revoke(journal_t *, uns=
igned long long, tid_t);
>  extern int	jbd2_journal_test_revoke(journal_t *, unsigned long long, tid=
_t);
>  extern void	jbd2_journal_clear_revoke(journal_t *);
>  extern void	jbd2_journal_switch_revoke_table(journal_t *journal);
> -extern void	journal_clear_buffer_revoked_flags(journal_t *journal);
> +extern void	jbd2_journal_clear_buffer_revoked_flags(journal_t *journal);
> =20
>  /*
>   * The log thread user interface:

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jan_2012_08_06_03_+1100_p7+pV6R9GHnI_9Od
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBhC7AAoJEECxmPOUX5FEaL4P/3NvBGmawyBTkA9siLJb+Dn5
B3vDsL3UQdh82KdjKPazFsk6MOJr1fozVhR321vKRubSrb2fnPLhfuV1/ecdLWkT
NbwaPk8jTSPu3tt4kR0+L+EvE5eqE8uK0mGROKnjdley4dn9U4K7ybizVygY3LpC
rouBqo4yXtg4lW6O5LOqz0FdcdknXGTooveTjqr16VE/IfnKZOqxNqhqmeYENqg8
YBFzkaTEjqiKV/DUrLMhapnQ72TF2Kh+z88NNjNACCvrH4e0gC3C0zKpo7VmEbxE
EOOqgXvh6IafpLXkcpNSSZReDb1OU5IA6hklwZLUmsRla5UCblTjzFU7lyDK98+q
/jWsCGrsgSV/y4AtcYsANML9ot/8r5ge1JOQ7cx4wCcjko2gDcWFTOYykq51hCg4
MjBv1g6/hY9XDnAlSLZ3Uxd0jAzCPaSeIg9tFcHueDkV25brNOoT63v0gsrTIWM1
Y5JDgGVQFm/9x9/gNiYTU1BF+NXfiUudspex0EGJnkEuRlr6pUxXcx4ZqWbIlM04
6XjS3PRt43Y+F5SY00NdPPIrL2gW8UwXftMmGNicoR2NYARZNdsLc26jnYiId7ko
BzkimDpO/SQUdDYcTU/wngEIuY7XagOHuYWgXWoD17Cwac+mn70Wg498GWBfaE3L
TkwzOFjiJKP4RHzJ0eHP
=IuiK
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_08_06_03_+1100_p7+pV6R9GHnI_9Od--
