Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab1F2WAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 18:00:16 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19427 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1F2WAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 18:00:11 -0400
Date: Wed, 29 Jun 2011 23:51:00 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: David Teigland <teigland@redhat.com>
cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Christine Caulfield <ccaulfie@redhat.com>
Subject: Re: [PATCH] fs, dlm: Don't leak, don't do pointless NULL checks and
 use kzalloc
In-Reply-To: <20110629214056.GA11350@redhat.com>
Message-ID: <alpine.LNX.2.00.1106292344110.3747@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106292304380.3747@swampdragon.chaosbits.net> <20110629214056.GA11350@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, David Teigland wrote:

> On Wed, Jun 29, 2011 at 11:09:27PM +0200, Jesper Juhl wrote:
> > In fs/dlm/lock.c in the dlm_scan_waiters() function there are 3 small
> > issues:
> > 
> > 1) first time through the loop we allocate memory for 'warned', if we
> > then (in the loop) don't take the "if (!warned)" path and loop again,
> > the second time through the loop we'll allocate memory again and store
> > it to 'warned' without freeing the previous allocation - this leaks
> > memory.
> 
> I don't think so; num_nodes won't be set to zero.
> 

Hmm. How so?  Maybe I'm missing something obvious, but;
num_nodes is initialized to zero at the beginning of the function, which 
means that we'll definately do the first allocation in the loop.
We then set num_nodes equal to ls->ls_num_nodes - what guarantees that 
this will not be zero so we won't do a second allocation (and leak) the 
second time through the loop?

> > 2) There's no need to test the return value of the allocation and do a
> > memset if is succeedes. Just use kzalloc() to obtain zeroed memory.
> 
> fine
> 
> > 3) Since kfree() handles NULL pointers gracefully, the test of
> > 'warned' against NULL before the kfree() after the loop is completely
> > pointless. Remove it.
> 
> fine
> 
> ack if you want to push those two out yourself.
> Dave

Ok. I can resend a patch (tomorrow) with just those two changes and will 
add your Acked-by:

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

