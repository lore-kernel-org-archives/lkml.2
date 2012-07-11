Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab2GKP04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:26:56 -0400
Received: from mga12.intel.com ([143.182.124.36]:46701 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932835Ab2GKP0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:26:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120711145412.GA2430@ram-ThinkPad-T61>
References: <1341057657-7823-1-git-send-email-octavian.purdila@intel.com>
	<20120710143348.d977da44.akpm@linux-foundation.org>
	<20120711020902.GC13885@ram-ThinkPad-T61>
	<CAE1zotK=2nK_pRsg8C6MuGqOKZut96MgWy-ru2dkPOQQF--U3Q@mail.gmail.com>
	<20120711145412.GA2430@ram-ThinkPad-T61>
Date: Wed, 11 Jul 2012 18:26:49 +0300
Message-ID: <CAE1zotJuDn+oLcUVZ0HWeAck+UD0DiveOrOO=iYz6btdOQyD6Q@mail.gmail.com>
Subject: Re: [PATCH] resource: make sure requested range intersects root range
From: "Purdila, Octavian" <octavian.purdila@intel.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 5:54 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> On Wed, Jul 11, 2012 at 02:06:10PM +0300, Purdila, Octavian wrote:
>> On Wed, Jul 11, 2012 at 5:09 AM, Ram Pai <linuxram@us.ibm.com> wrote:
>>
>> >
>> > Wait.. I am not sure this will fix the problem entirely. The above check
>> > will handle the case where the range requested is entirey out of the
>> > root's range.  But if the requested range overlapps that of the root
>> > range, we will still call __reserve_region_with_split() and end up with
>> > a recursion if there is a overflow. Wont we?
>> >
>>
>> Good catch. I will fix this as well as address Andrew's and Joe's
>> comments in a new patch. The only question is how to handle the
>> overlap case:
>>
>> (a) abort the whole request or
>>
>> (b) try to reserve the part that overlaps (and adjust the request to
>> avoid the overflow)
>>
>> I think (b) is more in line with the current implementation for reservations.
>
>
> I prefer (b).  following patch should handle that.
>
> diff --git a/kernel/resource.c b/kernel/resource.c
> index e1d2b8e..dd87fde 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -780,6 +780,10 @@ static void __init __reserve_region_with_split(struct resource *root,
>
>         if (conflict->start > start)
>                 __reserve_region_with_split(root, start, conflict->start-1, name);
> +
> +       if (conflict->end == parent->end )
> +               return;
> +
>         if (conflict->end < end)
>                 __reserve_region_with_split(root, conflict->end+1, end, name);
>  }
>

I don't think this covers all cases, e.g. if root range starts
somewhere above 0 and the request is below the root start point.

What about something like below? It is maybe too verbose, but it
should make it easier to find the offender.

diff --git a/kernel/resource.c b/kernel/resource.c
index e1d2b8e..0d71983 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -788,8 +788,29 @@ void __init reserve_region_with_split(struct
resource *root,
 		resource_size_t start, resource_size_t end,
 		const char *name)
 {
+	int abort = 0;
+
 	write_lock(&resource_lock);
-	__reserve_region_with_split(root, start, end, name);
+	if (!(root->start >= start && root->end >= end)) {
+		pr_err("Requested range (0x%llx-0x%llx) not in root %pr\n",
+		       (unsigned long long)start, (unsigned long long)end,
+		       root);
+		if (start > root->end || end < root->start) {
+			abort = 1;
+			pr_err("Unable to fix request, aborting\n");
+		} else {
+			if (end > root->end)
+				end = root->end;
+			else if (start < root->start)
+				start = root->start;
+			pr_err("Request trimmed to (0x%llx-0x%llx)\n",
+			       (unsigned long long)start,
+			       (unsigned long long)end);
+		}
+		dump_stack();
+	}
+	if (!abort)
+		__reserve_region_with_split(root, start, end, name);
 	write_unlock(&resource_lock);
 }
