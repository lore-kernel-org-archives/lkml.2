Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab1BHRDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:03:10 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56761 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab1BHRDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:03:08 -0500
Subject: Re: [PATCH v2] flex_array: Change behaviour on zero size
 allocations
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20110207122903.GO3070@secunet.com>
References: <20110207122903.GO3070@secunet.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 08 Feb 2011 09:02:41 -0800
Message-ID: <1297184561.6737.12074.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 13:29 +0100, Steffen Klassert wrote:
>  int flex_array_prealloc(struct flex_array *fa, unsigned int start,
> -                       unsigned int end, gfp_t flags)
> +                       unsigned int nr_elements, gfp_t flags)
>  {
>         int start_part;
>         int end_part;
>         int part_nr;
> +       unsigned int end;
>         struct flex_array_part *part;
> 
> -       if (start >= fa->total_nr_elements || end >= fa->total_nr_elements)
> +       if (!fa->total_nr_elements && !start)
> +               return 0;
> +       if (start >= fa->total_nr_elements)
> +               return -ENOSPC;
> +       if (!nr_elements)
> +               return 0;
> +
> +       end = start + nr_elements - 1;
> +
> +       if (end >= fa->total_nr_elements)
>                 return -ENOSPC;
> +       if (!fa->element_size)
> +               return 0; 

The rest of this patch looks good.  When you resend, you need to break
this up in to at least two patches: one to change 'end' to
'nr_elements' (or something else) and the one to handle zero-sized
elements and arrays.

I also think we need to remove the ability to do zero-sized elements.
Unless there's some new code that I'm missing, I don't see any of the
existing security policy code which would be able to do that.

-- Dave

