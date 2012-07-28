Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab2G1DlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 23:41:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab2G1DlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 23:41:03 -0400
Message-ID: <1343446862.8073.8.camel@ul30vt>
Subject: Re: more interrupts (lower performance) in bare-metal compared with
 running VM
From: Alex Williamson <alex.williamson@redhat.com>
To: sheng qiu <herbert1984106@gmail.com>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Date: Fri, 27 Jul 2012 21:41:02 -0600
In-Reply-To: <CAB7xdi=DrE356=U1Jr1Z=ROo2X3XNM5uKcgiZJTKY+EdsTu7gw@mail.gmail.com>
References: <CAB7xdi=DrE356=U1Jr1Z=ROo2X3XNM5uKcgiZJTKY+EdsTu7gw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 22:09 -0500, sheng qiu wrote:
> Hi all,
> 
> i am comparing network throughput performance under bare-metal case
> with that running VM with assigned-device (assigned NIC). i have two
> physical machines (each has a 10Gbit NIC), one is used as remote
> server (run netserver) and the other is used as the target tested one
> (run netperf with different send message size, TCP_STREAM test). the
> remote NIC is connected directly with the tested NIC, both are 10Gbit.
> fore bare-metal case, i enable 1 cpu core, for VM i also configure 1
> vcpu (the memory is sufficient for both bare-metal and VM case).  i
> run netperf for 120 seconds and got the following results:
> 
>                        send message    interrupts   throughput (mbit/s)
> bare-metal             256               10696290            1114.84
>                             512               10106786            1391.92
>                             1024              10071032           1508.09
>                             2048              4560857             3434.65
>                             4096              3292200             4762.26
>                             8192              3169801             4733.89
>                             16384            2780529              4892.6
> 
> VM(assigned NIC)   256               3817904              2249.35
>                              512               3599007              4342.81
>                             1024              3005601              4134.69
>                              2048             2952122              4484
>                              4096             2682874              4566.34
>                              8192             2786719              4734.39
>                              16384           2603835              4540.47
> 
> as shown, the interrupts for bare-metal case is much more than the VM
> case for some message size. we also see the throughput for those
> situations is lower than VM case. it's strange that the bare-metal has
> lower performance than the VM case. Does anyone have comments on this?
> i am very confused.

Assigned devices have more latency in the interrupt path since the
interrupt goes through both the host and the guest interrupt stack.  My
guess is that you're approaching the interrupt rate we can handle due to
that added latency.  That's the bad news.  The good news is that the
device must be queuing up packets, so more are processed on each
interrupt.  Once we switch to non-threaded interrupt handling in the
host, that peak interrupt rate should get a significant increase.
TCP_RR is probably a better way to get a feel for interrupt latency.
That's my theory, any others?  Thanks

Alex

