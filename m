Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1AaQbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:31:44 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39018 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab1AaQbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:31:41 -0500
Subject: Re: [PATCH] flex_array: Change behaviour on zero size allocations
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20110131085213.GK3070@secunet.com>
References: <20110131085213.GK3070@secunet.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Mon, 31 Jan 2011 08:31:37 -0800
Message-ID: <1296491497.7797.3792.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 09:52 +0100, Steffen Klassert wrote:
>  int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
>                         gfp_t flags)
>  {
> -       int part_nr = fa_element_to_part_nr(fa, element_nr);
> +       int part_nr;
>         struct flex_array_part *part;
>         void *dst;
> 
> +       if (!fa->element_size)
> +               return 0;
>         if (element_nr >= fa->total_nr_elements)
>                 return -ENOSPC; 

I think this still has some of the issues of the earlier patch.  The
zero-size check needs to be moved after the ->total_nr_elements check.
Otherwise, this won't produce any errors:

	fa = flex_array_alloc(0, 100, GFP_KERNEL);
	flex_array_put(fa, 1001, ptr, GFP_KERNEL);

> @@ -284,6 +297,8 @@ void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
>         int part_nr = fa_element_to_part_nr(fa, element_nr);
>         struct flex_array_part *part;
> 
> +       if (!fa->total_nr_elements || !fa->element_size)
> +               return NULL;
>         if (element_nr >= fa->total_nr_elements)
>                 return NULL;
>         if (elements_fit_in_base(fa))

Do you really need to check fa->total_nr_elements both for zero and
against element_nr?  Seems a but superfluous to me.

-- Dave

