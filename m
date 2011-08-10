Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab1HJPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:09:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45893 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1HJPJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:09:27 -0400
MIME-Version: 1.0
Message-ID: <2f1abd2b-4c58-46b4-83bd-18c5338de28e@default>
Date: Wed, 10 Aug 2011 08:08:57 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Marcus Klemm <marcus.klemm@googlemail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, Brian King <brking@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: RE: [PATCH v2] staging: zcache: support multiple clients, prep for
 KVM and RAMster
References: <1d15f28a-56df-4cf4-9dd9-1032f211c0d0@default>
 <4E429407.8000209@linux.vnet.ibm.com 4E429945.1020008@linux.vnet.ibm.com>
In-Reply-To: <4E429945.1020008@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4E429F18.0091,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH v2] staging: zcache: support multiple clients, prep for KVM and RAMster
> 
> > This crash is hit every time a high memory page is swapped out.
> >
> > I have no solution right now other that to revert this patch and
> > restore the original signatures.

Hi Seth --

Thanks for your testing.  I haven't done much testing on 32-bit.

> Sorry for the noise, but I noticed right after I sent this that
> the tmem layer doesn't DO anything with the data parameter. So
> a possible solution is to just pass the page pointer instead of
> the virtual address.  After all, pointers are pointers.

Yes, this looks like a good patch.

> --- a/drivers/staging/zcache/zcache.c
> +++ b/drivers/staging/zcache/zcache.c
> @@ -1153,7 +1153,7 @@ static void *zcache_pampd_create(char *data, size_t size,
>         size_t clen;
>         int ret;
>         unsigned long count;
> -       struct page *page = virt_to_page(data);
> +       struct page *page = (struct page *)(data);
>         struct zcache_client *cli = pool->client;
>         uint16_t client_id = get_client_id_from_client(cli);
>         unsigned long zv_mean_zsize;
> @@ -1220,7 +1220,7 @@ static int zcache_pampd_get_data(char *data, size_t *bufsi
>         int ret = 0;
> 
>         BUG_ON(is_ephemeral(pool));
> -       zv_decompress(virt_to_page(data), pampd);
> +       zv_decompress((struct page *)(data), pampd);
>         return ret;
>  }
> 
> @@ -1532,7 +1532,7 @@ static int zcache_put_page(int cli_id, int pool_id, struct
>                 goto out;
>         if (!zcache_freeze && zcache_do_preload(pool) == 0) {
>                 /* preload does preempt_disable on success */
> -               ret = tmem_put(pool, oidp, index, page_address(page),
> +               ret = tmem_put(pool, oidp, index, (char *)(page),
>                                 PAGE_SIZE, 0, is_ephemeral(pool));
>                 if (ret < 0) {
>                         if (is_ephemeral(pool))
> @@ -1565,7 +1565,7 @@ static int zcache_get_page(int cli_id, int pool_id, struct
>         pool = zcache_get_pool_by_id(cli_id, pool_id);
>         if (likely(pool != NULL)) {
>                 if (atomic_read(&pool->obj_count) > 0)
> -                       ret = tmem_get(pool, oidp, index, page_address(page),
> +                       ret = tmem_get(pool, oidp, index, (char *)(page),
>                                         &size, 0, is_ephemeral(pool));
>                 zcache_put_pool(pool);
>         }
> 
> I tested this and it works.
> 
> Dan, does this mess anything else up?

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

> > What was the rationale for the signature changes?
> > Seth

The change on the tmem side allows tmem to handle pre-compressed pages,
which is useful to RAMster and possibly for KVM.  The new "raw"
parameter identifies that case, but for zcache "raw" is always zero so
your solution looks fine.

Seth, could you submit an "official" patch (i.e. proper subject field,
signed-off-by) and I will ack that and ask GregKH to queue it up for
a 3.1-rc?

Subject something like: staging: zcache: fix highmem crash on 32-bit

Thanks,
Dan
