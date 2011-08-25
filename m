Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab1HYEM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 00:12:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:57486 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1HYEMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 00:12:24 -0400
Date: Thu, 25 Aug 2011 00:12:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Nebojsa Trpkovic <trx.lists@gmail.com>, dan.magenheimer@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: cleancache can lead to serious performance degradation
Message-ID: <20110825041212.GA5014@dumpdata.com>
References: <4E4C395E.20000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4C395E.20000@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4E55CBA7.0092,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 11:57:50PM +0200, Nebojsa Trpkovic wrote:
> Hello.

I've put Dan on the CC since he is the author of it.

> 
> I've tried using cleancache on my file server and came to conclusion
> that my Core2 Duo 4MB L2 cache 2.33GHz CPU cannot cope with the
> amount of data it needs to compress during heavy sequential IO when
> cleancache/zcache are enabled.
> 
> For an example, with cleancache enabled I get 60-70MB/s from my RAID
> arrays and both CPU cores are saturated with system (kernel) time.
> Without cleancache, each RAID gives me more then 300MB/s of useful
> read throughput.
> 
> In the scenario of sequential reading, this drop of throughput seems
> completely normal:
> - a lot of data gets pulled in from disks
> - data is processed in some non CPU-intensive way
> - page cache fills up quickly and cleancache starts compressing
> pages (a lot of "puts" in /sys/kernel/mm/cleancache/)
> - these compressed cleancache pages newer get read because there are
> a whole lot of new pages coming in every second replacing old ones
> (practically no "succ_gets" in /sys/kernel/mm/cleancache/)
> - CPU saturates doing useless compression, and even worse:
> - new disk read operations are waiting for CPU to finish compression
> and make some space in memory
> 
> 
> So, using cleancache in scenarios with a lot of non-random data
> throughput can lead to very bad performance degradation.
> 
> 
> I guess that possible workaround could be to implement some kind of
> compression throttling valve for cleancache/zcache:
> 
> - if there's available CPU time (idle cycles or so), then compress
> (maybe even with low CPU scheduler priority);
> 
> - if there's no available CPU time, just store (or throw away) to
> avoid IO waits;
> 
> 
> At least, there should be a warning in kernel help about this kind of
> situations.
> 
> 
> Regards,
> Nebojsa Trpkovic
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
