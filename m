Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab1BHRLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:11:08 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62358 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab1BHRLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:11:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Dbe83qBsYVa+lCm/AS91jTCcAZmmTgq5t3l0W9DfxD/oLbk4+lK67yq6OfsWHjJttE
         MUzfTpnrVlHBRb1Wsx7pITro9VD3ttBDzD8t6TGoYM05WiNLpzmTyOSPe2ST8gQV2/ct
         9FKJXPh5R+UV7U77R7gTTIEiJwOgP6XWbO4f4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <alpine.DEB.2.00.1102080954330.13649@router.home>
References: <20110131144246.dfa2abe3.sfr@canb.auug.org.au>
	<1296502339.30654.13.camel@jaguar>
	<alpine.DEB.2.00.1102030919380.6519@router.home>
	<alpine.DEB.2.00.1102080952490.13202@router.home>
	<alpine.DEB.2.00.1102080954330.13649@router.home>
Date: Tue, 8 Feb 2011 18:11:04 +0100
Message-ID: <AANLkTi=Hykzpb+oK7HOXJCCNwpgRRbsJNuXz-2Uc9WbB@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the slab tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        sandeen@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p18HBHUm015472

On Tue, Feb 8, 2011 at 4:55 PM, Christoph Lameter <cl@linux.com> wrote:
> Argh. I accidentally sent an older version of the patch. This one is the
> tested one.
>
>
> Subject: ext4: Remove use of kmem_cache_name
>
> Remove the use of kmem_cache_name from ext4. In order to do that we need to
> strdup the name of the cache passed to kmem_cache_create.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
>
> ---
>  fs/ext4/mballoc.c |   12 ++----------
>  mm/slab.c         |    7 ++++++-
>  2 files changed, 8 insertions(+), 11 deletions(-)
>
> Index: linux-2.6/fs/ext4/mballoc.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/mballoc.c    2011-02-08 09:02:40.000000000 -0600
> +++ linux-2.6/fs/ext4/mballoc.c 2011-02-08 09:11:16.000000000 -0600
> @@ -2448,15 +2448,10 @@ int ext4_mb_init(struct super_block *sb,
>                                        bb_counters[sb->s_blocksize_bits + 2]);
>
>                sprintf(name, "ext4_groupinfo_%d", sb->s_blocksize_bits);
> -               namep = kstrdup(name, GFP_KERNEL);
> -               if (!namep) {
> -                       ret = -ENOMEM;
> -                       goto out;
> -               }
>
>                /* Need to free the kmem_cache_name() when we
>                 * destroy the slab */
> -               cachep = kmem_cache_create(namep, len, 0,
> +               cachep = kmem_cache_create(name, len, 0,
>                                             SLAB_RECLAIM_ACCOUNT, NULL);
>                if (!cachep) {
>                        ret = -ENOMEM;
> @@ -2746,11 +2741,8 @@ void ext4_exit_mballoc(void)
>
>        for (i = 0; i < NR_GRPINFO_CACHES; i++) {
>                struct kmem_cache *cachep = ext4_groupinfo_caches[i];
> -               if (cachep) {
> -                       char *name = (char *)kmem_cache_name(cachep);
> +               if (cachep)
>                        kmem_cache_destroy(cachep);
> -                       kfree(name);
> -               }
>        }
>        ext4_remove_debugfs_entry();
>  }
> Index: linux-2.6/mm/slab.c
> ===================================================================
> --- linux-2.6.orig/mm/slab.c    2011-02-08 09:06:38.000000000 -0600
> +++ linux-2.6/mm/slab.c 2011-02-08 09:25:39.000000000 -0600
> @@ -2005,6 +2005,7 @@ static void __kmem_cache_destroy(struct
>                        kfree(l3);
>                }
>        }
> +       kfree(cachep->name);
>        kmem_cache_free(&cache_cache, cachep);
>  }
>
> @@ -2412,7 +2413,11 @@ kmem_cache_create (const char *name, siz
>                BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
>        }
>        cachep->ctor = ctor;
> -       cachep->name = name;
> +       if (slab_is_available())
> +               cachep->name = kstrdup(name, GFP_KERNEL);
> +       else
> +               /* Will never be freed so it does not matter */
> +               cachep->name = name;
>
>        if (setup_cpu_cache(cachep, gfp)) {
>                __kmem_cache_destroy(cachep);
>

Isn't the fs/ext4 part obsolete by Eric's "ext4: make grpinfo slab
cache names static"?
The mentionned patch is pending in ext4.git#{master, for_linus} [1].

Shouldn't this patch reduced to the mm/slab part?

- Sedat -


[1] http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commit;h=11510460562fb3fa1b061ed4d7350ccdc39a984f
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
