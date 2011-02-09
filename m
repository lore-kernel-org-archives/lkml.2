Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1BIUM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:12:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48514 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1BIUM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:12:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rIWSek4YJvmDnqZRIVvVkZiTqPobdTFUW5/lKIgI9VNkLM0/ZTaqeHGA/idPxh9e0H
         F2bL9wotowHzedn9jLoJvBrwgxbq5vFYItz0qiAAoE1FsXRbGDsLA1PrTv4erMN6nTxC
         nNNsc4b1lYCIiuZiimH5Fd+AmdfQ6wDGqUq5c=
Message-ID: <4D52F526.5060101@gmail.com>
Date: Wed, 09 Feb 2011 13:12:22 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf on 2.6.38-rc4 wedges my box
References: <x49k4h9az25.fsf@segfault.boston.devel.redhat.com>	<4D52D31E.5010801@gmail.com> <x49fwrxax02.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49fwrxax02.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/09/11 11:22, Jeff Moyer wrote:
> David Ahern <dsahern@gmail.com> writes:
> 
>> Have you tried '-e cpu-clock' for S/W based profiling vs the default H/W
>> profiling? Add -v to see if the fallback to S/W is happening now.
> 
> Thanks for the suggestion, David.  I tried:
> 
> # perf record -v ls
>   Warning:  ... trying to fall back to cpu-clock-ticks
> 
> couldn't open /proc/-1/status
> couldn't open /proc/-1/maps
> [ls output]
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.008 MB perf.data (~363 samples) ]
> 
> If I explicitly set '-e cpu-clock', then the output is the same,
> except that the warning is gone.  What's up with the /proc/-1/*?

target_{pid,tid} are initialized to -1 in builtin-record.c I believe the
tid version is making its way through the event__synthesize_xxx code
(event__synthesize_thread -> __event__synthesize_thread ->
event__synthesize_comm and event__synthesize_mmap_events).

> 
> Now, when running perf record -e cpu-clock on the aio-stress run,
> unsurprisingly, I get the same result:
> 
> # perf record -e cpu-clock -v -- ./aio-stress -O -o 0 -r 4 -d 32 -b 16 /dev/sds
> couldn't open /proc/-1/status
> couldn't open /proc/-1/maps
> adding stage write
> starting with write
> file size 1024MB, record size 4KB, depth 32, ios per iteration 8
> max io_submit 16, buffer alignment set to 4KB
> threads 1 files 1 contexts 1 context offset 2MB verification off
> adding file /dev/sds thread 0
> 
> and there it sits.  In this case, however, I did not see the NOHZ
> warnings on the console, and this time the machine is still responding
> to ping, but nothing else.

cpu-clock is handled through hrtimers if that helps understand the lockup.

David

> 
> Cheers,
> Jeff
