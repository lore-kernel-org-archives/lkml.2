Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab1BORaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:30:09 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:34072 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755816Ab1BORaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:30:05 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: JfrivggVM1m47FCdSasw4KgAfSdBnfWBYYH6rydXkbG1Mrd
 hL9ealisZEufm8NwQlnMiWyKL3Ztt3Axl5FB4gzk0Ggb081wQQZhBVhQ5e8H
 _AhMnDbmTF6V3zjQ3mZTkXMtQ4cRqu6AIpPtq4_lJRzJWoN1zSOA9Zm1rFOc
 EhZfOTrQ3NyeKsDTFPXdn9teuKt64dqJRPTlUeh293NWzU4LCI_M.9WrZcdz
 KNyHv45SdilTlR_AuYwZuV2GyAKpCxEYZOguqzDEzG0x3a0_xl6gxfe7B5j9
 .JCB1g_Gisjwq2fM9TaHZoZpQB3JfwGxiRnuDB30CSlE_Afc-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 15 Feb 2011 11:30:02 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Kruse <pk@q-leap.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
In-Reply-To: <4D5A2EDB.8060603@q-leap.com>
Message-ID: <alpine.DEB.2.00.1102151040560.10511@router.home>
References: <4D53FE43.8030106@q-leap.com> <alpine.DEB.2.00.1102141046170.26158@router.home> <4D5A2EDB.8060603@q-leap.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <alpine.DEB.2.00.1102151040562.10511@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Peter Kruse wrote:

> > > we have set vm.min_free_kbytes = 2097152 but the problem
> > > obviously did not go away.
> >
> > 2GB of reserves? How much memory does your system have?
>
> 48GB

Ok then you just may potentially clog up the DMA zones. Maybe set the
reserves to a reasonable level like 10M or so?

How many buffers are configured at the various levels for the device that
is receiving messages? I guess that may be a bit on the high side?

> > Could you post the entire messages from the kernel log? We need the OOM
> > info to figure out more about the problem.
> >
>
> I attach one of the call traces, or would it be better if I send the
> kern.log (about 6MB)?

The call traces are sufficient but the traces vanished when I hit reply.
Include them inline next time. It would be good to have the log starting
at the last system boot. There is some information cut off that I would to
see.

An atomic order 1 allocation failed and led to the OOM but it seems that
there is still ample memory available. Slab is in "fallback_alloc" so
something went wrong with the regular allocation attempt. Any use of
cpusets or cgroups?

A significant amount of memory has been allocated to reclaimable slabs.
I guess these are the socket buffers?

Feb 10 11:59:49 beosrv1-t kernel: [1968911.211777] Node 0 Normal
free:965164kB min:917952kB low:1147440kB high:1376928kB
active_anon:2742680kB inactive_anon:293184kB active_file:4801512kB
inactive_file:11129708kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:21719040kB mlocked:0kB dirty:600kB
writeback:0kB mapped:26356kB shmem:4896kB slab_reclaimable:1780208kB <-----!!
slab_unreclaimable:199576kB kernel_stack:1576kB pagetables:22956kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no

Could you try to reduce the number of network buffers?

