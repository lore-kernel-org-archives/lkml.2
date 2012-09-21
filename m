Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2IUOZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:25:54 -0400
Received: from mail.anarazel.de ([217.115.131.40]:57946 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab2IUOZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:25:52 -0400
From: Andres Freund <andres@anarazel.de>
To: Jagdish Motwani <jagdish.motwani@elitecore.com>
Subject: Re: performance degradation on kernel upgrade (due to commit ab0a9735e06914ce4d2a94ffa41497dbc142fe7f)
Date: Fri, 21 Sep 2012 16:25:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc6-andres-00066-g2682cc4-dirty; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <505C700C.3010403@elitecore.com>
In-Reply-To: <505C700C.3010403@elitecore.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209211625.42895.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, September 21, 2012 03:47:56 PM Jagdish Motwani wrote:
> Recently i upgraded my kernel from 2.6.29.6 to 2.6.35.14.
> 
> After upgrading i got very poor performance on my postgre database.
> 
> 
> My test.sql contains 10000 postgre insert query
> 
> 
> Linux  2.6.29.6
> 
> time psql -U user -d database -f test.sql  > /dev/null
> real    0m 7.23s
> user    0m 0.38s
> sys     0m 0.12s
> 
> 
> 
> Linux  2.6.35.14
> 
> # time psql -U user -d database -f test.sql  > /dev/null
> real    1m 4.05s
> user    0m 0.44s
> sys    0m 0.12

How do the results to this look if you use psql -1/--single-transaction?

> I even tried Linux 3.5.4 and got similar results.
> 
> Using git bisect, i got commit ab0a9735e06914ce4d2a94ffa41497dbc142fe7f
> 
> Is it a behavior change or am i missing something? Are there any
> workarounds for this?
I guess youre using some form of virtualization? I think what youre observing 
is just that access via raw devices previously lied about consistency. As the 
commit observes several virtualization solutions can use raw device access.

If all those 10000 inserts above happen in individual transactions - which 
would happen if youre not using transactions explicitly -  each and every one 
of them will cause a single disk write if they are executed sequentially.
A typical rotating disks can do between 80-160 such writes. If you devide 10k 
transactions by 150 synchronous writes a second you get ~66s which pretty 
nicely fits your time above.

If you don't care about loosing a very small amount of transactions (up to a 
second with the default settings) you can disable the synchronous_commit 
setting in postgres. No earlier commits/changes will be lost/corrupted.
You can change that setting per transaction, per session/connection, per user, 
per database or globally.

Greetings,

Andres
