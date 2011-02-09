Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1BIRrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:47:17 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:59873 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1BIRrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z2yOCepvcCiLGWwTo6rCxHC5+K7OsdFeha8q1mFoflU9yJi7pq4pmhaVedF6KcDz+4
         bKOTbTAhDyzTmWOKOdk0eEkb2ZRVocXtEd7K/ueBIvvpx5+ZqD6pQmDVxkKOGXrOArWP
         IJJY1vcSPzHMM1Y2+2UJ11hyE6equ24xJrHKY=
Message-ID: <4D52D31E.5010801@gmail.com>
Date: Wed, 09 Feb 2011 10:47:10 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf on 2.6.38-rc4 wedges my box
References: <x49k4h9az25.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49k4h9az25.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/09/11 10:38, Jeff Moyer wrote:
> Hi,
> 
> I'm trying out willy's ata_ram driver[1], and in so doing have managed to
> wedge my box while using perf record on an aio-stress run:
> 
> [root@metallica ~]# modprobe ata_ram capacity=2097152 preallocate=1
> [root@metallica ~]# ./aio-stress -O -o 0 -r 4 -d 32 -b 16 /dev/sds
> adding stage write
> starting with write
> file size 1024MB, record size 4KB, depth 32, ios per iteration 8
> max io_submit 16, buffer alignment set to 4KB
> threads 1 files 1 contexts 1 context offset 2MB verification off
> adding file /dev/sds thread 0
> write on /dev/sds (621.30 MB/s) 1024.00 MB in 1.65s
> thread 0 write totals (621.27 MB/s) 1024.00 MB in 1.65s
> [root@metallica ~]# perf record -- ./aio-stress -O -o 0 -r 4 -d 32 -b 16
> /dev/sds

Have you tried '-e cpu-clock' for S/W based profiling vs the default H/W
profiling? Add -v to see if the fallback to S/W is happening now.

David


> adding stage write
> starting with write
> file size 1024MB, record size 4KB, depth 32, ios per iteration 8
> max io_submit 16, buffer alignment set to 4KB
> threads 1 files 1 contexts 1 context offset 2MB verification off
> adding file /dev/sds thread 0
> 
> and there it sits.  On the console, I see:
> 
> NOHZ: local_softirq_pending 100
> NOHZ: local_softirq_pending 100
> NOHZ: local_softirq_pending 100
> NOHZ: local_softirq_pending 100
> NOHZ: local_softirq_pending 100
> 
> The number of messages varies, but this is the most I've seen (it
> doesn't keep repeating).  At this point, the machine does not respond to
> pings.  As I don't have physical access at the moment, I can't try
> alt-sysrq, but might be able to do that tomorrow.  It's probably worth
> noting that I've witnessed similar behavior with real devices, so it's
> not just the ata_ram driver.
> 
> Any ideas on how to track this down?
> 
> Thanks!
> 
> Jeff
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=refs/heads/ata-ram
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
