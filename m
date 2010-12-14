Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab0LNO1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:27:43 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:44554 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab0LNO1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:27:42 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEkNB02rRN+J/2dsb2JhbACkCnimNZtThUoEhGSGFoMV
X-IronPort-AV: E=Sophos;i="4.59,342,1288569600"; 
   d="scan'208";a="232353796"
Message-ID: <4D077EDE.8090005@cisco.com>
Date: Tue, 14 Dec 2010 07:27:42 -0700
From: "David S. Ahern" <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] perf tools: Add symfs option for off-box analysis
 using specified tree
References: <1291926427-28846-1-git-send-email-daahern@cisco.com> <20101214122428.GA13425@ghostprotocols.net> <20101214125245.GB13425@ghostprotocols.net>
In-Reply-To: <20101214125245.GB13425@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/14/10 05:52, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 14, 2010 at 10:24:28AM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Thu, Dec 09, 2010 at 01:27:07PM -0700, David Ahern escreveu:
>>> The symfs argument allows analysis of perf.data file using a locally
>>> accessible filesystem tree with debug symbols - e.g., tree created
>>> during image builds, sshfs mount, loop mounted KVM disk images,
>>> USB keys, initrds, etc. Anything with an OS tree can be analyzed from
>>> anywhere without the need to populate a local data store with
>>> build-ids.
>>>
>>> Signed-off-by: David Ahern <daahern@cisco.com>
>>>
>>> v2 --> v3: handle symfs="/"
>>
>> [acme@felicio ~]$ ./realpath /..//.
>> /
>> [acme@felicio ~]$
>>
>> I'll fix this up and merge, thanks!

I was not aware of realpath. Simple change to symbol__init?

> 
> Ok, there are still some problems:
> 
> It is escaping the symfs jail for /home/acme/bin/perf, /lib64/libpthread-2.5.so
> and kernel modules, investigating...

> 
> - Arnaldo
> 
> [acme@mica linux]$ find /tmp/bla
> /tmp/bla
> /tmp/bla/lib64
> /tmp/bla/lib64/libc-2.5.so
> [acme@mica linux]$ perf report -v -g none --stdio --symfs /tmp/bla > /tmp/out
> Looking at the vmlinux_path (3 entries long)
> Failed to open [kernel.kallsyms], continuing without symbols
> dso__synthesize_plt_symbols: problems reading /home/acme/bin/perf PLT info.
> dso__synthesize_plt_symbols: problems reading /lib64/libpthread-2.5.so PLT info.
> dso__synthesize_plt_symbols: problems reading /lib/modules/2.6.37-rc3-00084-gd937616/kernel/drivers/net/ixgbe/ixgbe.ko PLT info.
> [acme@mica linux]$ cat /tmp/out

strace -e trace=open /tmp/build-perf/perf report -v --symfs /tmp/f14-mnt
-i /tmp/perf-cs.data

does not show any attempts to open a file not starting with the symfs path.

At the top of dso__synthesize_plt_symbols() is:
	snprintf(name, sizeof(name), "%s%s",
		 symbol_conf.symfs, self->long_name);
	fd = open(name, O_RDONLY);

so the open only gets the relative path.

David
