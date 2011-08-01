Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab1HARZC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:25:02 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:36098 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab1HARY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:24:58 -0400
Date: Mon, 1 Aug 2011 21:24:52 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Richard Weinberger <richard@nod.at>, serge.hallyn@canonical.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, toralf.foerster@gmx.de
Subject: Re: shm updates broke UML
Message-ID: <20110801172452.GA26190@albatros>
References: <201108011541.59640.richard@nod.at>
 <20110801134911.GA11705@albatros>
 <43e4e9e98b32d3d3eb06ab837a019ad8@localhost>
 <20110801171042.GA25954@albatros>
 <08cf4697685ecd9bcb7e4eefe516f2ee@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08cf4697685ecd9bcb7e4eefe516f2ee@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 19:19 +0200, Marc Zyngier wrote:
> Here you go (sorry about the line wrapping, damned webmail...):

Thank you!  Now I see that the problem is rw_mutex is not initialized:

	down_write(&shm_ids(ns).rw_mutex);

void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
{
    ...
	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
                                         ^^^^^^^^^^^^^^^ is NULL

Wtf - ipc namespace should be fully initialized for the moment of
threads run...

> Calibrating local timer... 104.99MHz.
> CPU1: Booted secondary processor
> CPU1: Unknown IPI message 0x1
> CPU2: Booted secondary processor
> CPU2: Unknown IPI message 0x1
> CPU3: Booted secondary processor
> CPU3: Unknown IPI message 0x1
> Brought up 4 CPUs
> SMP: Total of 4 processors activated (333.41 BogoMIPS).
> ns = c0447474, ids = c04474d0
> ns = c0447474, ids = c04474d0
> wait_list = c04474e0
> next =   (null)
           ^^^^^^

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
