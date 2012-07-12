Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2GLCCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:02:20 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33490 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab2GLCCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:02:18 -0400
Date: Thu, 12 Jul 2012 10:02:06 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: "Purdila, Octavian" <octavian.purdila@intel.com>
Cc: Ram Pai <linuxram@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] resource: make sure requested range intersects root range
Message-ID: <20120712020206.GC2430@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1341057657-7823-1-git-send-email-octavian.purdila@intel.com>
 <20120710143348.d977da44.akpm@linux-foundation.org>
 <20120711020902.GC13885@ram-ThinkPad-T61>
 <CAE1zotK=2nK_pRsg8C6MuGqOKZut96MgWy-ru2dkPOQQF--U3Q@mail.gmail.com>
 <20120711145412.GA2430@ram-ThinkPad-T61>
 <CAE1zotJuDn+oLcUVZ0HWeAck+UD0DiveOrOO=iYz6btdOQyD6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotJuDn+oLcUVZ0HWeAck+UD0DiveOrOO=iYz6btdOQyD6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071202-5806-0000-0000-000017357DE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 06:26:49PM +0300, Purdila, Octavian wrote:
> On Wed, Jul 11, 2012 at 5:54 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> > On Wed, Jul 11, 2012 at 02:06:10PM +0300, Purdila, Octavian wrote:
> >> On Wed, Jul 11, 2012 at 5:09 AM, Ram Pai <linuxram@us.ibm.com> wrote:
> >>
> >> >
> >> > Wait.. I am not sure this will fix the problem entirely. The above check
> >> > will handle the case where the range requested is entirey out of the
> >> > root's range.  But if the requested range overlapps that of the root
> >> > range, we will still call __reserve_region_with_split() and end up with
> >> > a recursion if there is a overflow. Wont we?
> >> >
> >>
> >> Good catch. I will fix this as well as address Andrew's and Joe's
> >> comments in a new patch. The only question is how to handle the
> >> overlap case:
> >>
> >> (a) abort the whole request or
> >>
> >> (b) try to reserve the part that overlaps (and adjust the request to
> >> avoid the overflow)
> >>
> >> I think (b) is more in line with the current implementation for reservations.
> >
> >
> > I prefer (b).  following patch should handle that.
> >
> > diff --git a/kernel/resource.c b/kernel/resource.c
> > index e1d2b8e..dd87fde 100644
> > --- a/kernel/resource.c
> > +++ b/kernel/resource.c
> > @@ -780,6 +780,10 @@ static void __init __reserve_region_with_split(struct resource *root,
> >
> >         if (conflict->start > start)
> >                 __reserve_region_with_split(root, start, conflict->start-1, name);
> > +
> > +       if (conflict->end == parent->end )
> > +               return;
> > +
> >         if (conflict->end < end)
> >                 __reserve_region_with_split(root, conflict->end+1, end, name);
> >  }
> >
> 
> I don't think this covers all cases, e.g. if root range starts
> somewhere above 0 and the request is below the root start point.

__reserve_region_with_split() is expected to reserve all available
requested range within the root's range. Correct?

If that is the case, the above patch will reserve the range from the
start of the root's range to the request's end? In other words whatever
is overlapping and available. No?

> 
> What about something like below? It is maybe too verbose, but it
> should make it easier to find the offender.
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index e1d2b8e..0d71983 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -788,8 +788,29 @@ void __init reserve_region_with_split(struct
> resource *root,
>  		resource_size_t start, resource_size_t end,
>  		const char *name)
>  {
> +	int abort = 0;
> +
>  	write_lock(&resource_lock);
> -	__reserve_region_with_split(root, start, end, name);
> +	if (!(root->start >= start && root->end >= end)) {

This is checking if the request overlapps with the beginning of 
the root's range?


> +		pr_err("Requested range (0x%llx-0x%llx) not in root %pr\n",
> +		       (unsigned long long)start, (unsigned long long)end,
> +		       root);
> +		if (start > root->end || end < root->start) {

and here it is checking if the requested range has no overlapp with the
root's range, which will always be false.


> +			abort = 1;
> +			pr_err("Unable to fix request, aborting\n");
> +		} else {
> +			if (end > root->end)
> +				end = root->end;
> +			else if (start < root->start)
> +				start = root->start;
> +			pr_err("Request trimmed to (0x%llx-0x%llx)\n",
> +			       (unsigned long long)start,
> +			       (unsigned long long)end);

Yes it is too verbose :), and feels wrong.

> +		}
> +		dump_stack();
> +	}
> +	if (!abort)
> +		__reserve_region_with_split(root, start, end, name);
>  	write_unlock(&resource_lock);
>  }

I think your original patch with Andrew's modification and my above
proposal should solve the problem. 

RP

