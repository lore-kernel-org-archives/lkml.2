Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1ITCiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 22:38:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53528 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1ITCiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 22:38:18 -0400
MIME-Version: 1.0
In-Reply-To: <4E77DADF.6020608@am.sony.com>
References: <4E77DADF.6020608@am.sony.com>
Date: Tue, 20 Sep 2011 10:38:16 +0800
Message-ID: <CAGn38=0kk1hxzMtZ9_P_kkyszE-4tXo28vNAYyYnQi=gRuJyBw@mail.gmail.com>
Subject: Re: kdb - can't set breakpoint by default on x86
From: Dongdong Deng <libfetion@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 8:14 AM, Tim Bird <tim.bird@am.sony.com> wrote:
> I recently tried using KDB on a 3.0.1 kernel, on an x86 target, using
> a fairly-close-to-default kernel configuration.
>
> I found that I could not set a breakpoint.
> It sets inside KDB, but then fails to apply the breakpoint when
> resuming to user space:
>
>
> --------------------------------
> /proc # echo g >sysrq-trigger
> [2689816.806249] SysRq : DEBUG
>
> Entering kdb (current=0xc7661d40, pid 511) on processor 0 due to Keyboard Entry
>
> [0]kdb> bp sys_sync
> Instruction(i) BP #0 at 0xc111ce70 (sys_sync)
>    is enabled  addr at 00000000c111ce70, hardtype=0 installed=0
>
> [0]kdb> g
> _kdb_bp_install: failed to set breakpoint at 0xc111ce70
> /proc # sync
> /proc #
> --------------------------------
>
> I discovered that this was due to the text segment being marked
> read-only, by mark_rodata_ro() in arch/x86/mm/init_32.c
>
> This is controlled by CONFIG_DEBUG_RODATA.  With CONFIG_DEBUG_RODATA=y,
> I get the following message on startup:
>
> Write protecting the kernel read-only data: 6245
>
> Also, breakpoints don't work.
>
> Turning this off solves the problem, but seems counter-intuitive.
> CONFIG_DEBUG_RODATA depends on CONFIG_DEBUG_KERNEL.
>
> Should I:
> 1) turn off CONFIG_DEBUG_RODATA automatically when CONFIG_KGDB_KDB is set?
> or
> 2) make CONFIG_DEBUG_RODATA depend on !KGDB_KDB?
> or
> 3) something else more subtle?


The CONFIG_DEBUG_RODATA  is the nightmare for new user of kgdb/kdb,
Most of kgdb/kdb user meet this problem when they first time using
without reading manual.

but as the CONFIG_DEBUG_RODATA is an security feature, most of distro
enable it.(ex: ubuntu)
and the distro enable kgdb/kdb debugger too,

if the KGDB/KDB mutual exclusion with CONFIG_DEBUG_RODATA,  the distro
just pick one...

BTW:  the kprobe have the same problem, it didn't handle with
CONFIG_DEBUG_RODATA too.

Dongdong
