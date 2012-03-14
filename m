Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030386Ab2CNXDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:03:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:37560 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965338Ab2CNXCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:02:50 -0400
Date: Thu, 15 Mar 2012 00:02:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Carsten Emde <C.Emde@osadl.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [REGRESSION][PATCH] mqueue: Ignore the validity of abs_timeout
 parameter when message can be performed immediately
In-Reply-To: <20120314144601.ccc50a68.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1203142346190.2466@ionos>
References: <20120302164234.4938.38390934@jp.panasonic.com> <20120314144601.ccc50a68.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2601;0cOn Wed, 14 Mar 2012, Andrew Morton wrote:
> On Fri, 02 Mar 2012 16:42:35 +0900
> Akira Takeuchi <takeuchi.akr@jp.panasonic.com> wrote:
> > @@ -996,6 +1015,10 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
> >  		if (filp->f_flags & O_NONBLOCK) {
> >  			spin_unlock(&info->lock);
> >  			ret = -EAGAIN;
> > +		} else if (unlikely(timeout_param_error)) {
> > +			spin_unlock(&info->lock);
> > +			ret = timeout_param_error;
> > +			msg_ptr = NULL; /* just for shutting up warning */

Huch? We are not "just" shutting up some warning because the compiler
is yelling at us. No, either we initialize the variable upfront to
NULL or we skip the whole return path by going to fput directly.

Duh, that code is convoluted enough already.

Thanks,

	tglx

