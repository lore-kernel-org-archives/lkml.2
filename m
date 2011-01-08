Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1AHO4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 09:56:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46945 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1AHO4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 09:56:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=mwqc9RdSsgRiSm00F+dpX97TecX9UWPLES5InXbB0HUDNZgAfUSm0iP6f6b1bBJ+9Q
         M19EgzFptBFNN11oCpvKCNeGTk5O5kgIpVz9OoNJRx5cKLxV49nptMchb7287XLS7CQU
         f9nlvHHPxkqJFfpk54nxE2tfqWKa04Hx8McY0=
Message-ID: <4D287AED.9090304@gmail.com>
Date: Sat, 08 Jan 2011 06:55:41 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9pre) Gecko/20100821 Lanikai/3.1.3pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Screwing with the concurrency limit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First off, wild applause for cmwq. The limitations of the old workqueues 
were a major irritation, I think your new implementation is fabulous.

However, when merging bcache with mainline, I ran into a bit of a thorny 
issue. Bcache relies heavily on workqueues, updates to the cache's btree 
have to be done after every relevant IO completes. Additionally, btree 
insertions can involve sleeping on IO while the root of the tree isn't 
write locked - so we'd like to not block other work items from 
completing if we don't have to.

So, one might expect the way to get the best performance would be
   alloc_workqueue("bcache", WQ_HIGHPRI|WQ_MEM_RECLAIM, 0)

Trouble is, sometimes we do write lock the root of the btree, blocking 
everything else from getting anything done - the end result is
   root@moria:~# ps ax|grep kworker|wc -l
   1550

(running dbench in a VM with disks in tmpfs). Performance is fine (I 
think, haven't been trying to rigorously benchmark) but that's annoying.

I think the best way I can express it is that bcache normally wants a 
concurrency limit of 1, except when we're blocking and we aren't write 
locking the root of the btree.

So, do you think there might be some sane way of doing this with cmwq? 
Some way to say "Don't count this work item I'm in right now count 
against the workqueue's concurrency limit anymore". If such a thing 
could be done, I think it'd be the perfect solution (and I'll owe you a 
case of your choice of beer :)
