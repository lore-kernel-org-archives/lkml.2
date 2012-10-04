Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab2JDTJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:09:41 -0400
Received: from mxout1.idt.com ([157.165.5.25]:50674 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab2JDTJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:09:39 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: RE: [PATCH 3/5] rapidio: run discovery as an asynchronous process
Thread-Topic: [PATCH 3/5] rapidio: run discovery as an asynchronous process
Thread-Index: AQHNoZwoWl65ZA0aUEi7DUNE9YWzm5eon1eAgADhfbA=
Date: Thu, 4 Oct 2012 19:08:27 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D1499FC7D9@corpmail2.na.ads.idt.com>
References: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
	<1349291923-22860-4-git-send-email-alexandre.bounine@idt.com>
 <20121003152953.79aecece.akpm@linux-foundation.org>
In-Reply-To: <20121003152953.79aecece.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, October 03, 2012 6:30 PM
Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> On Wed,  3 Oct 2012 15:18:41 -0400
> Alexandre Bounine <alexandre.bounine@idt.com> wrote:
> 
> > ...
> >
> > +static void __devinit disc_work_handler(struct work_struct *_work)
> > +{
> > +	struct rio_disc_work *work = container_of(_work,
> > +						  struct rio_disc_work, work);
> 
> There's a nice simple way to avoid such ugliness:
> 
> --- a/drivers/rapidio/rio.c~rapidio-run-discovery-as-an-asynchronous-
> process-fix
> +++ a/drivers/rapidio/rio.c
> @@ -1269,9 +1269,9 @@ struct rio_disc_work {
> 
>  static void __devinit disc_work_handler(struct work_struct *_work)
>  {
> -	struct rio_disc_work *work = container_of(_work,
> -						  struct rio_disc_work, work);
> +	struct rio_disc_work *work;
> 
> +	work = container_of(_work, struct rio_disc_work, work);
>  	pr_debug("RIO: discovery work for mport %d %s\n",
>  		 work->mport->id, work->mport->name);
>  	rio_disc_mport(work->mport);
> _
> 

Thank you for the fix. Will avoid that ugliness in the future.

> > +	pr_debug("RIO: discovery work for mport %d %s\n",
> > +		 work->mport->id, work->mport->name);
> > +	rio_disc_mport(work->mport);
> > +
> > +	kfree(work);
> > +}
> > +
> >  int __devinit rio_init_mports(void)
> >  {
> >  	struct rio_mport *port;
> > +	struct rio_disc_work *work;
> > +	int no_disc = 0;
> >
> >  	list_for_each_entry(port, &rio_mports, node) {
> >  		if (port->host_deviceid >= 0)
> >  			rio_enum_mport(port);
> > -		else
> > -			rio_disc_mport(port);
> > +		else if (!no_disc) {
> > +			if (!rio_wq) {
> > +				rio_wq = alloc_workqueue("riodisc", 0, 0);
> > +				if (!rio_wq) {
> > +					pr_err("RIO: unable allocate rio_wq\n");
> > +					no_disc = 1;
> > +					continue;
> > +				}
> > +			}
> > +
> > +			work = kzalloc(sizeof *work, GFP_KERNEL);
> > +			if (!work) {
> > +				pr_err("RIO: no memory for work struct\n");
> > +				no_disc = 1;
> > +				continue;
> > +			}
> > +
> > +			work->mport = port;
> > +			INIT_WORK(&work->work, disc_work_handler);
> > +			queue_work(rio_wq, &work->work);
> > +		}
> > +	}
> 
> I'm having a lot of trouble with `no_disc'.  afacit what it does is to
> cease running async discovery for any remaining devices if the
> workqueue
> allocation failed (vaguely reasonable) or if the allocation of a single
> work item failed (incomprehensible).
> 
> But if we don't run discovery, the subsystem is permanently busted for
> at least some devices, isn't it?

This is correct. We are considering ways to restart discovery
process later but it is not applicable now.

> 
> And this code is basically untestable unless the programmer does
> deliberate fault injection, which makes it pretty much unmaintainable.
> 
> So...  if I haven't totally misunderstood, I suggest a rethink is in
> order?
>

I will review and simplify. Probably, just try to allocate all required
resources ahead of port list scan. Simple and safe.
 
> > +	if (rio_wq) {
> > +		pr_debug("RIO: flush discovery workqueue\n");
> > +		flush_workqueue(rio_wq);
> > +		pr_debug("RIO: flush discovery workqueue finished\n");
> > +		destroy_workqueue(rio_wq);
> >  	}
