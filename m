Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0JGUmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:42:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43211 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab0JGUmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Wqa/kltF/x3VNsKecGa8qP6XyVPtF08RVnXwpdomGoAbJo3yDYnL+iR+R555dxnnPo
         gwalGbi3/ssiIIGKj2PsOsXGF+vtT1WQy3ipQZnrvlGguGBTvqFZ9JUzX1ry72TqilMp
         Qxf97gwn+5JAcGDYINsjEP4fYQzMr1jTenqX8=
Subject: Re: [PATCH] percpu_counter: change inaccurate comment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1010071509180.28032@router.home>
References: <1286469421.2912.240.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1010071440220.28032@router.home>
	 <1286481860.3745.30.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1010071509180.28032@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 22:42:11 +0200
Message-ID: <1286484131.3745.88.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 07 octobre 2010 à 15:13 -0500, Christoph Lameter a écrit :
> On Thu, 7 Oct 2010, Eric Dumazet wrote:
> 
> > If enclosed by preempt_disable()/preempt_enable(), maybe we could use
> > __this_cpu_ptr() ?
> 
> The only difference between __this_cpu_ptr and this_cpu_ptr is that
> this_cpu_ptr checks that preempt was disabled. __this_cpu_ptr allows use
> even without preempt. Preempt must be disabled here so the use of
> this_cpu_ptr is appropriate.
> 
> 

Thats not how I read the thing.

In both variants, preemption _must_ be disabled, its only the context
that can tell how sure we are...

<quote>

commit 7340a0b15280c

__this_cpu_ptr  -> Do not check for preemption context
this_cpu_ptr    -> Check preemption context

</quote>

If preemption was enabled, both pointers would not be very useful...

We use __this_cpu_ptr() in contexts where cpu _cannot_ change under us,
(we just disabled preemption one line above), so its not necessary to
perform the check.

vi +316 include/linux/percpu.h

#define _this_cpu_generic_to_op(pcp, val, op)                   \
do {                                                            \
        preempt_disable();                                      \
        *__this_cpu_ptr(&(pcp)) op val;                         \
        preempt_enable();                                       \
} while (0)

...

#define __this_cpu_generic_to_op(pcp, val, op)                  \
do {                                                            \
        *__this_cpu_ptr(&(pcp)) op val;                         \
} while (0)





