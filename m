Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053Ab0GBQKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 12:10:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59519 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758922Ab0GBQKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 12:10:08 -0400
Message-ID: <4C2E0B70.9090607@colorfullife.com>
Date: Fri, 02 Jul 2010 17:53:20 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       maciej.rutecki@gmail.com
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <20100621200118.GA4021@nb-core2.darkstar.lan> <4C223657.3030507@colorfullife.com> <AANLkTimE_BeA3yiCovC0ckn_MbbH3lpgctLD8zD5ir6j@mail.gmail.com> <AANLkTinw8qzAkHTNB05PqfWMQmuya1Dq6AZCgz2nWx6_@mail.gmail.com> <4C251AFF.70803@colorfullife.com> <AANLkTilm19O8nPGHSzExdCOPWR2Cridxq_sjs_uRkd8E@mail.gmail.com>
In-Reply-To: <AANLkTilm19O8nPGHSzExdCOPWR2Cridxq_sjs_uRkd8E@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

On 06/26/2010 02:52 PM, Luca Tettamanti wrote:
> They don't seem really hung as before, I see two different behaviours:
> * Near the end of the run ab is frozen for a few seconds, but in the
> end all requests are processed; however I see a few "length" errors,
> meaning that the received page does not match the expected content
> (I'm testing a static page):
>
> Concurrency Level:      100
> Time taken for tests:   14.682 seconds
> Complete requests:      10000
> Failed requests:        10
>     (Connect: 0, Receive: 0, Length: 10, Exceptions: 0)
> Write errors:           0
> Total transferred:      79987946 bytes
> HTML transferred:       77190466 bytes
> Requests per second:    681.11 [#/sec] (mean)
> Time per request:       146.819 [ms] (mean)
> Time per request:       1.468 [ms] (mean, across all concurrent requests)
> Transfer rate:          5320.36 [Kbytes/sec] received
>
> Connection Times (ms)
>                min  mean[+/-sd] median   max
> Connect:        0    1   0.4      0       3
> Processing:     3   29 428.9     15   14678
> Waiting:        0   15   1.3     15      19
> Total:          5   30 429.0     16   14682
> ERROR: The median and mean for the initial connection time are more
> than twice the standard
>         deviation apart. These results are NOT reliable.
> Percentage of the requests served within a certain time (ms)
>    50%     16
>    66%     17
>    75%     17
>    80%     17
>    90%     17
>    95%     17
>    98%     18
>    99%     18
>   100%  14682 (longest request)
>
> strace on apache shows:
> [pid  3787] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3789] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3788] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3784] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3783] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3782] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3239] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3233] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3238] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3237] restart_syscall(<... resuming interrupted call ...>
>
>
> * Sometimes ab pauses at the end but not all requests are successful; ab says:
>
> apr_socket_recv: Connection timed out (110)
> Total of 9932 requests completed
>
> The problem seems more acute if there's other application running on
> the system (e.g. right now I have kde, firefox, thunderbird active and
> I see more errors; note that nothing is using much CPU time). I've
> taken a sysrq-t log during one of ab pauses, it's attached.
>
>    
On my system,

#ab -n 100000 -c 1000 http://127.0.0.1/icons/poweredby.png

Also produces hangs/failures. But this happens regardless of the kernel 
version:
Stock 2.6.33, 2.6.33.5 from Fedora, 2.6.35-rc3, 2.6.35-rc3 with the 
semop changes reverted.

Thus I'd propose to close the current bug.
The IN_WAKEUP fix fixes the semop() and especially semtimedop() failures.

--
     Manfred
