Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab1FRA27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 20:28:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37967 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1FRA26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 20:28:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GhyB7OFtmQWxokkV80Z/gRDz4y/8t0tsI5Mt/O4liHZZywL4rkDvL+/77civO1icRt
         4w9+e0tM3KcZlfqor7kQ==
MIME-Version: 1.0
In-Reply-To: <4DFB1AB6.4020104@jp.fujitsu.com>
References: <20110503092846.022272244@google.com> <20110614065807.GA19111@localhost.localdomain>
 <4DF70DED.2030803@jp.fujitsu.com> <20110615083749.GA14200@localhost.localdomain>
 <4DF954E5.9060704@jp.fujitsu.com> <20110616094508.GA1961@localhost.localdomain>
 <4DFAAC6B.6060306@jp.fujitsu.com> <BANLkTikDYdxed6=C6Lfht3WZM-=HSqDDKA@mail.gmail.com>
 <4DFB1AB6.4020104@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Jun 2011 17:28:24 -0700
Message-ID: <BANLkTimt1dYMHtPtb0H8UGSiiJjUpE3deQ@mail.gmail.com>
Subject: Re: [patch 00/15] CFS Bandwidth Control V6
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Hu Tao <hutao@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.co>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 2:13 AM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> (2011/06/17 15:25), Paul Turner wrote:
>> It should be out in a few hours, as I was preparing everything today I
>> realized an latent error existed in the quota expiration path;
>> specifically that on a wake-up from a sufficiently long sleep we will
>> see expired quota and have to wait for the timer to recharge bandwidth
>> before we're actually allowed to run.  Currently munging the results
>> of fixing that and making sure everything else is correct in the wake
>> of those changes.
>
> Thanks!
> I'll check it some time early next week.

So it's been a long session of hunting races and implementing the
cleanups above.

Unfortunately as my finger hovered over the send button I realized one
hurdle remains  -- there's a narrow race in the period timer shutdown
path:

- Our period timer can decide that we're going idle as a result of no activity
- Right after it makes this decision a task sneaks in and runs on
another cpu.  We can see the timer has chosen to go idle (it's
possible to  synchronize on that state around the bandwidth lock) but
there's no good way to kick the period timer into an about-face since
it's already active.
- The timing is sufficiently rare and short that we could do something
awful like spin until the timer is complete, but I think it's probably
better to put a kick in one of our already existing re-occuring paths
such as update_shares.

I'll fix this after some sleep, I'm out of steam for now.


>
>
> Thanks,
> H.Seto
>
>
