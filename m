Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0HPOyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:54:15 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:55485 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab0HPOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:54:14 -0400
Message-ID: <4C6950B3.8020702@linux.vnet.ibm.com>
Date: Mon, 16 Aug 2010 16:52:35 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        unsik Kim <donari75@gmail.com>,
        Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
        Heiko Carstens <heicars2@linux.vnet.ibm.com>
Subject: [RFC] Switching block device elevators
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 1abec4fdbb142e3ccb6ce99832fae42129134a96, "block: make 
blk_init_free_list and elevator_init idempotent", we're seeing kernel 
panics in our s390 tape block device driver. The panic is triggered 
because our driver tries to replace the default elevator with a noop 
elevator by calling elevator_exit() directly followed by elevator_init().

Since the commit, elevator_init() returns 0 if request_queue->elevator 
is non-null, even though it does not install a new elevator. As a 
result, the next access to the elevator finds a pointer to the old one 
which was already freed and a panic is triggered. Our current fix 
consists of setting the elevator pointer to NULL after elevator_exit().

There is at least one other driver where the problem currently exists 
(drivers/block/mg_disk.c, author on cc) and another s390 driver where 
the problem was only accidentally fixed before 2.6.35. I'm wondering if 
there's a better solution (apart from not forcing an elevator) and would 
like to hear everyone's opinion on this matter. How about declaring 
elevator_switch() non-static, for example?


Regards,
   Peter Oberparleiter

