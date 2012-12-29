Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2L2K1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 05:27:33 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:54250 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2L2K1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 05:27:31 -0500
MIME-Version: 1.0
In-Reply-To: <1356549008.20133.20856.camel@edumazet-glaptop>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	<20121221185147.4ae48ab5@annuminas.surriel.com>
	<20121221185613.1f4c9523@annuminas.surriel.com>
	<20121222033339.GF27621@home.goodmis.org>
	<50D52E0C.6000103@redhat.com>
	<1356549008.20133.20856.camel@edumazet-glaptop>
Date: Sat, 29 Dec 2012 02:27:29 -0800
Message-ID: <CANN689HBx357M+7ge3SQ_xtnyiTKPY=1v0oR+DS9EBiak-2BQg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay factor
From: Michel Lespinasse <walken@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, aquini@redhat.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Herbert <therbert@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 11:10 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> I did some tests with your patches with following configuration :
>
> tc qdisc add dev eth0 root htb r2q 1000 default 3
> (to force a contention on qdisc lock, even with a multi queue net
> device)
>
> and 24 concurrent "netperf -t UDP_STREAM -H other_machine -- -m 128"
>
> Machine : 2 Intel(R) Xeon(R) CPU X5660  @ 2.80GHz
> (24 threads), and a fast NIC (10Gbps)
>
> Resulting in a 13 % regression (676 Mbits -> 595 Mbits)

I've been trying to use this workload on a similar machine. I am
getting some confusing results however:

with 24 concurrent netperf -t UDP_STREAM -H $target -- -m 128 -R 1 , I
am seeing some non-trivial run-to-run performance variation - about 5%
in v3.7 baseline, but very significant after applying rik's 3 patches.
my last few runs gave me results of 890.92, 1073.74, 963.13, 1234.41,
754.18, 893.82. This is generally better than what I'm getting with
baseline, but the variance is huge (which is somewhat surprising given
that rik's patches don't have the issue of hash collisions). Also,
this is significant in that I am not seeing the regression you were
observing with just these 3 patches.

If I add a 1 second delay in the netperf command line (netperf -t
UDP_STREAM -s 1 -H lpk18 -- -m 128 -R 1), I am seeing a very constant
660 Mbps result, but then I don't see any benefit from applying rik's
patches. I have no explanation for these results, but I am getting
them very consistently...

> In this workload we have at least two contended spinlocks, with
> different delays. (spinlocks are not held for the same duration)

Just to confirm, I believe you are refering to qdisc->q.lock and
qdisc->busylock ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
