Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0DOP6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 11:58:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49245 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab0DOP6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CAI3eoTwRDWWgsJQuuI0PSeulxUqn2M+RkwK1jP1N2YJ+vJ/LZCpEaFEDMKA4qXIPD
         UejvSf2SXxcLSpwEKs6n+E7/DynRgo8tQmm/F43fPqBHCvi8mhyGdgTMiw8wfRIZOzGe
         AD50FKA4xXG7H+0LKJg86AbCrcFy2++vNYeao=
MIME-Version: 1.0
In-Reply-To: <j2i121039231004150213i76ecc96ahb5d9af96c46b27ae@mail.gmail.com>
References: <x2i121039231004132342sa230bfd4k832950fce534113f@mail.gmail.com>
	 <i2ge9c3a7c21004141708y87d01ab6h94c653e4efa11b8d@mail.gmail.com>
	 <j2i121039231004150213i76ecc96ahb5d9af96c46b27ae@mail.gmail.com>
Date: Thu, 15 Apr 2010 08:58:47 -0700
X-Google-Sender-Auth: d498dae864709b8f
Message-ID: <v2he9c3a7c21004150858t917f44d6q15b5eaa3247d6fff@mail.gmail.com>
Subject: Re: DMA Engine API performance issues
From: Dan Williams <dan.j.williams@intel.com>
To: melwyn lobo <linux.melwyn@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 2:13 AM, melwyn lobo <linux.melwyn@gmail.com> wrote:
> Thanks so much for your explanation.
> OK..Looking at IPU implementation, irq handling is enrtirely in the
> interrupt routine, therefore no need for spin_lock_bh stuff.
> But for lower interrupt latency reasons we need to stick with the
> tasklet handling for processing interrupts.
>
> We were contemplating another solution for locking at our end for DMA
> implementation
> For locking
> if(irqs_disabled())
>    spin_lock(&chan->lock);
> else
>    spin_lock_bh(&chan->lock);
>
> for unlocking:
> if(irqs_disabled())
>    spin_unlock(&chan->lock);
> else
>    spin_unlock_bh(&chan->lock);
>
> Although this works  fine, but will this be OK when we submit the driver.
>

This won't work and lockdep should complain about this situation.  The
minute you need to take the lock in the interrupt handler then all
other occurrences of the lock need to be promoted to _irq or
_irqsave() [1].

--
Dan

[1]: http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/c214.html
