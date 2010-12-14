Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0LNOGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:06:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49920 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0LNOGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:06:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=bz6pFVHpgmzacNiPCc6hwci7mV+KHw+uEaNPIpXPZdX022pInvU2/PxhQcAS8p4gcX
         UFONPZVEXmcp1epV6x0KBF22A+RTTihA649J/D6zDc3ga7z1OnSYGPIOMmNkDdhFM0Io
         1jwMOqtNgzKGZI5mlcKY1++RXeGehXZRqZK7w=
Date: Tue, 14 Dec 2010 12:06:04 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] perf tools: Add symfs option for off-box analysis
 using specified tree
Message-ID: <20101214140604.GC13425@ghostprotocols.net>
References: <1291926427-28846-1-git-send-email-daahern@cisco.com>
 <20101214122428.GA13425@ghostprotocols.net>
 <20101214125245.GB13425@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214125245.GB13425@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 14, 2010 at 10:52:45AM -0200, Arnaldo Carvalho de Melo escreveu:
> Ok, there are still some problems:
> 
> It is escaping the symfs jail for /home/acme/bin/perf, /lib64/libpthread-2.5.so
> and kernel modules, investigating...

Those 'G' signals means DSO__ORIG_GUEST_KMODULE, since you were not
prefixing that case with symfs, it was the jail leak point, fixed, doing
some more testing before merging.

> [acme@mica linux]$ find /tmp/bla
> /tmp/bla
> /tmp/bla/lib64
> /tmp/bla/lib64/libc-2.5.so
> [acme@mica linux]$ perf report -v -g none --stdio --symfs /tmp/bla
> Failed to open [kernel.kallsyms], continuing without symbols
> # Events: 503  cycles
> #
> # Overhead Command    Shared Object                                Symbol
> # ........ .......... .....................................        ....................
> #
>    0.84%        perf  /home/acme/bin/perf                  0x26bf1 G [.] die_builtin
>    0.21%        perf  /home/acme/bin/perf                  0x1db4b G [.] event__synthesize_kernel_mmap
>    0.21%        perf  /home/acme/bin/perf                  0x4700  G [.] _init
>    0.21%        perf  /home/acme/bin/perf                  0x1deca G [.] event__synthesize_comm
>    0.21%        perf  /lib64/libpthread-2.5.so             0xd210  G [.] __write_nocancel
>    0.21%        perf  /home/acme/bin/perf                  0xddbd  G [.] atexit_header
>    0.03% kworker/0:1  /lib/modules/2.6.37-rc3/.../ixgbe.ko 0x605   G [k] ixgbe_update_stats
