Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0FNCRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 22:17:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60953 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab0FNCRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 22:17:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 14 Jun 2010 11:12:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: =?UTF-8?B?TMOhc3psw7M=?= Monda <laci@monda.hu>
Cc: Ed Tomlinson <edt@aei.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Hardcore trashing without any swap
Message-Id: <20100614111246.3149aba0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTikjsFsCZr0Eggwbm1RnvS07MYraHLLAK4fzjHNW@mail.gmail.com>
References: <AANLkTil0M_2aiRX5IoMzC90O9WgzJPco3arHmDSG_44H@mail.gmail.com>
	<20100611131652.053afebd@lxorguk.ukuu.org.uk>
	<AANLkTilPJYVbAJEEUMInaB9R4fUPPvq_pS3PdROpifIp@mail.gmail.com>
	<201006110947.24286.edt@aei.ca>
	<AANLkTikjsFsCZr0Eggwbm1RnvS07MYraHLLAK4fzjHNW@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 23:38:58 +0200
László Monda <laci@monda.hu> wrote:

> On Fri, Jun 11, 2010 at 3:47 PM, Ed Tomlinson <edt@aei.ca> wrote:
> > On Friday 11 June 2010 08:53:50 László Monda wrote:
> >> On Fri, Jun 11, 2010 at 2:16 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> > On Fri, 11 Jun 2010 02:10:33 +0200
> >> > László Monda <laci@monda.hu> wrote:
> >> >
> >> >> Hi List,
> >> >>
> >> >> The problem I'm facing with is very simple, yet extremely irritating
> >> >> in nature.  I have a laptop with 4G RAM and I don't use any swap.
> >> >> Whenever the RAM is full my system keeps trashing.  This makes X and
> >> >> SSH completely unresponsive for about a hour then a bunch of processes
> >> >> gets killed and it's usable again.
> >> >>
> >> >> How is possible that my system is trashing even though I don't use any swap?
> >> >
> >> > Because you don't have any swap. Its having to dump stuff it doesn't want
> >> > to like bits of applications that it can retrieve back from disk.
> >>
> >> I can read what you wrote but cannot really understand it.  Please
> >> tell me where my logic fails:
> >>
> >> No swap -> no dedicated space on disk to dump stuff -> no disk I/O
> >> should happen at all
> >
> > No.  This is not the case.  If the vm needs memory it will discard pages from that are
> > backed by objects _not_ stored in swap - like executables.  Only if there is nothing to
> > discard will it start killing...  That being said you need to read up on what Alan's
> > suggestion below does - or add a swapfile (which works nearly as well as a swap partition
> > now).
> 
> By reading your reply I think I understood what's going on.
> 
> Previously I thought that trashing can only happen because the kernel
> discards pages to swap which I thought is the only reason why disk I/O
> can happen in such a case.  It didn't made sense to me because I don't
> use swap.
> 
> The other possibility that occured to me is the following scenario:
> 1) Process A grows really big and fills up the RAM.
> 2) The kernel discards code pages from process B in favor of process A.
> 3) Process A has some RAM and keeps growing further until it almost
> fills up the RAM.
> 4) Process B gets scheduled and needs to be paged in which makes
> process A paged out, hence disk I/O occurs.
> 5) Process A gets scheduled and needs to be paged in which makes
> process B paged out, hence disk I/O occurs.
> 6) Go to 4)
> 
> This is not truly an infinite loop because the memory gradually gets
> filled up in 4) and 5) but it happens really slowly because process
> code has to be paged in upon every rescheduling.
> 
> So I've just realized that trashing cannot only happen due to paging
> out to swap.  It can also happen due to simply discarding code pages
> and paging them in later.
> 
> Is the above scenario valid in my case?
> 
> I suppose that the OOM killer could kill process A in step 3) right
> away but the scheduler is fast and the 4)-5) loop keeps making disk
> I/O for a very long time until process A exhausts the memory and the
> OOM killer intervenes eventually.
> 
> I've also realized that it's probably impossible to truly reliably
> foresee trashing so that's why there are no out of the box solutions
> for my problem.  The best hack I can think of is a daemon that
> monitors memory usage in about every 10 milisec and kills the biggest
> process if something seems to go wrong before trashing can begin.
> 
If you know possible memory eaters, can't be memory cgroup a help ? 
You can keep some important tasks by isolating workloads.

Thanks,
-Kame

