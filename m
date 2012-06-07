Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab2FGUsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:48:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25328 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2FGUsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:48:08 -0400
MIME-Version: 1.0
Message-ID: <dfc7087d-6826-4429-8063-d47d05cd2d26@default>
Date: Thu, 7 Jun 2012 13:47:40 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: RE: [PATCH 2/2] zram: clean up handle
References: <1338881031-19662-1-git-send-email-minchan@kernel.org>
 <1338881031-19662-2-git-send-email-minchan@kernel.org>
 <4FCEE4E0.6030707@vflare.org> <4FD015FE.7070906@kernel.org>
In-Reply-To: <4FD015FE.7070906@kernel.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan@kernel.org]
> Subject: Re: [PATCH 2/2] zram: clean up handle
> 
> On 06/06/2012 02:04 PM, Nitin Gupta wrote:
> 
> > On 06/05/2012 12:23 AM, Minchan Kim wrote:
> >
> >> zram's handle variable can store handle of zsmalloc in case of
> >> compressing efficiently. Otherwise, it stores point of page descriptor.
> >> This patch clean up the mess by union struct.
> >>
> >> changelog
> >>   * from v1
> >> 	- none(new add in v2)
> >>
> >> Cc: Nitin Gupta <ngupta@vflare.org>
> >> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> >> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >> Signed-off-by: Minchan Kim <minchan@kernel.org>
> >> ---
> >>  drivers/staging/zram/zram_drv.c |   77 ++++++++++++++++++++-------------------
> >>  drivers/staging/zram/zram_drv.h |    5 ++-
> >>  2 files changed, 44 insertions(+), 38 deletions(-)
> >
> > I think page vs handle distinction was added since xvmalloc could not
> > handle full page allocation. Now that zsmalloc allows full page
> 
> I see. I didn't know that because I'm blind on xvmalloc.
> 
> > allocation, we can just use it for both cases. This would also allow
> > removing the ZRAM_UNCOMPRESSED flag. The only downside will be slightly
> > slower code path for full page allocation but this event is anyways
> > supposed to be rare, so should be fine.
> 
> Fair enough.
> It can remove many code of zram.
> Okay. Will look into that.

Nitin, can zsmalloc allow full page allocation by assigning
an actual physical pageframe (which is what zram does now)?
Or will it allocate PAGE_SIZE bytes which zsmalloc will allocate
crossing a page boundary which, presumably, will have much worse
impact on page allocator availability when these pages are
"reclaimed" via your swap notify callback.

Though this may be rare across all workloads, it may turn out
to be very common for certain workloads (e.g. if the workload
has many dirty anonymous pages that are already compressed
by userland).

It may not be worth cleaning up the code if it causes
performance issues with this case.

And anyway can zsmalloc handle and identify to the caller pages
that are both compressed and "native" (uncompressed)?  It
certainly has to handle both if you remove ZRAM_UNCOMPRESSED
as compressing some pages actually results in more than
PAGE_SIZE bytes.  So you need to record somewhere that
this "compressed page" is special and that must somehow
be communicated to the caller of your "get" routine.

(Just trying to save Minchan from removing all that code but
then needing to add it back again.)

Dan
