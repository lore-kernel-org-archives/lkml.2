Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1BNEeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 23:34:12 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42934 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab1BNEeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 23:34:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z2JVKpEu7OM3HATF45maAUgPy1IRCVFJHhXjfpdwCv49tv4UNrTO00lN5swIHgc8AG
         C6pJwu4/K3lxS6RSOhod65pD6KtEQjsc6sigBMcAmWZtGPLi9Z2Gg+MYKpy6b/B5MEI1
         gtFxYNaHMUESm2KGCoK66xRj7kV44/at7Yguc=
Date: Sun, 13 Feb 2011 20:33:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, stoth@kernellabs.com
Subject: Re: cx23885-input.c does in fact use a workqueue....
Message-ID: <20110214043355.GA28090@core.coreip.homeip.net>
References: <1297647322.19186.61.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297647322.19186.61.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 08:35:22PM -0500, Andy Walls wrote:
> Tejun,
> 
> I just noticed this commit:
> 
> commit 8c71778cbf2c8beaefaa2dee5478aa0622d96682
> Author: Tejun Heo <tj@kernel.org>
> Date:   Fri Dec 24 16:14:20 2010 +0100
> 
>     media/video: don't use flush_scheduled_work()
>     
>     This patch converts the remaining users of flush_scheduled_work() in
>     media/video.
>     
>     * bttv-input.c and cx23885-input.c don't use workqueue at all.  No
>       need to flush.
> [...]
> 
> 
> The cx23885 driver does in fact schedule work for IR input handling:
> 
> Here's where it is scheduled for CX23888 chips:
> 
> http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23885-ir.c;h=7125247dd25558678c823ee3262675570c9aa630;hb=HEAD#l76
> 
> Here's where it is scheduled for CX23885 chips:
> 
> http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23885-core.c;h=359882419b7f588b7c698dbcfb6a39ddb1603301;hb=HEAD#l1861
> 
> 
> The two different chips are handled slightly differently because
> 
> a. the CX23888 IR unit is accessable via a PCI register block.  The IR
> IRQ can be acknowledged with direct PCI register accesses in an
> interrupt context, and the IR pulse FIFO serviced later in a workqueue
> context.
> 
> b. the CX23885 IR unit is accessed over an I2C bus.  The CX23885 A/V IRQ
> has to be masked in an interrupt context (with PCI registers accesses).
> Then the CX23885 A/V unit's IR IRQ is ack'ed over I2C in a workqueue
> context and the IR pulse FIFO is also serviced over I2C in a workqueue
> context.
> 
> 
> So what should be done about the flush_scheduled_work()?  I think it
> belongs there.
> 

Convert to using threaded irq?

-- 
Dmitry
