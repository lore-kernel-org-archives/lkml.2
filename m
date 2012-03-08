Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab2CHRji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:39:38 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63844 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab2CHRjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:39:35 -0500
MIME-Version: 1.0
In-Reply-To: <1331226157.2585.33.camel@aks>
References: <1331226157.2585.33.camel@aks>
Date: Thu, 8 Mar 2012 12:39:34 -0500
Message-ID: <CAArOQ2Wuc6wzW_tARQFEwUDS3cTKK6rAovCB4R=FCu75nKffqw@mail.gmail.com>
Subject: Re: [RFC 2/2] kvm: guest-side changes for tmem on KVM
From: Bobby Powers <bobbypowers@gmail.com>
To: Akshay Karle <akshay.a.karle@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 12:02 PM, Akshay Karle <akshay.a.karle@gmail.com> wrote:
> From: Akshay Karle <akshay.a.karle@gmail.com>
> Subject: [RFC 2/2] kvm: guest-side changes for tmem on KVM
>
> Working in the guest:
> At the kvm guest, we add the appropriate tmem shims to intercept the
> tmem operations and then invoke the kvm hypercalls to exit to the host
> and perform these operations.
>
> Signed-off-by: Akshay Karle <akshay.a.karle@gmail.com>
>
> ---
> Diffstat for guest side changes:
>  drivers/staging/zcache/Makefile   |    2
>  drivers/staging/zcache/kvm-tmem.c |  356 ++++++++++++++++++++++++++++++++++++++
>  drivers/staging/zcache/kvm-tmem.h |   55 +++++
>  include/linux/kvm_para.h          |    1
>  4 files changed, 413 insertions(+), 1 deletion(-)
>
> diff -Napur vanilla/linux-3.1.5/drivers/staging/zcache/kvm-tmem.c linux-3.1.5//drivers/staging/zcache/kvm-tmem.c
> --- vanilla/linux-3.1.5/drivers/staging/zcache/kvm-tmem.c       1970-01-01 05:30:00.000000000 +0530
> +++ linux-3.1.5//drivers/staging/zcache/kvm-tmem.c      2012-03-05 14:16:00.892007167 +0530
> @@ -0,0 +1,356 @@
> +/*
> + * kvm implementation for transcendent memory (tmem)
> + *
> + * Copyright (C) 2009-2011 Oracle Corp.  All rights reserved.
> + * Author: Dan Magenheimer
> + *        Akshay Karle
> + *        Ashutosh Tripathi
> + *        Nishant Gulhane
> + *        Shreyas Mahure
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/pagemap.h>
> +#include <linux/module.h>
> +#include <linux/cleancache.h>
> +
> +/* temporary ifdef until include/linux/frontswap.h is upstream */
> +#ifdef CONFIG_FRONTSWAP
> +#include <linux/frontswap.h>
> +#endif
> +
> +#include "kvm-tmem.h"
> +
> +/* kvm tmem foundation ops/hypercalls */
> +
> +static inline int kvm_tmem_op(u32 tmem_cmd, u32 tmem_pool, struct tmem_oid oid,
> +       u32 index, u32 tmem_offset, u32 pfn_offset, unsigned long pfn, u32 len, uint16_t cli_id)
> +{
> +       struct tmem_ops op;
> +       int rc = 0;
> +       op.cmd = tmem_cmd;
> +       op.pool_id = tmem_pool;
> +       op.u.gen.oid[0] = oid.oid[0];
> +       op.u.gen.oid[1] = oid.oid[1];
> +       op.u.gen.oid[2] = oid.oid[2];
> +       op.u.gen.index = index;
> +       op.u.gen.tmem_offset = tmem_offset;
> +       op.u.gen.pfn_offset = pfn_offset;
> +       op.u.gen.pfn = pfn;
> +       op.u.gen.len = len;
> +       op.u.gen.cli_id = cli_id;
> +       rc = kvm_hypercall1(KVM_HC_TMEM, virt_to_phys(&op));
> +       rc = rc + 1000;
> +       return rc;
> +}
> +
> +static int kvm_tmem_new_pool(uint16_t cli_id,
> +                               u32 flags, unsigned long pagesize)
> +{
> +       struct tmem_ops op;
> +       int rc, pageshift;
> +       for (pageshift = 0; pagesize != 1; pageshift++)
> +               pagesize >>= 1;
> +       flags |= (pageshift - 12) << TMEM_POOL_PAGESIZE_SHIFT;
> +       flags |= TMEM_SPEC_VERSION << TMEM_VERSION_SHIFT;
> +       op.cmd = TMEM_NEW_POOL;
> +       op.u.new.cli_id = cli_id;
> +       op.u.new.flags = flags;
> +       rc = kvm_hypercall1(KVM_HC_TMEM, virt_to_phys(&op));
> +       rc = rc + 1000;
> +       return rc;
> +}
> +
> +/* kvm generic tmem ops */
> +
> +static int kvm_tmem_put_page(u32 pool_id, struct tmem_oid oid,
> +                            u32 index, unsigned long pfn)
> +{
> +
> +       return kvm_tmem_op(TMEM_PUT_PAGE, pool_id, oid, index,
> +               0, 0, pfn, 0, TMEM_CLI);
> +}
> +
> +static int kvm_tmem_get_page(u32 pool_id, struct tmem_oid oid,
> +                            u32 index, unsigned long pfn)
> +{
> +
> +       return kvm_tmem_op(TMEM_GET_PAGE, pool_id, oid, index,
> +               0, 0, pfn, 0, TMEM_CLI);
> +}
> +
> +static int kvm_tmem_flush_page(u32 pool_id, struct tmem_oid oid, u32 index)
> +{
> +       return kvm_tmem_op(TMEM_FLUSH_PAGE, pool_id, oid, index,
> +               0, 0, 0, 0, TMEM_CLI);
> +}
> +
> +static int kvm_tmem_flush_object(u32 pool_id, struct tmem_oid oid)
> +{
> +       return kvm_tmem_op(TMEM_FLUSH_OBJECT, pool_id, oid, 0, 0, 0, 0, 0, TMEM_CLI);
> +}
> +
> +static int kvm_tmem_destroy_pool(u32 pool_id)
> +{
> +       struct tmem_oid oid = { { 0 } };
> +
> +       return kvm_tmem_op(TMEM_DESTROY_POOL, pool_id, oid, 0, 0, 0, 0, 0, TMEM_CLI);
> +}
> +
> +static int kvm_tmem_enabled;
> +
> +static int __init enable_tmem_kvm(char *s)
> +{
> +       kvm_tmem_enabled = 1;
> +       return 1;
> +}
> +__setup("tmem", enable_tmem_kvm);
> +
> +/* cleancache ops */
> +
> +#ifdef CONFIG_CLEANCACHE
> +static void tmem_cleancache_put_page(int pool, struct cleancache_filekey key,
> +                                    pgoff_t index, struct page *page)
> +{
> +       u32 ind = (u32) index;
> +       struct tmem_oid oid = *(struct tmem_oid *)&key;
> +       unsigned long pfn = page_to_pfn(page);
> +
> +       if (pool < 0)
> +               return;
> +       if (ind != index)
> +               return;
> +       mb(); /* ensure page is quiescent; tmem may address it with an alias */
> +       (void)kvm_tmem_put_page((u32)pool, oid, ind, pfn);
> +}
> +
> +static int tmem_cleancache_get_page(int pool, struct cleancache_filekey key,
> +                                   pgoff_t index, struct page *page)
> +{
> +       u32 ind = (u32) index;
> +       struct tmem_oid oid = *(struct tmem_oid *)&key;
> +       unsigned long pfn = page_to_pfn(page);
> +       int ret;
> +
> +       /* translate return values to linux semantics */
> +       if (pool < 0)
> +               return -1;
> +       if (ind != index)
> +               return -1;
> +       ret = kvm_tmem_get_page((u32)pool, oid, ind, pfn);
> +       return ret;
> +}
> +
> +static void tmem_cleancache_flush_page(int pool, struct cleancache_filekey key,
> +                                      pgoff_t index)
> +{
> +       u32 ind = (u32) index;
> +       struct tmem_oid oid = *(struct tmem_oid *)&key;
> +
> +       if (pool < 0)
> +               return;
> +       if (ind != index)
> +               return;
> +       (void)kvm_tmem_flush_page((u32)pool, oid, ind);
> +}
> +
> +static void tmem_cleancache_flush_inode(int pool, struct cleancache_filekey key)
> +{
> +       struct tmem_oid oid = *(struct tmem_oid *)&key;
> +
> +       if (pool < 0)
> +               return;
> +       (void)kvm_tmem_flush_object((u32)pool, oid);
> +}
> +
> +static void tmem_cleancache_flush_fs(int pool)
> +{
> +       if (pool < 0)
> +               return;
> +       (void)kvm_tmem_destroy_pool((u32)pool);
> +}
> +
> +static int tmem_cleancache_init_fs(size_t pagesize)
> +{
> +       uint16_t cli_id=TMEM_CLI;
> +       return kvm_tmem_new_pool(cli_id, 0, pagesize);
> +}
> +
> +static int tmem_cleancache_init_shared_fs(char *uuid, size_t pagesize)
> +{
> +       uint16_t cli_id=TMEM_CLI;
> +       return kvm_tmem_new_pool(cli_id, TMEM_POOL_SHARED, pagesize);
> +}
> +
> +static int use_cleancache = 1;
> +
> +static int __init no_cleancache(char *s)
> +{
> +       use_cleancache = 0;
> +       return 1;
> +}
> +
> +__setup("nocleancache", no_cleancache);
> +
> +static struct cleancache_ops tmem_cleancache_ops = {
> +       .put_page = tmem_cleancache_put_page,
> +       .get_page = tmem_cleancache_get_page,
> +       .flush_page = tmem_cleancache_flush_page,
> +       .flush_inode = tmem_cleancache_flush_inode,
> +       .flush_fs = tmem_cleancache_flush_fs,
> +       .init_shared_fs = tmem_cleancache_init_shared_fs,
> +       .init_fs = tmem_cleancache_init_fs
> +};
> +#endif
> +
> +#ifdef CONFIG_FRONTSWAP
> +/* frontswap tmem operations */
> +
> +/* a single tmem poolid is used for all frontswap "types" (swapfiles) */
> +static int tmem_frontswap_poolid;
> +
> +/*
> + * Swizzling increases objects per swaptype, increasing tmem concurrency
> + * for heavy swaploads.  Later, larger nr_cpus -> larger SWIZ_BITS
> + */
> +#define SWIZ_BITS              4
> +#define SWIZ_MASK              ((1 << SWIZ_BITS) - 1)
> +#define _oswiz(_type, _ind)    ((_type << SWIZ_BITS) | (_ind & SWIZ_MASK))
> +#define iswiz(_ind)            (_ind >> SWIZ_BITS)
> +
> +static inline struct tmem_oid oswiz(unsigned type, u32 ind)
> +{
> +       struct tmem_oid oid = { .oid = { 0 } };
> +       oid.oid[0] = _oswiz(type, ind);
> +       return oid;
> +}
> +
> +/* returns 0 if the page was successfully put into frontswap, -1 if not */
> +static int tmem_frontswap_put_page(unsigned type, pgoff_t offset,
> +                                  struct page *page)
> +{
> +       u64 ind64 = (u64)offset;
> +       u32 ind = (u32)offset;
> +       unsigned long pfn = page_to_pfn(page);
> +       int pool = tmem_frontswap_poolid;
> +       int ret;
> +
> +       if (pool < 0)
> +               return -1;
> +       if (ind64 != ind)
> +               return -1;
> +       mb(); /* ensure page is quiescent; tmem may address it with an alias */
> +       ret = kvm_tmem_put_page(pool, oswiz(type, ind), iswiz(ind), pfn);
> +       /* translate kvm tmem return values to linux semantics */
> +       return ret;
> +}
> +
> +/*
> + * returns 0 if the page was successfully gotten from frontswap, -1 if
> + * was not present (should never happen!)
> + */
> +static int tmem_frontswap_get_page(unsigned type, pgoff_t offset,
> +                                  struct page *page)
> +{
> +       u64 ind64 = (u64)offset;
> +       u32 ind = (u32)offset;
> +       unsigned long pfn = page_to_pfn(page);
> +       int pool = tmem_frontswap_poolid;
> +       int ret;
> +
> +       if (pool < 0)
> +               return -1;
> +       if (ind64 != ind)
> +               return -1;
> +       ret = kvm_tmem_get_page(pool, oswiz(type, ind), iswiz(ind), pfn);
> +       /* translate kvm tmem return values to linux semantics */
> +       return ret;
> +}
> +
> +/* flush a single page from frontswap */
> +static void tmem_frontswap_flush_page(unsigned type, pgoff_t offset)
> +{
> +       u64 ind64 = (u64)offset;
> +       u32 ind = (u32)offset;
> +       int pool = tmem_frontswap_poolid;
> +
> +       if (pool < 0)
> +               return;
> +       if (ind64 != ind)
> +               return;
> +       (void) kvm_tmem_flush_page(pool, oswiz(type, ind), iswiz(ind));
> +}
> +
> +/* flush all pages from the passed swaptype */
> +static void tmem_frontswap_flush_area(unsigned type)
> +{
> +       int pool = tmem_frontswap_poolid;
> +       int ind;
> +
> +       if (pool < 0)
> +               return;
> +       for (ind = SWIZ_MASK; ind >= 0; ind--)
> +               (void)kvm_tmem_flush_object(pool, oswiz(type, ind));
> +       (void)kvm_tmem_destroy_pool((u32)pool);
> +}
> +
> +static void tmem_frontswap_init(unsigned ignored)
> +{
> +       /* a single tmem poolid is used for all frontswap "types" (swapfiles) */
> +       if (tmem_frontswap_poolid < 0)
> +               tmem_frontswap_poolid =
> +                   kvm_tmem_new_pool(TMEM_CLI, TMEM_POOL_PERSIST, PAGE_SIZE);
> +}
> +
> +static int __initdata use_frontswap = 1;
> +
> +static int __init no_frontswap(char *s)
> +{
> +       use_frontswap = 0;
> +       return 1;
> +}
> +
> +__setup("nofrontswap", no_frontswap);
> +
> +static struct frontswap_ops tmem_frontswap_ops = {
> +       .put_page = tmem_frontswap_put_page,
> +       .get_page = tmem_frontswap_get_page,
> +       .flush_page = tmem_frontswap_flush_page,
> +       .flush_area = tmem_frontswap_flush_area,
> +       .init = tmem_frontswap_init
> +};
> +#endif
> +
> +static int __init kvm_tmem_init(void)
> +{
> +#ifdef CONFIG_FRONTSWAP
> +       if (kvm_tmem_enabled && use_frontswap) {
> +               char *s = "";
> +               struct frontswap_ops old_ops =
> +                       frontswap_register_ops(&tmem_frontswap_ops);
> +
> +               tmem_frontswap_poolid = -1;
> +               if (old_ops.init != NULL)
> +                       s = " (WARNING: frontswap_ops overridden)";
> +               printk(KERN_INFO "%% frontswap enabled, RAM provided by "
> +                                "kvm Transcendent Memory\n");
> +       }
> +#endif
> +#ifdef CONFIG_CLEANCACHE
> +       BUG_ON(sizeof(struct cleancache_filekey) != sizeof(struct tmem_oid));
> +       if (kvm_tmem_enabled && use_cleancache) {
> +               char *s = "";
> +               struct cleancache_ops old_ops =
> +                       cleancache_register_ops(&tmem_cleancache_ops);
> +               if (old_ops.init_fs != NULL)
> +                       s = " (WARNING: cleancache_ops overridden)";
> +               printk(KERN_INFO "%% cleancache enabled, RAM provided by "
> +                                "kvm Transcendent Memory%s\n", s);
> +       }
> +#endif
> +       return 0;
> +}
> +
> +module_init(kvm_tmem_init)
> diff -Napur vanilla/linux-3.1.5/drivers/staging/zcache/kvm-tmem.h linux-3.1.5//drivers/staging/zcache/kvm-tmem.h
> --- vanilla/linux-3.1.5/drivers/staging/zcache/kvm-tmem.h       1970-01-01 05:30:00.000000000 +0530
> +++ linux-3.1.5//drivers/staging/zcache/kvm-tmem.h      2012-03-05 14:16:00.892007167 +0530
> @@ -0,0 +1,55 @@
> +#ifndef _TMEM_H
> +#define _TMEM_H
> +
> +#include <linux/types.h>
> +#include <linux/kvm_host.h>
> +#include <linux/kvm_types.h>
> +#include <linux/kvm_para.h>
> +#include "tmem.h"
> +
> +#define TMEM_SPEC_VERSION 1
> +#define TMEM_CLI         1
> +
> +/* Different tmem ops */
> +#define TMEM_CONTROL               0
> +#define TMEM_NEW_POOL              1
> +#define TMEM_DESTROY_POOL          2
> +#define TMEM_NEW_PAGE              3
> +#define TMEM_PUT_PAGE              4
> +#define TMEM_GET_PAGE              5
> +#define TMEM_FLUSH_PAGE            6
> +#define TMEM_FLUSH_OBJECT          7
> +#define TMEM_READ                  8
> +#define TMEM_WRITE                 9
> +#define TMEM_XCHG                 10
> +
> +/* Bits for kvm_hypercall1(TMEM_NEW_POOL) */
> +#define TMEM_POOL_PERSIST          1
> +#define TMEM_POOL_SHARED           2
> +#define TMEM_POOL_PAGESIZE_SHIFT   4
> +#define TMEM_VERSION_SHIFT        24
> +
> +/* flags for tmem_ops.new_pool */
> +#define TMEM_POOL_PERSIST          1
> +#define TMEM_POOL_SHARED           2
> +
> +struct tmem_ops {
> +        uint32_t cmd;
> +        int32_t pool_id;
> +        union {
> +                struct {  /* for cmd == TMEM_NEW_POOL */
> +                        uint16_t cli_id;
> +                        uint32_t flags;
> +                } new;
> +                struct {
> +                        uint64_t oid[3];
> +                        uint32_t index;
> +                        uint32_t tmem_offset;
> +                        uint32_t pfn_offset;
> +                        uint32_t pfn;
> +                        uint32_t len;
> +                       uint16_t cli_id;
> +                } gen;
> +        } u;
> +};
> +#endif
> diff -Napur vanilla/linux-3.1.5/drivers/staging/zcache/Makefile linux-3.1.5//drivers/staging/zcache/Makefile
> --- vanilla/linux-3.1.5/drivers/staging/zcache/Makefile 2011-12-09 22:27:05.000000000 +0530
> +++ linux-3.1.5//drivers/staging/zcache/Makefile        2012-03-05 14:16:00.892007167 +0530
> @@ -1,3 +1,3 @@
> -zcache-y       :=      zcache-main.o tmem.o
> +zcache-y       :=      zcache-main.o tmem.o kvm-tmem.o
>
>  obj-$(CONFIG_ZCACHE)   +=      zcache.o
> diff -Napur vanilla/linux-3.1.5/include/linux/kvm_para.h linux-3.1.5//include/linux/kvm_para.h
> --- vanilla/linux-3.1.5/include/linux/kvm_para.h        2011-12-09 22:27:05.000000000 +0530
> +++ linux-3.1.5//include/linux/kvm_para.h       2012-03-05 14:16:00.892007167 +0530
> @@ -19,6 +19,7 @@
>  #define KVM_HC_MMU_OP                  2
>  #define KVM_HC_FEATURES                        3
>  #define KVM_HC_PPC_MAP_MAGIC_PAGE      4
> +#define KVM_HC_TMEM                    5

Same with this change, should be in the first patch in the next
version.  Beyond that I don't have any other substantial comments yet.
 Certainly looks interesting.

>
>  /*
>  * hypercalls use architecture specific
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
