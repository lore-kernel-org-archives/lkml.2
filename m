Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2GKBZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:25:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48595 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753326Ab2GKBZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:25:08 -0400
Message-ID: <1341969908.13724.33.camel@joe2Laptop>
Subject: Re: [PATCH] resource: make sure requested range intersects root
 range
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Tue, 10 Jul 2012 18:25:08 -0700
In-Reply-To: <20120710143348.d977da44.akpm@linux-foundation.org>
References: <1341057657-7823-1-git-send-email-octavian.purdila@intel.com>
	 <20120710143348.d977da44.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 14:33 -0700, Andrew Morton wrote:
> On Sat, 30 Jun 2012 15:00:57 +0300
> Octavian Purdila <octavian.purdila@intel.com> wrote:
> 
> > When the requested and root ranges do not intersect the logic in
> > __reserve_region_with_split will cause an infinite recursion which
> > will overflow the stack as seen in the warning bellow.
> > 
> > This particular stack overflow was caused by requesting the
> > (100000000-107ffffff) range while the root range was (0-ffffffff). In
> > this case __request_resource would return the whole root range as
> > conflict range (i.e. 0-ffffffff). Then, the logic in
> > __reserve_region_with_split would continue the recursion requesting
> > the new range as (conflict->end+1, end) which incidentally in this
> > case equals the originally requested range.
> > 
> > This patch aborts looking for a usable range when the requested one is
> > completely outside the root range to avoid the infinite recursion, and
> > since this indicates a problem in the layers above, it also prints an
> > error message indicating the requested and root range in order to make
> > the problem more easily traceable.
> 
> I think we should also emit a stack trace so the faulty caller can be
> pinpointed.
> 
> > ...
> >
> > --- a/kernel/resource.c
> > +++ b/kernel/resource.c
> > @@ -789,7 +789,13 @@ void __init reserve_region_with_split(struct resource *root,
> >  		const char *name)
> >  {
> >  	write_lock(&resource_lock);
> > -	__reserve_region_with_split(root, start, end, name);
> > +	if (start > root->end || end < root->start)
> > +		pr_err("Requested range (0x%llx-0x%llx) not in root range (0x%llx-0x%llx)\n",
> > +		       (unsigned long long)start, (unsigned long long)end,
> > +		       (unsigned long long)root->start,
> > +		       (unsigned long long)root->end);
> > +	else
> > +		__reserve_region_with_split(root, start, end, name);
> >  	write_unlock(&resource_lock);
> >  }
> 
> The fancy way of doing that is
> 
> 	if (!WARN(start > root->end || end < root->start),
> 		  "Requested range (0x%llx-0x%llx) not in root range (0x%llx-0x%llx)\n",
> 		       (unsigned long long)start, (unsigned long long)end,
> 		       (unsigned long long)root->start,
> 		       (unsigned long long)root->end)
> 		__reserve_region_with_split(root, start, end, name);
> 
> but that's quite the eyesore.  How about doing it the simple way?
> 
> --- a/kernel/resource.c~resource-make-sure-requested-range-intersects-root-range-fix
> +++ a/kernel/resource.c
> @@ -792,13 +792,15 @@ void __init reserve_region_with_split(st
>  		const char *name)
>  {
>  	write_lock(&resource_lock);
> -	if (start > root->end || end < root->start)
> +	if (start > root->end || end < root->start) {
>  		pr_err("Requested range (0x%llx-0x%llx) not in root range (0x%llx-0x%llx)\n",

Maybe use %pr?

		pr_err("Requested range [0x%llx-0x%llx] not in root %pr\n"
		       (unsigned long long)start, (unsigned long long)end,
		       root);




