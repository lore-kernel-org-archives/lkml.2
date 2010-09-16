Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab0IPT0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:26:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab0IPT0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:26:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: Re: Remaining BKL users, what to do
Date: Thu, 16 Sep 2010 21:26:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-next-20100910+; KDE/4.5.1; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Petr Vandrovec <vandrove@vc.cvut.cz>, Anders Larsen <al@alarsen.net>,
        Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>, Samuel Ortiz <samuel@sortiz.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>
References: <201009161632.59210.arnd@arndb.de> <20100916190025.GG24296@cs.cmu.edu>
In-Reply-To: <20100916190025.GG24296@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009162126.11515.arnd@arndb.de>
X-Provags-ID: V02:K0:gQer4Fi5hCibwPGGMHKJwwPVGqBowQ8o/uQYoOQ6sPz
 ZAF4bN6+OBstrzbpQ3ALxSnVttCT9p6sSzA6OjNoEXBQr8TucM
 ckgcdxJa18VHW7BOzwsv4d5YJYeDUnxFM2X6OCbBVjmtTH5p5Z
 EMl1lnczu7SLDuQwiLw2VNoEd2dxZ9+ycZXjFrxXjMdUoTUbUs
 xHJgY2OVvh3jnMBuYdAhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 September 2010 21:00:25 Jan Harkes wrote:
> >       Just removing the BKL without the Coda community seems like a heap
> >       of pointless work.
> 
> It depends, it might get rid of that mount lockup. There shouldn't be
> too much shared state because the kernel module mostly just forwards
> requests to userspace and the BKL right now seems to be mostly used to
> protects access to the upcall lists and could probably without too much
> trouble be replaced with a single 'global' (but Coda-only) or
> mount-point specific mutex.

Ok, that would be nice.

There are two strategies forward then based on the current code:

1. introduce a global or per-superblock mutex and convert all
instances of lock-kernel to that, then see what breaks (lockdep
helps here) and fix up all places where you get potential
deadlocks. The easiest replacement would be the existing superblock
mutex, doing s/lock_kernel()/lock_super(sb)/.

2. understand what data structures are actually being protected
by the BKL right now, then add proper locking around all accesses
to them and finally remove all uses of the BKL.

	Arnd
