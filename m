Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0GBJPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:15:52 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42725 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861Ab0GBJPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:15:51 -0400
Date: Fri, 2 Jul 2010 11:17:26 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <dkruchinin@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 1/3] padata: separate serial and parallel cpumasks
Message-ID: <20100702091726.GH10072@secunet.com>
References: <AANLkTikeDE4hvZ3spyTBSHZsdQPc-2wlD5nTfb1aF-VD@mail.gmail.com>
 <20100702085323.GF10072@secunet.com>
 <AANLkTinyPGjXjlvJxB8WYB3EYFBtANXMzpTdUixyBRHW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinyPGjXjlvJxB8WYB3EYFBtANXMzpTdUixyBRHW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Jul 2010 09:15:48.0308 (UTC) FILETIME=[28C07940:01CB19C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 01:07:44PM +0400, Dan Kruchinin wrote:
> >
> > The above is not save against cpu hotplug. You initialize ctx->cb_cpu
> > to -1 when the transformation is initialized. So you choose your
> > callback cpu with the first call to pcrypt_do_parallel() and then never
> > again. What if the coosen callback cpu goes offline?
> >
> > Also I don't understand why you changed the prototype of pcrypt_do_parallel
> > and added a 'count' to pcrypt_aead_ctx. The only change you have to do, is
> > to
> > check whether the choosen callback cpu is still in the cpu_active_mask
> > _and_
> > in your new padata callback cpumask and update the callback cpu accordingly
> > if not. Checking whether the callback cpu is in the callback cpumask needs
> > some special care in your other patch of course, because you can change
> > this
> > cpumask from userspace then.
> >
> 
> Well, my point was to reduce the code and select callback CPU only once
> according to
> serial cpumask of given data instance. In case when  I modify serial cpumask
> of given padata
> instance I have to do callback cpu calculation twice in worst case. The
> first time in pcrypt_aead_init_tfm
> and the second time in pcrypt_do_parallel if cb_cpu is not set in my serial
> cpumask.
> So I decided to do it only once in pcrypt_do_parallel.
> 

But the active cpumask, and now also your serial cpumask might change.
We need to catch this changes somehow, that's why I checked the active
cpumask against the callback cpu.

Steffen

