Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab0LNOd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:33:29 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:46343 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0LNOd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:33:27 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHwOB02rR7H+/2dsb2JhbACkCnimN5tUhUoEhGSGFoMV
X-IronPort-AV: E=Sophos;i="4.59,342,1288569600"; 
   d="scan'208";a="232358160"
Message-ID: <4D078037.9060207@cisco.com>
Date: Tue, 14 Dec 2010 07:33:27 -0700
From: "David S. Ahern" <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] perf tools: Add symfs option for off-box analysis
 using specified tree
References: <1291926427-28846-1-git-send-email-daahern@cisco.com> <20101214122428.GA13425@ghostprotocols.net> <20101214125245.GB13425@ghostprotocols.net> <20101214140604.GC13425@ghostprotocols.net>
In-Reply-To: <20101214140604.GC13425@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/14/10 07:06, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 14, 2010 at 10:52:45AM -0200, Arnaldo Carvalho de Melo escreveu:
>> Ok, there are still some problems:
>>
>> It is escaping the symfs jail for /home/acme/bin/perf, /lib64/libpthread-2.5.so
>> and kernel modules, investigating...
> 
> Those 'G' signals means DSO__ORIG_GUEST_KMODULE, since you were not
> prefixing that case with symfs, it was the jail leak point, fixed, doing
> some more testing before merging.

yuk. I did not touch the hypervisor paths.

So the 'guest' route is tried all the time because of the origin list --
even when it's not applicable.

David

> 
>> [acme@mica linux]$ find /tmp/bla
>> /tmp/bla
>> /tmp/bla/lib64
>> /tmp/bla/lib64/libc-2.5.so
>> [acme@mica linux]$ perf report -v -g none --stdio --symfs /tmp/bla
>> Failed to open [kernel.kallsyms], continuing without symbols
>> # Events: 503  cycles
>> #
>> # Overhead Command    Shared Object                                Symbol
>> # ........ .......... .....................................        ....................
>> #
>>    0.84%        perf  /home/acme/bin/perf                  0x26bf1 G [.] die_builtin
>>    0.21%        perf  /home/acme/bin/perf                  0x1db4b G [.] event__synthesize_kernel_mmap
>>    0.21%        perf  /home/acme/bin/perf                  0x4700  G [.] _init
>>    0.21%        perf  /home/acme/bin/perf                  0x1deca G [.] event__synthesize_comm
>>    0.21%        perf  /lib64/libpthread-2.5.so             0xd210  G [.] __write_nocancel
>>    0.21%        perf  /home/acme/bin/perf                  0xddbd  G [.] atexit_header
>>    0.03% kworker/0:1  /lib/modules/2.6.37-rc3/.../ixgbe.ko 0x605   G [k] ixgbe_update_stats
