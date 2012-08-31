Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2HaSko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:40:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab2HaSkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:40:43 -0400
Date: Fri, 31 Aug 2012 14:40:26 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: [PATCH 0/4] Fix a crash when block device is read and block size is
 changed at the same time
In-Reply-To: <Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com> 
 <20120628111541.GB17515@quack.suse.cz>  <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
  <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com> 
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com> 
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com> 
 <1343508252.2626.13184.camel@edumazet-glaptop> 
 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com> 
 <1343556630.2626.13257.camel@edumazet-glaptop> <1343586962.2626.13266.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is a series of patches to prevent a crash when when someone is 
reading block device and block size is changed simultaneously. (the crash 
is already happening in the production environment)

The first patch adds a rw-lock to struct block_device, but doesn't use the 
lock anywhere. The reason why I submit this as a separate patch is that on 
my computer adding an unused field to this structure affects performance 
much more than any locking changes.

The second patch uses the rw-lock. The lock is locked for read when doing 
I/O on the block device and it is locked for write when changing block 
size.

The third patch converts the rw-lock to a percpu rw-lock for better 
performance, to avoid cache line bouncing.

The fourth patch is an alternate percpu rw-lock implementation using RCU 
by Eric Dumazet. It avoids any atomic instruction in the hot path.

Mikulas
