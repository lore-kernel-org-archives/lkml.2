Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab2DFSSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:18:46 -0400
Received: from nspiron-1.llnl.gov ([128.115.41.81]:36990 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2DFSSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:18:44 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2012 14:18:44 EDT
X-Attachments: 
Date: Fri, 6 Apr 2012 11:09:05 -0700
From: Jim Garlick <garlick@llnl.gov>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "levinsasha928@gmail.com" <levinsasha928@gmail.com>,
        "ericvh@gmail.com" <ericvh@gmail.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kaber@trash.net" <kaber@trash.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>
Subject: Re: ipv6: tunnel: hang when destroying ipv6 tunnel
Message-ID: <20120406180905.GA10835@llnl.gov>
References: <CA+1xoqcAXyh306=2=QKWyM3BE44=MT+nsuRQn5YLOLgbtZqicA@mail.gmail.com>
 <CA+1xoqe1Wc_uifrKsko6hu+py9Ahz3Q0p1tRxup09jmh2NZ1rw@mail.gmail.com>
 <201204011221.GAG51016.JQFSFFOtLOMVHO@I-love.SAKURA.ne.jp>
 <CA+1xoqe+T=iUtUeFdeqmRvMZ7TMCgkLs_1QYv-4YNtn-jCoMCQ@mail.gmail.com>
 <201204052329.EBH52139.FFOLQMOJSVHOFt@I-love.SAKURA.ne.jp>
 <201204062044.EJE13062.OLMQtSVFHOFOJF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204062044.EJE13062.OLMQtSVFHOFOJF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tetsuo,

I am sorry if my patch is causing you grief!

On Fri, Apr 06, 2012 at 04:44:37AM -0700, Tetsuo Handa wrote:
> Tetsuo Handa wrote:
> > Most suspicious change is net/9p/client.c because it is changing handling of
> > ERESTARTSYS case.
> > 
> > --- linux-3.3.1/net/9p/client.c
> > +++ linux-next/net/9p/client.c
> > @@ -740,10 +740,18 @@
> >                         c->status = Disconnected;
> >                 goto reterr;
> >         }
> > +again:
> >         /* Wait for the response */
> >         err = wait_event_interruptible(*req->wq,
> >                                        req->status >= REQ_STATUS_RCVD);
> > 
> > +       if ((err == -ERESTARTSYS) && (c->status == Connected)
> > +                                 && (type == P9_TFLUSH)) {
> > +               sigpending = 1;
> > +               clear_thread_flag(TIF_SIGPENDING);
> > +               goto again;
> > +       }
> > +
> 
> I think this loop is bad with regard to response to SIGKILL.
> If wait_event_interruptible() was interrupted by SIGKILL, it will
> spin until req->status >= REQ_STATUS_RCVD becomes true.
> Rather,
> 
> 	if ((c->status == Connected) && (type == P9_TFLUSH))
> 		err = wait_event_killable(*req->wq,
> 					  req->status >= REQ_STATUS_RCVD);
> 	else
> 		err = wait_event_interruptible(*req->wq,
> 					       req->status >= REQ_STATUS_RCVD);
> 
> would be safer.

Does that work?  What prevents p9_client_rpc() from recursing via
p9_client_flush() on receipt of SIGKILL? 


> >  error:
> >         /*
> >          * Fid is not valid even after a failed clunk
> > +        * If interrupted, retry once then give up and
> > +        * leak fid until umount.
> >          */
> > -       p9_fid_destroy(fid);
> > +       if (err == -ERESTARTSYS) {
> > +               if (retries++ == 0)
> > +                       goto again;
> 
> I think it is possible that the process is interrupted again upon retrying.
> I suspect the handling of err == -ERESTARTSYS case when retries != 0.
> It is returning without calling p9_fid_destroy(), which will be
> unexpected behaviour for the various callers.

Yes but in the unlikely event that this happens, the effect is a small
memory leak for the duration of the mount.  On the other hand if the
fid is destroyed without successfully informing the server, then
subsequent operations that involve new file references will fail
when that fid number is reused, and the mount becomes unusable.

> > +       } else
> > +               p9_fid_destroy(fid);
> >         return err;
> >  }
> >  EXPORT_SYMBOL(p9_client_clunk);

Regards,

Jim
