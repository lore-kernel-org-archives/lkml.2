Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1HQV54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 17:57:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65212 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1HQV5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 17:57:54 -0400
Message-ID: <4E4C395E.20000@gmail.com>
Date: Wed, 17 Aug 2011 23:57:50 +0200
From: Nebojsa Trpkovic <trx.lists@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110729 Thunderbird/5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: cleancache can lead to serious performance degradation
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I've tried using cleancache on my file server and came to conclusion 
that my Core2 Duo 4MB L2 cache 2.33GHz CPU cannot cope with the amount 
of data it needs to compress during heavy sequential IO when 
cleancache/zcache are enabled.

For an example, with cleancache enabled I get 60-70MB/s from my RAID 
arrays and both CPU cores are saturated with system (kernel) time. 
Without cleancache, each RAID gives me more then 300MB/s of useful read 
throughput.

In the scenario of sequential reading, this drop of throughput seems 
completely normal:
- a lot of data gets pulled in from disks
- data is processed in some non CPU-intensive way
- page cache fills up quickly and cleancache starts compressing pages (a 
lot of "puts" in /sys/kernel/mm/cleancache/)
- these compressed cleancache pages newer get read because there are a 
whole lot of new pages coming in every second replacing old ones 
(practically no "succ_gets" in /sys/kernel/mm/cleancache/)
- CPU saturates doing useless compression, and even worse:
- new disk read operations are waiting for CPU to finish compression and 
make some space in memory


So, using cleancache in scenarios with a lot of non-random data 
throughput can lead to very bad performance degradation.


I guess that possible workaround could be to implement some kind of 
compression throttling valve for cleancache/zcache:

- if there's available CPU time (idle cycles or so), then compress 
(maybe even with low CPU scheduler priority);

- if there's no available CPU time, just store (or throw away) to avoid 
IO waits;


At least, there should be a warning in kernel help about this kind of
situations.


Regards,
Nebojsa Trpkovic



