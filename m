Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013Ab0FFLcz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 07:32:55 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:49745 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994Ab0FFLcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:32:53 -0400
Date: Sun, 6 Jun 2010 13:32:48 +0200
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] early_res: fix check in free_early_partial
Message-ID: <20100606113248.GA20976@os.inf.tu-dresden.de>
References: <20100604211025.GA17881@os.inf.tu-dresden.de>
 <AANLkTimDkEqpGNDkDSy7e8s_ZnCnVuppa6Ut-SLEoHWE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTimDkEqpGNDkDSy7e8s_ZnCnVuppa6Ut-SLEoHWE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri Jun 04, 2010 at 17:00:02 -0700, Yinghai Lu wrote:
> On Fri, Jun 4, 2010 at 2:10 PM, Adam Lackorzynski
> <adam@os.inf.tu-dresden.de> wrote:
> > free_early_partial must check the returned region of find_overlapped_early()
> > whether it is a region at all. Otherwise the function will indefinitely
> > loop.
> 
> do you have that hang really?
> 
> that stage we should not have blank slot in the middle.

I did but I cannot manage to reproduce this now. I think this happens
when find_overlapped_early does not find a region, i.e. the given one
does not exist. Then it returns i == early_res_count which is smaller
than max_early_res (usually). Given that r->end == 0 this goes on
indefinitely. So the check would just be more robust with
i >= max_early_res || !r->end or i == early_res_count.

Adam

> > Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
> > ---
> >  kernel/early_res.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/early_res.c b/kernel/early_res.c
> > index 31aa933..9afcb4c 100644
> > --- a/kernel/early_res.c
> > +++ b/kernel/early_res.c
> > @@ -341,10 +341,11 @@ void __init free_early_partial(u64 start, u64 end)
> >
> >  try_next:
> >        i = find_overlapped_early(start, end);
> > -       if (i >= max_early_res)
> > +       r = &early_res[i];
> > +
> > +       if (i >= max_early_res || !r->end)
> >                return;
> >
> > -       r = &early_res[i];
> >        /* hole ? */
> >        if (r->end >= end && r->start <= start) {
> >                drop_range_partial(i, start, end);
> > --
> > 1.7.1
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
