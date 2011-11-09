Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1KIN2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 08:28:07 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:12601 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1KIN2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 08:28:05 -0500
X-IronPort-AV: E=Sophos;i="4.69,484,1315180800"; 
   d="scan'208";a="8840043"
Subject: Re: [Xen-devel] [PATCH 1/3] Introducing grant table V2 stucture
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "annie.li@oracle.com" <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Date: Wed, 9 Nov 2011 13:28:03 +0000
In-Reply-To: <1320826490-29362-1-git-send-email-annie.li@oracle.com>
References: <4EBA35D3.3020506@oracle.com>
	 <1320826490-29362-1-git-send-email-annie.li@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1320845283.955.131.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 08:14 +0000, annie.li@oracle.com wrote:
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 4f44b34..0d481a9 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -53,7 +53,7 @@
>  /* External tools reserve first few grant table entries. */
>  #define NR_RESERVED_ENTRIES 8
>  #define GNTTAB_LIST_END 0xffffffff
> -#define GREFS_PER_GRANT_FRAME (PAGE_SIZE / sizeof(struct grant_entry))
> +#define GREFS_PER_GRANT_FRAME (PAGE_SIZE / sizeof(struct grant_entry_v1))

Does this need to become GREFS_V1_PER... or something?

> 
>  static grant_ref_t **gnttab_list;
>  static unsigned int nr_grant_frames;
> @@ -64,7 +64,72 @@ static DEFINE_SPINLOCK(gnttab_list_lock);
>  unsigned long xen_hvm_resume_frames;
>  EXPORT_SYMBOL_GPL(xen_hvm_resume_frames);
> 
> -static struct grant_entry *shared;
> +static union {
> +       struct grant_entry_v1 *v1;
> +       void *ring_addr;
> +} shared;
> +
> +/*
> + * This function is null for grant table v1, adding it here in order to keep
> + * consistent with *_v2 interface.
> + */
> +static int gnttab_map_status_v1(unsigned int nr_gframes);
> +/*
> + * This function is null for grant table v1, adding it here in order to keep
> + * consistent with *_v2 interface.
> + */
> +static void gnttab_unmap_status_v1(void);

If you reorder the declarations of gnttab_request_version and
gnttab_(un)map_status_v1 below then you can avoid these forward
declarations.

Also I don't think the comment really adds much once you have the empty
declaration underneath (like you do below). A simple "/* Nothing to do
for v1 */" in the implementation would be sufficient.

> +
> +/*This is a structure of function pointers for grant table v1*/

and eventually v2, right? Actually I think the v1 is unnecessary. e.g.:
	/*This is a structure of function pointers for grant table*/

> +static struct {
> +       /*
> +        * Mapping a list of frames for storing grant entry status, this
> +        * mechanism can allow better synchronization using barriers. Input
> +        * parameter is frame number, returning GNTST_okay means success and
> +        * negative value means failure.
> +        */
> +       int (*_gnttab_map_status)(unsigned int);

I think you can drop the "_gnttab_" prefix from all of these, it'll be
clear from the gnttab->foo what the namespace is.

[...]
> +} gnttab_interface;
> +
> +static int grant_table_version;
> 
>  static struct gnttab_free_callback *gnttab_free_callback_list;
> 

> @@ -155,12 +229,10 @@ static void update_grant_entry(grant_ref_t ref, domid_t domid,
>          *  3. Write memory barrier (WMB).
>          *  4. Write ent->flags, inc. valid type.
>          */
> -       shared[ref].frame = frame;
> -       shared[ref].domid = domid;
> -       wmb();
> -       shared[ref].flags = flags;
> +       gnttab_interface._update_grant_entry(ref, domid, frame, flags);
>  }
> 
> +

Please avoid unrelated whitespace changes.

>  /*
>   * Public grant-issuing interface functions
>   */
> @@ -187,31 +259,40 @@ int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
>  }
>  EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
> 
> -int gnttab_query_foreign_access(grant_ref_t ref)
> +int gnttab_query_foreign_access_v1(grant_ref_t ref)

This and all the other similar functions can now be made static.

Ian.

