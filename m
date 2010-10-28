Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822Ab0J1SJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:09:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758192Ab0J1SJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:09:10 -0400
Date: Thu, 28 Oct 2010 14:08:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 1/2] amiga floppy: Stop sharing request queue across
 multiple gendisks
Message-ID: <20101028180853.GF30148@redhat.com>
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
 <1285271646-2768-2-git-send-email-vgoyal@redhat.com>
 <AANLkTi=KDqSu8PrR2JbNzwv_Z93G6X5MRqbEiSF9hVgH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=KDqSu8PrR2JbNzwv_Z93G6X5MRqbEiSF9hVgH@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 07:38:33PM +0200, Geert Uytterhoeven wrote:
> On Thu, Sep 23, 2010 at 21:54, Vivek Goyal <vgoyal@redhat.com> wrote:
> > o Use one request queue per gendisk instead of sharing request queue
> >
> > o Don't have hardware. No compile testing or run time testing done. Completely
> >  untested.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  drivers/block/amiflop.c |   59 ++++++++++++++++++++++++++++++++++++++--------
> >  1 files changed, 48 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
> > index 76f114f..ead8b77 100644
> > --- a/drivers/block/amiflop.c
> > +++ b/drivers/block/amiflop.c
> > @@ -114,8 +114,6 @@ static unsigned long int fd_def_df0 = FD_DD_3;     /* default for df0 if it does
> >  module_param(fd_def_df0, ulong, 0);
> >  MODULE_LICENSE("GPL");
> >
> > -static struct request_queue *floppy_queue;
> > -
> >  /*
> >  *  Macros
> >  */
> > @@ -164,6 +162,7 @@ static volatile int selected = -1;  /* currently selected drive */
> >  static int writepending;
> >  static int writefromint;
> >  static char *raw_buf;
> > +static int fdc_queue;
> >
> >  static DEFINE_SPINLOCK(amiflop_lock);
> >
> > @@ -1334,6 +1333,42 @@ static int get_track(int drive, int track)
> >        return -1;
> >  }
> >
> > +/*
> > + * Round-robin between our available drives, doing one request from each
> > + */
> > +static struct request *set_next_request(void)
> > +{
> > +       struct request_queue *q;
> > +       int cnt = FD_MAX_UNITS;
> > +       struct request *rq;
> > +
> > +       /* Find next queue we can dispatch from */
> > +       fdc_queue = fdc_queue + 1;
> > +       if (fdc_queue == FD_MAX_UNITS)
> > +               fdc_queue = 0;
> > +
> > +       for(cnt = FD_MAX_UNITS; cnt > 0, cnt--) {
> > +
> > +               if (unit[fdc_queue].type->code == FD_NODRIVE) {
> > +                       if (++fdc_queue == FD_MAX_UNITS)
> > +                               fdc_queue = 0;
> > +                       cotinue;
> > +               }
> > +
> > +               q = unit[fdc_queue].gendisk->queue;
> > +               if (q) {
> > +                       rq = blk_fetch_request(q);
> > +                       if (rq)
> > +                               break;
> > +               }
> > +
> > +               if (++fdc_queue == FD_MAX_UNITS)
> > +                       fdc_queue = 0;
> > +       }
> > +
> > +       return rq;
> > +}
> 
> drivers/block/amiflop.c:1344: warning: ‘rq’ may be used uninitialized
> in this function
> drivers/block/ataflop.c:1402: warning: ‘rq’ may be used uninitialized
> in this function
> 
> Should `rq' just be initialized to NULL? I looked at
> floppy.c:set_next_request(), but it's
> completely different.
> 

I think we should explicitly initialize rq=NULL so that we don't return
a garbage value if we can't find any rq to dispatch.

I will send a patch to fix that. 

Thanks
Vivek
