Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1BXObN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:31:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43680 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab1BXObK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:31:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PK/8lK88mP7nw/MKdnyBViPtQXEFh6gL+0e4+6z/umlEwV2L9u2fEObAc/cDUxbd3H
         K/r9JDu4Xfdqh2dQGVTXaUnixtSA2ZKFRxO8ccw2k0lrHER+iG5UqZJa3od+26aqGy+c
         BGuM5viXG9bK3vJLFqXBypULidl2YYCzhfnAo=
Date: Thu, 24 Feb 2011 15:31:05 +0100
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com, Dominik Klein <dk@in-telegence.net>
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110224143105.GL7840@htj.dyndns.org>
References: <4D621B9B.3070205@in-telegence.net>
 <4D622002.2040604@in-telegence.net>
 <4D6222A8.6090303@in-telegence.net>
 <20110221184442.GM6428@redhat.com>
 <4D63BA3B.7070809@in-telegence.net>
 <20110222152426.GD28269@redhat.com>
 <20110222190953.GF28269@redhat.com>
 <4D650D7E.4050908@in-telegence.net>
 <4D662248.6040405@in-telegence.net>
 <20110224142303.GA18494@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224142303.GA18494@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 24, 2011 at 09:23:03AM -0500, Vivek Goyal wrote:
> On Thu, Feb 24, 2011 at 10:18:00AM +0100, Dominik Klein wrote:
> 
> Hi Dominik,
> 
> Thanks for the tests and reports. I checked the latest logs also and
> I see that cfq has scheduled a work but that work never gets scheduled.
> I never see the trace message which says cfq_kick_queue().
> 
> I am ccing it to lkml and tejun to see if he has any suggestions.
> 
> Tejun,
> 
> I will give you some details about what we have discussed so far.
> 
> Dominik is trying blkio throttling feature and trying to throttle some
> virtual machines. He is using 2.6.37 kernels and once he launches 3
> virtual machines he notices that system is kind of frozen. After running
> some traces we noticed that CFQ has requests but it is not dispatching
> these to devices any more.
> 
> This problem does not show up with deadline scheduler and also goes away
> with 2.6.38-rc6 kernels.

Hmmm...  Maybe the following commit?

commit 7576958a9d5a4a677ad7dd40901cdbb6c1110c98
Author: Tejun Heo <tj@kernel.org>
Date:   Mon Feb 14 14:04:46 2011 +0100

    workqueue: wake up a worker when a rescuer is leaving a gcwq

    After executing the matching works, a rescuer leaves the gcwq
    whether there are more pending works or not.  This may decrease
    the concurrency level to zero and stall execution until a new work
    item is queued on the gcwq.

    Make rescuer wake up a regular worker when it leaves a gcwq if
    there are more works to execute, so that execution isn't stalled.

    Signed-off-by: Tejun Heo <tj@kernel.org>
    Reported-by: Ray Jui <rjui@broadcom.com>
    Cc: stable@kernel.org

-- 
tejun
