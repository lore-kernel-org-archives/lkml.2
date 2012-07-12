Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab2GLI4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:56:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39295 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab2GLI4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:56:41 -0400
Date: Thu, 12 Jul 2012 16:56:31 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: "Purdila, Octavian" <octavian.purdila@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] resource: make sure requested range intersects root range
Message-ID: <20120712085631.GD2430@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1341057657-7823-1-git-send-email-octavian.purdila@intel.com>
 <20120710143348.d977da44.akpm@linux-foundation.org>
 <20120711020902.GC13885@ram-ThinkPad-T61>
 <CAE1zotK=2nK_pRsg8C6MuGqOKZut96MgWy-ru2dkPOQQF--U3Q@mail.gmail.com>
 <20120711145412.GA2430@ram-ThinkPad-T61>
 <CAE1zotJuDn+oLcUVZ0HWeAck+UD0DiveOrOO=iYz6btdOQyD6Q@mail.gmail.com>
 <20120712020206.GC2430@ram-ThinkPad-T61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712020206.GC2430@ram-ThinkPad-T61>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071208-5806-0000-0000-0000173711A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 10:02:06AM +0800, Ram Pai wrote:
> On Wed, Jul 11, 2012 at 06:26:49PM +0300, Purdila, Octavian wrote:
> > On Wed, Jul 11, 2012 at 5:54 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> > > On Wed, Jul 11, 2012 at 02:06:10PM +0300, Purdila, Octavian wrote:
> > >> On Wed, Jul 11, 2012 at 5:09 AM, Ram Pai <linuxram@us.ibm.com> wrote:
> > >>
> > >> >
> > >> > Wait.. I am not sure this will fix the problem entirely. The above check
> > >> > will handle the case where the range requested is entirey out of the
> > >> > root's range.  But if the requested range overlapps that of the root
> > >> > range, we will still call __reserve_region_with_split() and end up with
> > >> > a recursion if there is a overflow. Wont we?
> > >> >
> > >>
> > >> Good catch. I will fix this as well as address Andrew's and Joe's
> > >> comments in a new patch. The only question is how to handle the
> > >> overlap case:
> > >>
> > >> (a) abort the whole request or
> > >>
> > >> (b) try to reserve the part that overlaps (and adjust the request to
> > >> avoid the overflow)
> > >>
> > >> I think (b) is more in line with the current implementation for reservations.
> > >
> > >
> > > I prefer (b).  following patch should handle that.
> > >
> > > diff --git a/kernel/resource.c b/kernel/resource.c
> > > index e1d2b8e..dd87fde 100644
> > > --- a/kernel/resource.c
> > > +++ b/kernel/resource.c
> > > @@ -780,6 +780,10 @@ static void __init __reserve_region_with_split(struct resource *root,
> > >
> > >         if (conflict->start > start)
> > >                 __reserve_region_with_split(root, start, conflict->start-1, name);
> > > +
> > > +       if (conflict->end == parent->end )
> > > +               return;
> > > +
> > >         if (conflict->end < end)
> > >                 __reserve_region_with_split(root, conflict->end+1, end, name);
> > >  }
> > >
> > 
> > I don't think this covers all cases, e.g. if root range starts
> > somewhere above 0 and the request is below the root start point.
> 

Ok. I see your point.  Here is a proposal that incoporates the best of all 
the proposals till now..


diff --git a/kernel/resource.c b/kernel/resource.c
index e1d2b8e..c6f4958 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -789,7 +789,19 @@ void __init reserve_region_with_split(struct resource *root,
 		const char *name)
 {
 	write_lock(&resource_lock);
-	__reserve_region_with_split(root, start, end, name);
+	if (start > root->end || end < root->start) {
+ 		pr_err("Requested range (0x%llx-0x%llx) not in root range (0x%llx-0x%llx)\n",
+ 		       (unsigned long long)start, (unsigned long long)end,
+ 		       (unsigned long long)root->start,
+ 		       (unsigned long long)root->end);
+		dump_stack();
+	} else {
+		if (start < root->start)
+			start = root->start;
+		if (end > root->end)
+			end = root->end;
+ 		__reserve_region_with_split(root, start, end, name);
+	}
 	write_unlock(&resource_lock);
 }
 

Offcourse; it does not warn when the request is partially out of root's range.
But that should be ok, because its still a valid request.
RP

