Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0FCSMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:12:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab0FCSMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:12:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=HM/7jWI2ABTb/a4rRzoT6Hxvt0x1xapa2yfT3V43VcBj5wj2oJ2qZZwVL8P6nO6Bs
	RktTvEElcjb+GG7FxNtrQ==
MIME-Version: 1.0
In-Reply-To: <20100603180613.GA10469@ghostprotocols.net>
References: <AANLkTik2yNxwCHl7FZAyOG4Vt56RlLi59oZR5Jo6o9ox@mail.gmail.com>
	<20100603175445.GC8928@ghostprotocols.net>
	<20100603180613.GA10469@ghostprotocols.net>
Date: Thu, 3 Jun 2010 20:12:30 +0200
Message-ID: <AANLkTimfAKYx1BWpUR5mYY57jRFQi9NTS8UipBN7oSxG@mail.gmail.com>
Subject: Re: how to use perf annotate on the kernel
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, tzanussi@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My kernel is indeed not in the current subdir, I shortened
the cmdline in my post.

This is the live kernel but I don't have it in /lib/.

With verbose, I get output such as:

objdump --start-address=0xffffffff81246ad0
--stop-address=0xffffffff81246b44 -dS -C [kernel.kallsyms]|grep -v
[kernel.kallsyms]|expand


On Thu, Jun 3, 2010 at 8:06 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Thu, Jun 03, 2010 at 02:54:45PM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Thu, Jun 03, 2010 at 07:23:02PM +0200, Stephane Eranian escreveu:
>> > # perf annotate (or annotate -d '[kernel.kallsyms]'?)
>> > Can't annotate __lock_acquire: No vmlinux file was found in the path
>> >
>> > # perf annotate -k vmlinux
>> > objdump: '[kernel.kallsyms]': No such file
>>
>> This looks like a bug in how it reports this problem, probably vmlinux
>> is not in the current directory, or it is but has a build-id that
>> doesn't matches the one in the perf.data file.
>>
>> But the message is wrong, should be like it is in the tui, for this same
>> situation:
>>
>>       ui_helpline__puts("No vmlinux file found, can't "
>>                         "annotate with just a kallsyms file");
>>
>> > Am I missing something here?
>>
>> If you don't specify it with --vmlinux/-k it will try to find it in one
>> of these places:
>>
>>         vmlinux_path[vmlinux_path__nr_entries] = strdup("vmlinux");
>>         vmlinux_path[vmlinux_path__nr_entries] = strdup("/boot/vmlinux");
>>         snprintf(bf, sizeof(bf), "/boot/vmlinux-%s", uts.release);
>>         vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
>>         snprintf(bf, sizeof(bf), "/lib/modules/%s/build/vmlinux", uts.release);
>>         vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
>>         snprintf(bf, sizeof(bf), "/usr/lib/debug/lib/modules/%s/vmlinux",
>>                  uts.release);
>>         vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
>>
>> It also now looks at /sys/kernel/notes, gets the build-id, and looks up
>> in the build-id cache.
>
> For instance, here using -vvv I get:
>
> [root@emilia ~]# perf annotate -vvv memcpy > /dev/null
> build id event received for [kernel.kallsyms]: 310920b54cbbf242dbfa09052f652806d2c73821
> build id event received for /lib64/libtinfo.so.5.7: cd9da7b5b1fcb25ee6b3762bb9fe62f782590fd5
> Looking at the vmlinux_path (6 entries long)
> No build_id in /root/.debug/.build-id/31/0920b54cbbf242dbfa09052f652806d2c73821, ignoring it
> No build_id in vmlinux, ignoring it
> No build_id in /boot/vmlinux, ignoring it
> No build_id in /boot/vmlinux-2.6.35-rc1, ignoring it
> Using /lib/modules/2.6.35-rc1/build/vmlinux for symbols
> hist_entry__inc_addr_samples: ip=0xffffffff811ea69e
> 0xffffffff811ea690 memcpy: period++ [ip: 0xffffffff811ea69e, 0xe] => 1
> hist_entry__annotate: filename=/lib/modules/2.6.35-rc1/build/vmlinux, sym=memcpy, start=0xffffffff811ea690, end=0xffffffff811ea730
> annotating [0x187e770] /lib/modules/2.6.35-rc1/build/vmlinux : [0x19b1f70]                         memcpy
> Executing: objdump --start-address=0xffffffff811ea690 --stop-address=0xffffffff811ea730 -dS /lib/modules/2.6.35-rc1/build/vmlinux|grep -v /lib/modules/2.6.35-rc1/build/vmlinux|expand
> [root@emilia ~]#
>
> I'm removing all vmlinux from the path so that I can reproduce what you see.
>
> - Arnaldo
>
