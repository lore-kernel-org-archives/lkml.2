Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab1CBPIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:08:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55477 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1CBPId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:08:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH 4/7] ufs: remove the BKL
Date: Wed, 2 Mar 2011 16:08:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
        Nick Piggin <npiggin@gmail.com>
References: <1299021191-17961-1-git-send-email-arnd@arndb.de> <1299021191-17961-5-git-send-email-arnd@arndb.de> <20110302144705.GA15482@elliptictech.com>
In-Reply-To: <20110302144705.GA15482@elliptictech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103021608.31875.arnd@arndb.de>
X-Provags-ID: V02:K0:fq+XjXqJ5UXCneEA5IQKIxog+EdtZKh73KJkcqM7W7Y
 gg1lh3S96B+uldZi04rC4OJsY0OTeCN0iVTfjIgak6+zckL+mQ
 KSQqPTHG04OsRfppTq9oLicMEfE3XWmSEjRlMMtKfXzeDCvxFt
 2xEBWfiO6P4xwAZ9QKCluJSTAlgBSef6QG7vAyoGAqUXoeRrP1
 W1/p+qcL6MdGI+ecvJnlg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 March 2011, Nick Bowler wrote:
> On 2011-03-02 00:13 +0100, Arnd Bergmann wrote:
> > This introduces a new per-superblock mutex in UFS to replace
> > the big kernel lock. I have been careful to avoid nested
> > calls to lock_ufs and to get the lock order right with
> > respect to other mutexes, in particular lock_super.
> > 
> > I did not make any attempt to prove that the big kernel
> > lock is not needed in a particular place in the code,
> > which is very possible.
> > 
> > The code is still only compile-tested,
> 
> This isn't true anymore; I've been running with this patch (well, the
> previous versions thereof) for some time now.  On the other hand, I
> don't use all of this driver's features.

I'll updated the comment. Can I add your Tested-by tag?

> > but it should at least be harmless on non-SMP systems, since the new
> > mutex is not taken on those.
> 
> I think this part of the patch is strange.  It seems like a gratuitous
> difference between SMP/preempt and other systems to #if out the code
> that takes the mutex.  This might make problems with the conversion fly
> under the radar longer because people with older systems won't encounter
> them.

I agree it is strange, but the mutex has some serious performance impact
that I wanted to minimize on the systems where we know it is not needed.
The BKL was only active on those systems, so we know that non-SMP
non-preempt kernels don't need the mutex.

	Arnd
