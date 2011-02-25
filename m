Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab1BYNS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 08:18:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61717 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab1BYNSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 08:18:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R1Cenn9p/LXs6FPQg7bPr3xNJOuWRcY55fdGykZaaeS7l6G+cvcDPjFn5rkIpTTj4c
         9cdS7Db7NvBAvuCm/Bx2KIxmd+yQcRwFzepGPHbJXr+plrLwojPjsNK8wbBFI1FzyuX4
         ANCeMvZTc8qmTDYyYAeSiDxhRV1F2FYRXdx6A=
Date: Fri, 25 Feb 2011 14:18:50 +0100
From: Tejun Heo <tj@kernel.org>
To: Dominik Klein <dk@in-telegence.net>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110225131850.GI24828@htj.dyndns.org>
References: <20110222190953.GF28269@redhat.com>
 <4D650D7E.4050908@in-telegence.net>
 <4D662248.6040405@in-telegence.net>
 <20110224142303.GA18494@redhat.com>
 <20110224143105.GL7840@htj.dyndns.org>
 <4D66720E.70102@in-telegence.net>
 <20110224151701.GQ7840@htj.dyndns.org>
 <4D67591F.10105@in-telegence.net>
 <20110225112936.GH24828@htj.dyndns.org>
 <4D679688.7020503@in-telegence.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D679688.7020503@in-telegence.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 25, 2011 at 12:46:16PM +0100, Dominik Klein wrote:
> With 2.6.37 (also tried .1 and .2) it does not work but end up like I
> documented. With 2.6.38-rc1, it does work. With deadline scheduler, it
> also works in 2.6.37.

Okay, here's the problematic part.

          <idle>-0     [013]  1640.975562: workqueue_queue_work: work struct=ffff88080f14f270 function=blk_throtl_work workqueue=ffff88102c8fc700 req_cpu=13 cpu=13
          <idle>-0     [013]  1640.975564: workqueue_activate_work: work struct ffff88080f14f270
           <...>-477   [013]  1640.975574: workqueue_execute_start: work struct ffff88080f14f270: function blk_throtl_work
	  <idle>-0     [013]  1641.087450: workqueue_queue_work: work struct=ffff88080f14f270 function=blk_throtl_work workqueue=ffff88102c8fc700 req_cpu=13 cpu=13
		     
The workqueue is per-cpu, so we only need to follow cpu=13 cases.
@1640, blk_throtl_work() is queued, activated and starts executing but
never finishes.  The same work item is never executed more than once
at the same on the same CPU, so when the next work item is queued, it
doesn't get activated until the previous execution is complete.

The next thing to do would be finding out why blk_throtl_work() isn't
finishing.  sysrq-t or /proc/PID/stack should show us where it's
stalled.

Thanks.

-- 
tejun
