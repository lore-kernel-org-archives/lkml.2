Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2HGLKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:10:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60639 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab2HGLKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:10:08 -0400
MIME-Version: 1.0
In-Reply-To: <501EFED2.1070901@jp.fujitsu.com>
References: <501BC8BE.6000405@jp.fujitsu.com>
	<501C0CB6.7070409@colorfullife.com>
	<501EFED2.1070901@jp.fujitsu.com>
Date: Tue, 7 Aug 2012 13:10:07 +0200
Message-ID: <CALgW_8V=E0kuArcFCUXTOuNiay794Nd8tge=T65q0Fxp2Wnaow@mail.gmail.com>
Subject: Re: [PATCH] ipc/sem.c: prevent ENOMEM in semop() w/ SEM_UNDO flag
From: Manfred Spraul <manfred@colorfullife.com>
To: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seiichi,

2012/8/6 Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>
>
>
>  A real case was as follows.
>      semget(IPC_PRIVATE, 70000, IPC_CREAT | IPC_EXCL);
>      sops[0].sem_num = 0;
>      sops[0].sem_op  = 1;
>      sops[0].sem_flg = SEM_UNDO;
>      semop(semid, sops, 1);
>

I think this can't work: sops[].sem_num is defined as "unsigned short".
Thus more than 65500 semaphores in one semaphore set do not make
any sense.
"unsigned short" is also specified in the opengroup standard:

http://pubs.opengroup.org/onlinepubs/7908799/xsh/syssem.h.html

Thus: The hard limit is 65535. Perhaps slightly less, I haven't checked
if (-1) is used somewhere to indicate an error.

Is it possible to split the semaphores into multiple semphore ids?
e.g. 70 ids, each with 1000 semaphores?

The atomicity would be lost (e.g. all SEM_UNDO operations within
one id are performed at once. With 70 ids, the SEM_UNDOs are not
atomic anymore)

>
>    #define SEMMSL  250             /* <= 8 000 max num of semaphores per id */
>

As far as I can see your patch removes the last part of the code that
caused the restriction to 8.000 semaphores per id.

Thus I'd propose that your patch changes this line to

+ #define SEMMSL  250             /* <= 65 500 max num of semaphores per id */

And:
I would add a comment into the patch description all semaphores
from one id share a single kernel spinlock. This could be changed, but
it would
a) add complexity for all users and
b) change user space visible behavior
Thus I would prefer to avoid to implement it unless there are real
applications that need this implementation.

--
  Manfred
