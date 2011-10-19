Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1JSRdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:33:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57563 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab1JSRdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:33:44 -0400
Date: Wed, 19 Oct 2011 10:33:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com
Subject: Re: [PATCH 10/10] block: fix request_queue lifetime handling by
 making blk_queue_cleanup() proper shutdown
Message-ID: <20111019173337.GH25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-11-git-send-email-tj@kernel.org>
 <20111019161840.GG1140@redhat.com>
 <20111019171259.GE25124@google.com>
 <20111019172914.GI1140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019172914.GI1140@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 19, 2011 at 01:29:14PM -0400, Vivek Goyal wrote:
> > Hmmm... the thing is you need to check DEAD again once after releasing
> > and re-grabbing the queuelock, os if we move the test into the caller,
> > we end up having one in the caller and one in the callee, so I thought
> > it would be better to keep them in the same function.
> 
> Sorry I did not get that why do we need to check again for DEAD after
> realeasing the queue lock. From throttling perspective, we grab lock
> once, if queue is DEAD, release lock and just return.
> 
> blk_throtl_bio() {
> 
>   bunch_of_checks_without_queue_lock;
> 
>   spin_lock()
>   if (queue_dead) {
> 	spin_unlock()
> 	return;
>   }
> 
>   throtl_get_tg();
> }	

Because DEAD state is protected by queue_lock and get_tg may release
and re-grab queue_lock across allocation?  It needs to re-test after
re-grabbing.

Thanks.

-- 
tejun
