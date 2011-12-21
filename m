Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1LUHof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:44:35 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:44882 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1LUHod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:44:33 -0500
Message-ID: <1324453467.2610.20.camel@edumazet-laptop>
Subject: Re: Kernel-DOS error in arp mechanism =?UTF-8?Q?=E2=80=93?= no
 delete off incomplete arp adresses
From: Eric Dumazet <eric.dumazet@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>,
        David Miller <davem@davemloft.net>
Cc: Robert Gladewitz <gladewitz@gmx.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 21 Dec 2011 08:44:27 +0100
In-Reply-To: <CAFLxGvxjLCyMCPXtpm7a7RaOL4A4=bhCLPKD=FVAc8xOdx_CsQ@mail.gmail.com>
References: <4EEC5286.3070408@gmx.de>
	 <CAFLxGvxjLCyMCPXtpm7a7RaOL4A4=bhCLPKD=FVAc8xOdx_CsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 17 décembre 2011 à 14:26 +0100, richard -rw- weinberger a
écrit :
> On Sat, Dec 17, 2011 at 9:27 AM, Robert Gladewitz <gladewitz@gmx.de> wrote:
> > Hello,
> >
> > first i have to say sorry for m y bad english. I try my best to descripe the
> > error.
> >
> > I Use Linux-Routers for internal and external firewall components. For this
> > I Use own kernel configurations und use only the drivers an modules what I
> > need. Other features and modules I deactivated in my kernel versions
> >
> > Since the kernel version 2.6.36 there is some mistake in the ipv4 arp
> > implementation. The the System try to find an unknown system, the send an
> > “who is” and marked the ip address as “incomplete” (German: unvollständig).
> > The thing is, usually linux delete all incomplete and complete entries in
> > some time, but in all kernel versions since 2.6.36 he doas not delete any
> > addresses.
> >
> > In my case, I scan my network-segmens for new devices (Kaspersky, Landesk)
> > and on this process, the router learned a lot of incomplete addresses. I
> > have some class b networks (from the history), and this means the router
> > will be learned mor then 2^16 adresses.
> >
> > Now the kerlen learn a maximum addresses – I know this is defined on
> > gc_thresh1 , gc_thresh2 and gc_thresh3 in the proc system under
> > sys.net.ipv4.neight.default. If the table have the maximum addresses in the
> > table (default=1024), no new host can send traffic packet over this router.
> > This means, we have a classical risk of DOS. In my case, I have only an
> > internal risk, but some providers may have also external risc.
> >
> > I hope, my description help you to find this error. I send also my kernel
> > config, may there is some relation to small configurations in kernel
> >
> > Viele Grüße
> >
> > Robert Gladewitz
> >
> 
> CC'ing netdev.
> 

Hmm, it seems we removed the ip route garbage collection too soon.

In the old times, we had a mechanism (rt_check_expire()) to remove old
route cache entries, but not anymore, so we can have some slots in IP
route cache referencing neighbours entries for infinite amount of time.

8.0.0.72 dev eth3  ref 2 used 1038/1098/1035 probes 6 FAILED
8.0.0.205 dev eth3  ref 2 used 639/699/636 probes 6 FAILED
8.0.0.82 dev eth3  ref 2 used 1008/1068/1005 probes 6 FAILED
8.0.0.215 dev eth3  ref 2 used 609/669/606 probes 6 FAILED

In 2.6.39, commit 2c8cec5c10bc (ipv4: Cache learned PMTU information in
inetpeer.) removed rt_check_expire() and added this problem.

David, I suggest we add back the garbage collector for current kernels,
we'll remove it when route cache really disappear ?

I'll send a patch today.


