Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1FOL2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 07:28:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1FOL2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 07:28:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jordan Crouse <jcrouse@codeaurora.org>
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous 
 =?iso-8859-1?q?Memory=09Allocator?= added
Date: Wed, 15 Jun 2011 13:27:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Zach Pfeffer <zach.pfeffer@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Daniel Stone <daniels@collabora.com>, linux-mm@kvack.org,
        Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>, linaro-mm-sig@lists.linaro.org,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-media@vger.kernel.org
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com> <201106142242.25157.arnd@arndb.de> <4DF7CC22.6050602@codeaurora.org>
In-Reply-To: <4DF7CC22.6050602@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106151327.32226.arnd@arndb.de>
X-Provags-ID: V02:K0:q0bcnSdi26L3wOxKsxNSiWhjUfryHmEyiIshwWRWdsT
 MXD+/uuSS8adNH15KfBx9o6CnVK0sSQpPJiWgZv7XhA5LbmZuG
 5Ht7tO0gIErQS610lashuqV2qnop21qYPKr88crljZFXdoijGU
 Sd7qjnFWOLkQzeImYHgar4dh3U+/tJ58kard6Rrpyn3qS8yIMV
 04qHuSC72lW9Jr+2/IdNA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 June 2011, Jordan Crouse wrote:
> 
> On 06/14/2011 02:42 PM, Arnd Bergmann wrote:
> > On Tuesday 14 June 2011 20:58:25 Zach Pfeffer wrote:
> >> I've seen this split bank allocation in Qualcomm and TI SoCs, with
> >> Samsung, that makes 3 major SoC vendors (I would be surprised if
> >> Nvidia didn't also need to do this) - so I think some configurable
> >> method to control allocations is necessarily. The chips can't do
> >> decode without it (and by can't do I mean 1080P and higher decode is
> >> not functionally useful). Far from special, this would appear to be
> >> the default.
> >
> > Thanks for the insight, that's a much better argument than 'something
> > may need it'. Are those all chips without an IOMMU or do we also
> > need to solve the IOMMU case with split bank allocation?
> 
> Yes. The IOMMU case with split bank allocation is key, especially for shared
> buffers. Consider the case where video is using a certain bank for performance
> purposes and that frame is shared with the GPU.

Could we use the non-uniform memory access (NUMA) code for this? That code
does more than what we've been talking about, and we're currently thinking
only of a degenerate case (one CPU node with multiple memory nodes), but my
feeling is that we can still build on top of it.

The NUMA code can describe relations between different areas of memory
and how they interact with devices and processes, so you can attach a
device to a specific node and have all allocations done from there.
You can also set policy in user space, e.g. to have a video decoder
process running on the bank that is not used by the GPU.

In the DMA mapping API, that would mean we add another dma_attr to
dma_alloc_* that lets you pass a node identifier.

	Arnd
