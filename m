Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1GJAag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 20:30:36 -0400
Received: from mx.treblig.org ([80.68.94.177]:52107 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab1GJAaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 20:30:35 -0400
Date: Sun, 10 Jul 2011 01:30:32 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: teigland@redhat.com
Cc: jj@chaosbits.net, linux-kernel@vger.kernel.org
Subject: kmallocs with swapped parameters in fs/dlm/lock.c
Message-ID: <20110710003032.GA19951@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.27-kvm-i386-20110114 (i686)
X-Uptime: 01:15:32 up 142 days,  1:48,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
  Sparse spotted a couple of places in fs/dlm/lock.c where the size/flags
parameters to kmalloc got swapped:

The sparse output is:
fs/dlm/lock.c:852:42: warning: incorrect type in argument 1 (different base types)
fs/dlm/lock.c:852:42:    expected unsigned long [unsigned] [usertype] size
fs/dlm/lock.c:852:42:    got restricted gfp_t
fs/dlm/lock.c:852:64: warning: incorrect type in argument 2 (different base types)
fs/dlm/lock.c:852:64:    expected restricted gfp_t [usertype] flags
fs/dlm/lock.c:852:64:    got unsigned long
fs/dlm/lock.c:4136:27: warning: incorrect type in argument 1 (different base types)
fs/dlm/lock.c:4136:27:    expected unsigned long [unsigned] [usertype] size
fs/dlm/lock.c:4136:27:    got restricted gfp_t
fs/dlm/lock.c:4136:39: warning: incorrect type in argument 2 (different base types)
fs/dlm/lock.c:4136:39:    expected restricted gfp_t [usertype] flags
fs/dlm/lock.c:4136:39:    got unsigned long

Line 852 is:
                        warned = kmalloc(GFP_KERNEL, num_nodes * sizeof(int));
Line 4136 is:
        ms_stub = kmalloc(GFP_KERNEL, sizeof(struct dlm_message));

and at least one of the defs of kmalloc is:
slab_def.h:static __always_inline void *kmalloc(size_t size, gfp_t flags)

Given that I haven't got a clue how to test a dlm, it's probably
best that you patch it.

Jesper:
  I noticed in your patch:
https://lkml.org/lkml/2011/7/2/90

where you had done a kmalloc->kzalloc transform you kept the swap.

This looks like new code in 3.0rc so I don't think you could quite
call it a regression, but it should probably be fixed fairly quickly
I guess.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
