Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0DOULZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 16:11:25 -0400
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:54999 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab0DOULW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 16:11:22 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2010 16:11:22 EDT
Date: Thu, 15 Apr 2010 23:03:24 +0300 (EEST)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: Arnd Bergmann <arnd@arndb.de>
cc: dgilbert@interlog.com, Jens Axboe <axboe@kernel.dk>,
       Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [RFC] block: replace BKL with global mutex
In-Reply-To: <201004151629.45029.arnd@arndb.de>
Message-ID: <alpine.LNX.2.00.1004152244160.5127@kai.makisara.local>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de> <201004150911.45842.arnd@arndb.de> <4BC7117C.7090208@interlog.com> <201004151629.45029.arnd@arndb.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010, Arnd Bergmann wrote:

> On Thursday 15 April 2010, Douglas Gilbert wrote:
> > At the level of SCSI commands, tape device state assumptions
> > made by the st driver could be compromised by SCSI commands
> > sent by the sg driver. However the BKL was never meant
> > to address that concern.
> > 
...
> > So I would not be concerned about any kernel locking
> > interactions between the sg and st drivers. I have
> > added Kai Makisara (st maintainer) to the cc list.
> 
> Ok. I've also checked st.c again and noticed that it
> doesn't use use the BKL in ioctl() but only in open(),
> which is very unlikely to race against anything in sg.c
> or the block subsystem.
> 
Using sg with a tape opened by st may lead to incorrect state within st. 
However, to prevent this would be far too complicated and so the 
coordination responsibility is left to the user. (There are some 
cases where use of both sg and st can be justified but then the user 
should know what he/she is doing and properly serialize access in user 
space.)

BKL does not have any "hidden duties" in open() in st.c. I don't know any 
reason why it would be needed, but, because I have not been absolutely 
sure, I have not removed it. (The tape devices are not opened often and so 
the overhead has been negligible. That is, while BKL has been available.) 
If you don't see any reason for BKL in open(), go ahead and remove it.

Kai

