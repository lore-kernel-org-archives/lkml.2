Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966583Ab0CPR4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:56:06 -0400
Received: from waste.org ([173.11.57.241]:44532 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966159Ab0CPR4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:56:03 -0400
Subject: Re: [PATCH 1/1] NET: netpoll, fix potential NULL ptr dereference
From: Matt Mackall <mpm@selenic.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, davem@davemloft.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Daniel Borkmann <danborkmann@googlemail.com>
In-Reply-To: <4B9FBE49.6010709@gmail.com>
References: <1268753394-17765-1-git-send-email-jslaby@suse.cz>
	 <1268759527.25503.2980.camel@calx>  <4B9FBE49.6010709@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 12:56:00 -0500
Message-ID: <1268762160.25503.2988.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 18:22 +0100, Jiri Slaby wrote:
> On 03/16/2010 06:12 PM, Matt Mackall wrote:
> > I don't get it. The source of the branch tests for !ndev->npinfo and the
> > original destination of the branch also tests for !ndev->npinfo. I don't
> > see how it gets dereferenced.
> 
> Let's look at more of the context:
>          if (!ndev->npinfo) {
>                  npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
>                  if (!npinfo) {         // npinfo is NULL
>                          err = -ENOMEM;
>                          goto release;
>                  }
> ...
> release:                           // npinfo is still NULL
>          if (!ndev->npinfo) {       // condition is the same (holds)
>               // dereference below: vvvvvvvvvvvvvvv
>                  spin_lock_irqsave(&npinfo->rx_lock, flags);
>                  list_for_each_entry_safe(npe, tmp, &npinfo->rx_np, rx) {
>                          npe->dev = NULL;
>                  }
>                  spin_unlock_irqrestore(&npinfo->rx_lock, flags);
> 
>                  kfree(npinfo);
>          }

Ok, you're correct, I read the second test backwards.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


