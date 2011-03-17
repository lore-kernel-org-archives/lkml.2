Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab1CQRwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:52:31 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:34023 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754971Ab1CQRw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:52:27 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ngDl27IVM1lGWwUBJp2QfWtKY8Hub7VqmhdeObj7bduvR37
 AoT3joHZ7DOEQ_6PR1dY.2dsZsZETP_rYI5c3wLL4AUoqgbkb38KisxlxDj8
 pHTRNAKURLH0rtIhnH9KPcPxaySm0gzvedDFCSXH3o98T2sB.iPR_qpOFLUU
 7BieldmxpTFM5pSX2mBYoDmM1duaMPstjc607lzMURR2nQz9wegLrd5tAits
 UvC.A7mZDAH1xaAve0tfvxzPSrYhS2tWErCArlUbI8KldeAcJ8_NVXmwRW0N
 YTYkqV5qGAjTxYJbuw9fprAuTI0Ko_n6x_7YV6F02NKhW6IIL
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 17 Mar 2011 09:40:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: Poll about irqsafe_cpu_add and others
In-Reply-To: <1300371834.6315.93.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1103170932430.12540@router.home>
References: <1300371834.6315.93.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Eric Dumazet wrote:

> irqsafe_cpu_{dec|inc} are used in network stack since 2.6.37 (commit
> 29b4433d991c88), and I would like to use irqsafe_cpu_add() in netfilter
> fast path too, and SNMP counters eventually (to lower ram needs by 50%)
>
> Initial support of irqsafe_ was given by Christoph in 2.6.34
>
> It seems only x86 arch is using a native and efficient implementation.

I have some draft(y old) patches for IA64 that use fetchadd together with
a per cpu virtual address range mapped differently for each processor but
in general the problem with other arches is that they do not have
instructions that avoid the expensive bus arbitration for a cacheline nor
do they have segment overrides.

The segment override effect of implicit relocation of the address to the
correct percpu area within one instruction can also be accomplished (like
in the IA64 case) if we have per cpu page tables for the kernel and map
the same virtual addres to different physical addresses for each cpu. Then
the address given to a percpu instruction is constant and the relocation
is performed implicitly by the MMU. Thus the relocation and the RMW
operation are "atomic". Either both occur or none.

The other aspect is that the arch must have cheap increment (and other
RMW) instructions that avoids expensive in cpu processing to establish a
coherent state of the cacheline.

> What about defining a HAVE_FAST_IRQSAFE_ADD ?

Useful at some point I think.

