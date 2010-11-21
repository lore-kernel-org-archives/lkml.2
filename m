Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0KUBSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 20:18:20 -0500
Received: from mail.perches.com ([173.55.12.10]:1617 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab0KUBSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 20:18:20 -0500
Subject: Re: [PATCHv4 10/17] pps: use BUG_ON for kernel API safety checks
From: Joe Perches <joe@perches.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
        "Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20101121034008.4fef543a@apollo.gnet>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	 <1a1ebcf97b2eb62548c34d2d8fc139c0703a9077.1290087480.git.lasaine@lvk.cs.msu.su>
	 <20101120161351.GC13356@enneenne.com>
	 <1290272501.27951.27.camel@Joe-Laptop>
	 <20101121034008.4fef543a@apollo.gnet>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Nov 2010 17:18:18 -0800
Message-ID: <1290302298.31117.185.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 03:40 +0300, Alexander Gordeev wrote:
> В Sat, 20 Nov 2010 09:01:41 -0800
> Joe Perches <joe@perches.com> пишет:
> > On Sat, 2010-11-20 at 17:13 +0100, Rodolfo Giometti wrote:
> > > On Thu, Nov 18, 2010 at 07:01:03PM +0300, Alexander Gordeev wrote:
> > > > This way less overhead is involved when running production kernel.
> > > > If you want to debug a pps client module please define DEBUG to enable
> > > > the checks.
> > > > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > []
> > > > diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> > > > @@ -179,10 +168,8 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
> > > >  	int captured = 0;
> > > >  	struct pps_ktime ts_real;
> > > > -	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
> > > > -		dev_err(pps->dev, "unknown event (%x)\n", event);
> > > > -		return;
> > > > -	}
> > > > +	/* check event type */
> > > > +	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
> > > Ack.
> > > This is a correct usage of BUG_ON. :)
> > I don't think that's true.
> > /*
> >  * Don't use BUG() or BUG_ON() unless there's really no way out; one
> >  * example might be detecting data structure corruption in the middle
> >  * of an operation that can't be backed out of.  If the (sub)system
> >  * can somehow continue operating, perhaps with reduced functionality,
> >  * it's probably not BUG-worthy.
> >  *
> >  * If you're tempted to BUG(), think again:  is completely giving up
> >  * really the *only* solution?  There are usually better options, where
> >  * users don't need to reboot ASAP and can mostly shut down cleanly.
> >  */
> Hmm, didn't check that before. What is more appropriate in this
> situation?

If it's really a non-recoverable event, perhaps emit a dev_crit
and then do a module_put?

