Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab0GHLv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:51:59 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:37644 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0GHLv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:51:58 -0400
Date: Thu, 8 Jul 2010 07:51:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@lynx
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: why can't i use gdb to dump module variables anymore?
Message-ID: <alpine.DEB.2.00.1007080744180.7016@lynx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  trying very hard to make a long story short, documenting how to use
gdb to poke around in a loaded module.  the important part of the
module (to demonstrate the visibility of different types of
variables):

static int rpjday_1;
int rpjday_2 = 20;
int rpjday_3 = 30;

EXPORT_SYMBOL(rpjday_3);


  once i load that module, i can see the good stuff in /proc/kallsyms:

$ grep rpjday /proc/kallsyms
ffffffffa007c090 r __ksymtab_rpjday_3	[crash_gdb]
ffffffffa007c0a8 r __kstrtab_rpjday_3	[crash_gdb]
ffffffffa007c0a0 r __kcrctab_rpjday_3	[crash_gdb]
ffffffffa007c0b4 d rpjday_2	[crash_gdb]
ffffffffa007c0b8 D rpjday_3	[crash_gdb]
$

  i can examine the salient files under
/sys/module/crash_gdb/sections/, like .data

0xffffffffa007c0b4

so here's a couple questions.

  if i want to add that module's symbol table info to my running gdb
session, i would use "add-symbol-file" but the first arg *must* be the
address of the text section and this module has *no* .text section.
so what do i use for that value?  the address of the .exit.text
section?

  and if i try to load:

(gdb) add-symbol-file /tmp/crash_gdb.ko 0xffffffffa007c000 \
-s .data 0xffffffffa007c0b4
add symbol table from file "/tmp/crash_gdb.ko" at
	.text_addr = 0xffffffffa007c000
	.data_addr = 0xffffffffa007c0b4
(y or n) y
Reading symbols from /tmp/crash_gdb.ko...done.
(gdb)

  it certainly *looks* like that worked, and:

(gdb) whatis rpjday_2
type = int
(gdb) whatis rpjday_3
type = int

  looks good, but here's where things go wrong:

(gdb) p rpjday_2
Cannot access memory at address 0xffffffffa007c0b4
(gdb) p rpjday_3
Cannot access memory at address 0xffffffffa007c0b8

  that sort of thing used to work when i was testing this on a 32-bit
fedora system, but i'm now on 64-but ubuntu and i don't see why those
last couple commands no longer work.  the addresses certainly match
what's in /proc/kallsyms, and i don't recall having to do anything
special last time.  have i omitted a critical compile-time option for
this?  thanks.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Top-notch, inexpensive online Linux/OSS/kernel courses
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
