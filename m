Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2BTTaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:30:17 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40131 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2BTTaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:30:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.223.68 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Mon, 20 Feb 2012 11:29:43 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Kautuk Consul <consul.kautuk@gmail.com>
cc: Eric Anholt <eric@anholt.net>, Keith Packard <keithp@keithp.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] shmem.c: Compilation failure in shmem_file_setup
 for !CONFIG_MMU
In-Reply-To: <1329736292-19087-1-git-send-email-consul.kautuk@gmail.com>
Message-ID: <alpine.LSU.2.00.1202201041140.4863@eggly.anvils>
References: <1329736292-19087-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1771174992-1329766192=:4863"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1771174992-1329766192=:4863
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 20 Feb 2012, Kautuk Consul wrote:
> I disabled the CONFIG_MMU and tried to compile the kernel and got the
> following problem:
> In function =E2=80=98shmem_file_setup=E2=80=99:
> error: implicit declaration of function =E2=80=98ramfs_nommu_expand_for_m=
apping=E2=80=99
>=20
> This is because, we do not include ramfs.h for CONFIG_SHMEM.
>=20
> Included linux/ramfs.h for both CONFIG_SHMEM as well as !CONFIG_SHMEM.
>=20
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Thanks for looking into this, but I think that's the wrong fix.

We don't expect CONFIG_SHMEM=3Dy without CONFIG_MMU=3Dy, and init/Kconfig
does say config SHMEM depends on MMU.  I don't think anyone has ever
thought about the implications of CONFIG_SHMEM without CONFIG_MMU,
it just hasn't been needed.

If CONFIG_SHMEM is not set, then you should already have linux/ramfs.h
included.  So I expect it's one of those weakness-in-select issues:
something doing select SHMEM without a depends on MMU.

config DRM_I915?  i915 is happier to be served by SHMEM with its
use of swap, but by that logic i915 would want to select SWAP too.
It should be fine with ramfs: not as full an implementation, but
that's the tradeoff people choose when they ask for SHMEM off.
Is DRM_I915 any good without MMU??

When GEM went in, I remember we particularly asked for it not
to select SHMEM, but to work in the tiny !SHMEM ramfs case too.
Then I think some bug came up that made them add a select SHMEM
in a hurry.  Ah yes, bugzilla.kernel.org 14662.  Well, the
select TMPFS that was added afterwards was valid, but the
select SHMEM is not.

Things have changed again since then, since we switched i915 over
to shmem_read_mapping_page_gfp() and shmem_truncate_range(): I
believe nowadays it needs neither select SHMEM nor select TMPFS,
and I'd be very happy to see a tested patch from the i915 people
removing both those selects; but I'm unable to test it adequately
myself, so never pushed that change.

Hugh

> ---
>  mm/shmem.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 269d049..4884188 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -30,6 +30,7 @@
>  #include <linux/mm.h>
>  #include <linux/export.h>
>  #include <linux/swap.h>
> +#include <linux/ramfs.h>
> =20
>  static struct vfsmount *shm_mnt;
> =20
> @@ -2442,8 +2443,6 @@ out4:
>   * effectively equivalent, but much lighter weight.
>   */
> =20
> -#include <linux/ramfs.h>
> -
>  static struct file_system_type shmem_fs_type =3D {
>  =09.name=09=09=3D "tmpfs",
>  =09.mount=09=09=3D ramfs_mount,
> --=20
> 1.7.5.4
--8323584-1771174992-1329766192=:4863--
