Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2KGUsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:48:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38422 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2KGUsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:48:21 -0500
Message-ID: <509AC911.1040700@gmail.com>
Date: Wed, 07 Nov 2012 21:48:17 +0100
From: Erwan Velu <erwanaliasr1@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.9) Gecko/20121014 Thunderbird/10.0.9
MIME-Version: 1.0
To: ak@linux.intel.com, axboe@kernel.dk
CC: linux-kernel@vger.kernel.org
Subject: Unexpected latencies on lseek() SEEK_SET on block devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi fellows,

I'm been facing some lseek() troubles on a very light hardware (Atom E660) under heavy load (network + cpu  + disk IOs). I'm using 3.2.32 on a 32bit Os with a local SSD as mass storage.

If a do open a block device like sdb1 and lseek SEEK_SET in it, some unexpected latencies occurs.
Using the same load, everything works perfectly by using contigous streams but once I do lseek it start to be laggy. I've been searching around for a while and finally found this message : https://lkml.org/lkml/2011/9/15/399 from Andy.

The description was very similar to what I experienced but the patch from Andy was on to the fs layer.

I've been looking the code for the block level layer and found the implementation is pretty different.
http://lxr.linux.no/#linux+v3.2.33/fs/read_write.c#L69
vs
http://lxr.linux.no/#linux+v3.2.33/fs/block_dev.c#L353

As I can see, we do first put the mutex, then i_size_read and then considering the kind of SEEK we want.
The semantic changes from the read_write implementation where it does the locking only for SEEK_CUR and i_size_read isn't executed for SEEK_SET.

So I really wonder if we shall rework this part to avoid the uncessary locking for all of them except SEEK_CUR and remove i_size_read from SEEK_SET. The i_size_read is also a matter as it does a memory barrier. On such low-end hardware I have, that could costs.

I can work on it and validate its performances unless the experts you are told me this is a mandatory feature.

Thanks for your attention and comments on this topic.

Erwan,
