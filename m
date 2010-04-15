Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0DOIAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 04:00:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56123 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0DOIAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:00:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cGARbjFp9GqdOF4uaa3y5ByoFxicEmHkVP+2zUVW+MZzk9j/ho+vuCXY50LgvVCbwV
         q7l5bj/yOyuh3yaTl8sE1rJYbmmjdClrYIfigIqXDftrRqfgmN8zw1RhI9cEJBx8xCG1
         cQbHvxK5O92eFcZhaiY9EKEjGrjP1Ek+3Yvx8=
MIME-Version: 1.0
In-Reply-To: <4BC6BE78.1030503@kernel.org>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <d5d70d4b57376bc89f178834cf0e424eaa681ab4.1271171877.git.minchan.kim@gmail.com>
	 <20100413154820.GC25756@csn.ul.ie> <4BC65237.5080408@kernel.org>
	 <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>
	 <4BC6BE78.1030503@kernel.org>
Date: Thu, 15 Apr 2010 17:00:15 +0900
Message-ID: <h2w28c262361004150100ne936d943u28f76c0f171d3db8@mail.gmail.com>
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 4:21 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 04/15/2010 10:31 AM, Minchan Kim wrote:
>> Hi, Tejun.
>>> This being a pretty cold path, I don't really see much benefit in
>>> converting it to alloc_pages_node_exact().  It ain't gonna make any
>>> difference.  I'd rather stay with the safer / boring one unless
>>> there's a pressing reason to convert.
>>
>> Actually, It's to weed out not-good API usage as well as some
>> performance gain.  But I don't think to need it strongly.
>> Okay. Please keep in mind about this and correct it if you confirms
>> it in future. :)
>
> Hmm... if most users are converting over to alloc_pages_node_exact(),
> I think it would be better to convert percpu too.  I thought it was a
> performance optimization (of rather silly kind too).  So, this is to
> weed out -1 node id usage?  Wouldn't it be better to update
> alloc_pages_node() such that it whines once per each caller if it's
> called with -1 node id and after updating most users convert the
> warning into WARN_ON_ONCE()?  Having two variants for this seems
> rather extreme to me.

Yes. I don't like it.
With it, someone who does care about API usage uses alloc_pages_exact_node but
someone who don't have a time or careless uses alloc_pages_node.
It would make API fragmentation and not good.
Maybe we can weed out -1 and make new API which is more clear.

* struct page *alloc_pages_any_node(gfp_t gfp_mask, unsigned int order);
* struct page *alloc_pages_exact_node(int nid, gfp_mask, unsigned int order);

So firstly we have to make sure users who use alloc_pages_node can
change alloc_pages_node with alloc_pages_exact_node.

After all of it was weed out, I will change alloc_pages_node with
alloc_pages_any_node.


-- 
Kind regards,
Minchan Kim
