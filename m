Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2GaVOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 17:14:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39740 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2GaVOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 17:14:06 -0400
MIME-Version: 1.0
Message-ID: <b9bee363-321e-409a-bc8e-65ffed8a1dc5@default>
Date: Tue, 31 Jul 2012 14:13:40 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: RE: [RFC/PATCH] zcache/ramster rewrite and promotion
References: <c31aaed4-9d50-4cdf-b794-367fc5850483@default>
 <CAOJsxLEhW=b3En737d5751xufW2BLehPc2ZGGG1NEtRVSo3=jg@mail.gmail.com>
In-Reply-To: <CAOJsxLEhW=b3En737d5751xufW2BLehPc2ZGGG1NEtRVSo3=jg@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg [mailto:penberg@kernel.org]
> Sent: Tuesday, July 31, 2012 2:54 PM
> 
> On Tue, Jul 31, 2012 at 11:18 PM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> > diffstat vs 3.5:
> >  drivers/staging/ramster/Kconfig       |    2
> >  drivers/staging/ramster/Makefile      |    2
> >  drivers/staging/zcache/Kconfig        |    2
> >  drivers/staging/zcache/Makefile       |    2
> >  mm/Kconfig                            |    2
> >  mm/Makefile                           |    4
> >  mm/tmem/Kconfig                       |   33
> >  mm/tmem/Makefile                      |    5
> >  mm/tmem/tmem.c                        |  894 +++++++++++++
> >  mm/tmem/tmem.h                        |  259 +++
> >  mm/tmem/zbud.c                        | 1060 +++++++++++++++
> >  mm/tmem/zbud.h                        |   33
> >  mm/tmem/zcache-main.c                 | 1686 +++++++++++++++++++++++++
> >  mm/tmem/zcache.h                      |   53
> >  mm/tmem/ramster.h                     |   59
> >  mm/tmem/ramster/heartbeat.c           |  462 ++++++
> >  mm/tmem/ramster/heartbeat.h           |   87 +
> >  mm/tmem/ramster/masklog.c             |  155 ++
> >  mm/tmem/ramster/masklog.h             |  220 +++
> >  mm/tmem/ramster/nodemanager.c         |  995 +++++++++++++++
> >  mm/tmem/ramster/nodemanager.h         |   88 +
> >  mm/tmem/ramster/r2net.c               |  414 ++++++
> >  mm/tmem/ramster/ramster.c             |  985 ++++++++++++++
> >  mm/tmem/ramster/ramster.h             |  161 ++
> >  mm/tmem/ramster/ramster_nodemanager.h |   39
> >  mm/tmem/ramster/tcp.c                 | 2253 ++++++++++++++++++++++++++++++++++
> >  mm/tmem/ramster/tcp.h                 |  159 ++
> >  mm/tmem/ramster/tcp_internal.h        |  248 +++
> > 28 files changed, 10358 insertions(+), 4 deletions(-)
> 
> So it's basically this commit, right?
> 
> https://oss.oracle.com/git/djm/tmem.git/?p=djm/tmem.git;a=commitdiff;h=22844fe3f52d912247212408294be33
> 0a867937c
> 
> Why on earth would you want to move that under the mm directory?

Hi Pekka --

Thanks for your reply and question.

MM means "memory management" and zcache manages physical memory
to allow more pages of data to be stored in RAM.  So it seems a
logical place.  It's not a block driver, or a network driver,
or a device driver, or a filesystem... do you have a different
location in the kernel in mind?

Zcache does it a bit differently than all the other parts of mm
because it needs to; because all the other parts of mm try to
maximize the amount of physical memory that is directly addressable
by threads but one can't directly address pages that have been compressed.
So zcache uses the transcendent memory approach (via cleancache
and frontswap) to compress/decompress clean pagecache pages and
swap pages "on demand".  The tmem design also nicely handles
both the fact that the degree of compression is unpredictable and
the fact that the fraction of fixed total RAM used for compressed
pages vs "normal uncompressed mm" pages needs to be very dynamic.

Ramster does the same thing but manages it peer-to-peer across
multiple systems using kernel sockets.  One could argue that
the dependency on sockets makes it more of a driver than "mm"
but ramster is "memory management" too, just a bit more exotic.

Thanks,
Dan
