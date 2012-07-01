Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2GAA5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 20:57:33 -0400
Received: from seven.medozas.de ([5.9.24.206]:51151 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab2GAA5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 20:57:32 -0400
Date: Sun, 1 Jul 2012 02:57:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: simon@fire.lp0.eu
Subject: Leap second insertion causes futex to repeatedly timeout
Message-ID: <alpine.LNX.2.01.1207010247430.7313@frira.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This year's leap second insertion has had the strange effect on at least 
Linux versions 3.4.4 (my end) and 3.5-rc4 (Simon's box, Cc) that certain 
processes use up all CPU power, because of futexes repeatedly timing 
out. This seems to only affect certain processes.

Simon observes - http://s85.org/owXfmLvt - that 
Firefox/Thunderbird/Chrome/Java are affected.

As for me, it affects VirtualBox, mysqld and ksoftirqd. The processes 
continue to run and respond. Most weird: I can stop-start mysqld and the 
issue persists. (I would have expected it to go away because the leap 
second event would then be in the past that mysqld does not know about 
anymore.)


Is this a kernel issue? glibc?


$ ps max -o pid,tid,command
  PID   TID COMMAND
 6743     - /bin/sh /usr/bin/mysqld_safe --mysqld=mysqld --user=mysql --pid-file=/var/run/mysql/mysqld.pid --socket=/var/run/mysql/mysql.sock --datadir=/var/lib/mysql
    -  6743 -
 7186     - /usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mysql/plugin --user=mysql --log-error=/var/log/mysql/mysqld.log --pid-file=/var/run/mysql/mysqld.pid --socket=/var/run/mysql/mysql.sock --port=3306
    -  7186 -
    -  7189 -
    -  7190 -
    -  7191 -
    -  7192 -
    -  7193 -
    -  7194 -
    -  7195 -
    -  7196 -
    -  7197 -
    -  7198 -
    -  7201 -
    -  7202 -
    -  7203 -
    -  7204 -
    -  7212 -

$ strace -fp 7186
7212  02:52:24.104357 rt_sigtimedwait([HUP QUIT ALRM TERM TSTP], NULL, NULL, 8 <unfinished ...>
7204  02:52:24.104437 futex(0x223f62c, FUTEX_WAIT_PRIVATE, 1, NULL <unfinished ...>
7203  02:52:24.104472 restart_syscall(<... resuming interrupted call ...> <unfinished ...>
7202  02:52:24.104483 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162761, {1341103945, 104478000}, ffffffff <unfinished ...>
7201  02:52:24.104498 restart_syscall(<... resuming interrupted call ...> <unfinished ...>
7198  02:52:24.104513 futex(0x264e90c, FUTEX_WAIT_PRIVATE, 1, NULL <unfinished ...>
7197  02:52:24.104524 futex(0x264e88c, FUTEX_WAIT_PRIVATE, 1, NULL <unfinished ...>
7201  02:52:24.104535 <... restart_syscall resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.104552 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.104563 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.104574 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.104582 <... futex resumed> ) = 0
7202  02:52:24.104597 <... futex resumed> ) = 0
7196  02:52:24.104604 futex(0x264e80c, FUTEX_WAIT_PRIVATE, 1, NULL <unfinished ...>
7201  02:52:24.104614 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921029, {1341103945, 104609000}, ffffffff <unfinished ...>
7202  02:52:24.104629 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162763, {1341103945, 104620000}, ffffffff <unfinished ...>
7195  02:52:24.104649 futex(0x264e78c, FUTEX_WAIT_PRIVATE, 1, NULL <unfinished ...>
7201  02:52:24.104666 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.104681 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.104693 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.104703 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.104712 <... futex resumed> ) = 0
7202  02:52:24.104720 <... futex resumed> ) = 0
7194  02:52:24.104730 futex(0x264e70c, FUTEX_WAIT_PRIVATE, 1, NULL <unfinished ...>
7201  02:52:24.104742 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921031, {1341103945, 104737000}, ffffffff <unfinished ...>
7193  02:52:24.104763 futex(0x264e68c, FUTEX_WAIT_PRIVATE, 1, NULL <unfinished ...>
7202  02:52:24.104783 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162765, {1341103945, 104765000}, ffffffff <unfinished ...>
7201  02:52:24.104801 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.104816 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.104824 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.104833 <... futex resumed> ) = 0
7202  02:52:24.104843 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7192  02:52:24.104854 futex(0x264e60c, FUTEX_WAIT_PRIVATE, 1, NULL <unfinished ...>
7202  02:52:24.104862 <... futex resumed> ) = 0
7201  02:52:24.104872 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921033, {1341103945, 104858000}, ffffffff <unfinished ...>
7191  02:52:24.104893 futex(0x264e58c, FUTEX_WAIT_PRIVATE, 1, NULL <unfinished ...>
7202  02:52:24.104904 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162767, {1341103945, 104897000}, ffffffff <unfinished ...>
7201  02:52:24.104914 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7190  02:52:24.104925 futex(0x264e50c, FUTEX_WAIT_PRIVATE, 5, NULL <unfinished ...>
7201  02:52:24.104935 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7189  02:52:24.104946 futex(0x264e48c, FUTEX_WAIT_PRIVATE, 1, NULL <unfinished ...>
7202  02:52:24.104954 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.104963 <... futex resumed> ) = 0
7202  02:52:24.104973 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.104992 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921035, {1341103945, 104988000}, ffffffff <unfinished ...>
7202  02:52:24.105027 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162769, {1341103945, 105014000}, ffffffff <unfinished ...>
7201  02:52:24.105090 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7186  02:52:24.105111 restart_syscall(<... resuming interrupted call ...> <unfinished ...>
7202  02:52:24.105171 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.105195 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.105211 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.105259 <... futex resumed> ) = 0
7202  02:52:24.105287 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162771, {1341103945, 105276000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.105355 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.105384 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921037, {1341103945, 105377000}, ffffffff <unfinished ...>
7202  02:52:24.105394 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162773, {1341103945, 105384000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.105454 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.105471 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.105536 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.105552 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162775, {1341103945, 105532000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.105618 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.105625 <... futex resumed> ) = 0
7202  02:52:24.105630 <... futex resumed> ) = 0
7201  02:52:24.105685 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921039, {1341103945, 105674000}, ffffffff <unfinished ...>
7202  02:52:24.105710 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162777, {1341103945, 105683000}, ffffffff <unfinished ...>
7201  02:52:24.105735 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.105749 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.105765 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.105780 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.105794 <... futex resumed> ) = 0
7202  02:52:24.105806 <... futex resumed> ) = 0
7201  02:52:24.105842 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921041, {1341103945, 105832000}, ffffffff <unfinished ...>
7202  02:52:24.105863 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162779, {1341103945, 105855000}, ffffffff <unfinished ...>
7201  02:52:24.105893 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.105914 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.105931 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.105947 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.105960 <... futex resumed> ) = 0
7202  02:52:24.105973 <... futex resumed> ) = 0
7201  02:52:24.106007 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921043, {1341103945, 105997000}, ffffffff <unfinished ...>
7202  02:52:24.106035 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162781, {1341103945, 106020000}, ffffffff <unfinished ...>
7201  02:52:24.106054 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.106081 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.106099 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.106114 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.106127 <... futex resumed> ) = 0
7202  02:52:24.106140 <... futex resumed> ) = 0
7201  02:52:24.106174 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921045, {1341103945, 106164000}, ffffffff <unfinished ...>
7202  02:52:24.106202 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162783, {1341103945, 106187000}, ffffffff <unfinished ...>
7201  02:52:24.106221 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.106250 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.106267 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.106283 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.106296 <... futex resumed> ) = 0
7202  02:52:24.106308 <... futex resumed> ) = 0
7201  02:52:24.106343 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921047, {1341103945, 106333000}, ffffffff <unfinished ...>
7202  02:52:24.106370 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162785, {1341103945, 106355000}, ffffffff <unfinished ...>
7201  02:52:24.106390 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.106416 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.106433 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.106449 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.106462 <... futex resumed> ) = 0
7202  02:52:24.106474 <... futex resumed> ) = 0
7201  02:52:24.106509 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921049, {1341103945, 106499000}, ffffffff <unfinished ...>
7202  02:52:24.106536 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162787, {1341103945, 106521000}, ffffffff <unfinished ...>
7201  02:52:24.106556 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.106583 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.106600 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.106615 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.106628 <... futex resumed> ) = 0
7202  02:52:24.106641 <... futex resumed> ) = 0
7201  02:52:24.106675 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921051, {1341103945, 106665000}, ffffffff <unfinished ...>
7202  02:52:24.106704 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162789, {1341103945, 106687000}, ffffffff <unfinished ...>
7201  02:52:24.106722 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.106748 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.106765 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.106781 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.106794 <... futex resumed> ) = 0
7202  02:52:24.106806 <... futex resumed> ) = 0
7201  02:52:24.106840 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921053, {1341103945, 106830000}, ffffffff <unfinished ...>
7202  02:52:24.106869 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162791, {1341103945, 106853000}, ffffffff <unfinished ...>
7201  02:52:24.106887 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.106913 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.106930 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.106945 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.106959 <... futex resumed> ) = 0
7202  02:52:24.106971 <... futex resumed> ) = 0
7201  02:52:24.107005 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921055, {1341103945, 106995000}, ffffffff <unfinished ...>
7202  02:52:24.107032 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162793, {1341103945, 107017000}, ffffffff <unfinished ...>
7201  02:52:24.107062 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.107077 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.107094 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.107109 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.107122 <... futex resumed> ) = 0
7202  02:52:24.107134 <... futex resumed> ) = 0
7201  02:52:24.107169 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921057, {1341103945, 107159000}, ffffffff <unfinished ...>
7202  02:52:24.107197 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162795, {1341103945, 107181000}, ffffffff <unfinished ...>
7201  02:52:24.107227 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.107242 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.107259 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.107274 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.107287 <... futex resumed> ) = 0
7202  02:52:24.107300 <... futex resumed> ) = 0
7201  02:52:24.107334 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921059, {1341103945, 107324000}, ffffffff <unfinished ...>
7202  02:52:24.107362 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162797, {1341103945, 107347000}, ffffffff <unfinished ...>
7201  02:52:24.107386 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.107406 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.107423 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.107438 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.107451 <... futex resumed> ) = 0
7202  02:52:24.107464 <... futex resumed> ) = 0
7201  02:52:24.107498 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921061, {1341103945, 107488000}, ffffffff <unfinished ...>
7202  02:52:24.107526 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162799, {1341103945, 107511000}, ffffffff <unfinished ...>
7201  02:52:24.107550 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.107570 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.107587 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.107602 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.107616 <... futex resumed> ) = 0
7202  02:52:24.107628 <... futex resumed> ) = 0
7201  02:52:24.107662 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921063, {1341103945, 107652000}, ffffffff <unfinished ...>
7202  02:52:24.107690 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162801, {1341103945, 107675000}, ffffffff <unfinished ...>
7201  02:52:24.107714 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.107735 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.107753 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.107768 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.107781 <... futex resumed> ) = 0
7202  02:52:24.107794 <... futex resumed> ) = 0
7201  02:52:24.107828 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921065, {1341103945, 107818000}, ffffffff <unfinished ...>
7202  02:52:24.107855 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162803, {1341103945, 107840000}, ffffffff <unfinished ...>
7201  02:52:24.107879 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.107900 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.107917 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.107933 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.107946 <... futex resumed> ) = 0
7202  02:52:24.107958 <... futex resumed> ) = 0
7201  02:52:24.107992 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921067, {1341103945, 107982000}, ffffffff <unfinished ...>
7202  02:52:24.108020 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162805, {1341103945, 108005000}, ffffffff <unfinished ...>
7201  02:52:24.108039 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.108066 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.108083 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.108099 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.108111 <... futex resumed> ) = 0
7202  02:52:24.108124 <... futex resumed> ) = 0
7201  02:52:24.108158 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921069, {1341103945, 108148000}, ffffffff <unfinished ...>
7202  02:52:24.108200 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162807, {1341103945, 108171000}, ffffffff <unfinished ...>
7201  02:52:24.108217 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.108231 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.108247 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.108262 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.108275 <... futex resumed> ) = 0
7202  02:52:24.108287 <... futex resumed> ) = 0
7201  02:52:24.108322 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921071, {1341103945, 108312000}, ffffffff <unfinished ...>
7202  02:52:24.108349 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162809, {1341103945, 108334000}, ffffffff <unfinished ...>
7201  02:52:24.108374 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.108395 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.108412 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.108428 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.108441 <... futex resumed> ) = 0
7202  02:52:24.108454 <... futex resumed> ) = 0
7201  02:52:24.108488 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921073, {1341103945, 108478000}, ffffffff <unfinished ...>
7202  02:52:24.108516 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162811, {1341103945, 108500000}, ffffffff <unfinished ...>
7201  02:52:24.108540 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.108561 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.108578 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.108594 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.108607 <... futex resumed> ) = 0
7202  02:52:24.108619 <... futex resumed> ) = 0
7201  02:52:24.108654 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921075, {1341103945, 108643000}, ffffffff <unfinished ...>
7202  02:52:24.108681 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162813, {1341103945, 108666000}, ffffffff <unfinished ...>
7201  02:52:24.108710 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.108726 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.108742 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.108768 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.108784 <... futex resumed> ) = 0
7202  02:52:24.108796 <... futex resumed> ) = 0
7201  02:52:24.108831 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921077, {1341103945, 108821000}, ffffffff <unfinished ...>
7202  02:52:24.108852 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162815, {1341103945, 108844000}, ffffffff <unfinished ...>
7201  02:52:24.108890 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.108905 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.108921 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.108937 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.108949 <... futex resumed> ) = 0
7202  02:52:24.108962 <... futex resumed> ) = 0
7201  02:52:24.108996 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921079, {1341103945, 108986000}, ffffffff <unfinished ...>
7202  02:52:24.109024 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162817, {1341103945, 109008000}, ffffffff <unfinished ...>
7201  02:52:24.109043 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.109069 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.109086 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.109102 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.109121 <... futex resumed> ) = 0
7202  02:52:24.109133 <... futex resumed> ) = 0
7201  02:52:24.109168 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921081, {1341103945, 109158000}, ffffffff <unfinished ...>
7202  02:52:24.109195 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162819, {1341103945, 109180000}, ffffffff <unfinished ...>
7201  02:52:24.109215 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.109241 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.109258 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.109274 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.109286 <... futex resumed> ) = 0
7202  02:52:24.109299 <... futex resumed> ) = 0
7201  02:52:24.109333 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921083, {1341103945, 109323000}, ffffffff <unfinished ...>
7202  02:52:24.109361 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162821, {1341103945, 109346000}, ffffffff <unfinished ...>
7201  02:52:24.109380 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.109407 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.109424 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.109439 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.109452 <... futex resumed> ) = 0
7202  02:52:24.109464 <... futex resumed> ) = 0
7201  02:52:24.109499 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921085, {1341103945, 109489000}, ffffffff <unfinished ...>
7202  02:52:24.109526 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162823, {1341103945, 109511000}, ffffffff <unfinished ...>
7201  02:52:24.109546 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.109572 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.109589 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.109605 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.109617 <... futex resumed> ) = 0
7202  02:52:24.109630 <... futex resumed> ) = 0
7201  02:52:24.109664 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921087, {1341103945, 109654000}, ffffffff <unfinished ...>
7202  02:52:24.109692 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162825, {1341103945, 109676000}, ffffffff <unfinished ...>
7201  02:52:24.109716 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.109736 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.109752 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.109767 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.109780 <... futex resumed> ) = 0
7202  02:52:24.109793 <... futex resumed> ) = 0
7201  02:52:24.109827 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921089, {1341103945, 109817000}, ffffffff <unfinished ...>
7202  02:52:24.109854 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162827, {1341103945, 109839000}, ffffffff <unfinished ...>
7201  02:52:24.109879 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.109898 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.109915 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.109930 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.109943 <... futex resumed> ) = 0
7202  02:52:24.109955 <... futex resumed> ) = 0
7201  02:52:24.109990 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921091, {1341103945, 109980000}, ffffffff <unfinished ...>
7202  02:52:24.110017 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162829, {1341103945, 110002000}, ffffffff <unfinished ...>
7201  02:52:24.110042 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.110062 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.110084 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.110100 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.110113 <... futex resumed> ) = 0
7202  02:52:24.110125 <... futex resumed> ) = 0
7201  02:52:24.110159 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921093, {1341103945, 110149000}, ffffffff <unfinished ...>
7202  02:52:24.110187 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162831, {1341103945, 110172000}, ffffffff <unfinished ...>
7201  02:52:24.110206 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.110232 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.110249 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.110265 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.110278 <... futex resumed> ) = 0
7202  02:52:24.110290 <... futex resumed> ) = 0
7201  02:52:24.110324 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921095, {1341103945, 110314000}, ffffffff <unfinished ...>
7202  02:52:24.110352 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162833, {1341103945, 110337000}, ffffffff <unfinished ...>
7201  02:52:24.110371 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.110397 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.110414 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.110430 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.110443 <... futex resumed> ) = 0
7202  02:52:24.110455 <... futex resumed> ) = 0
7201  02:52:24.110490 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921097, {1341103945, 110479000}, ffffffff <unfinished ...>
7202  02:52:24.110517 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162835, {1341103945, 110502000}, ffffffff <unfinished ...>
7201  02:52:24.110536 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.110562 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.110579 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.110595 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.110607 <... futex resumed> ) = 0
7202  02:52:24.110619 <... futex resumed> ) = 0
7201  02:52:24.110654 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921099, {1341103945, 110644000}, ffffffff <unfinished ...>
7202  02:52:24.110682 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162837, {1341103945, 110666000}, ffffffff <unfinished ...>
7201  02:52:24.110706 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.110726 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.110742 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.110758 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.110770 <... futex resumed> ) = 0
7202  02:52:24.110783 <... futex resumed> ) = 0
7201  02:52:24.110817 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921101, {1341103945, 110807000}, ffffffff <unfinished ...>
7202  02:52:24.110844 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162839, {1341103945, 110830000}, ffffffff <unfinished ...>
7201  02:52:24.110869 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.110889 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.110905 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.110921 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.110934 <... futex resumed> ) = 0
7202  02:52:24.110946 <... futex resumed> ) = 0
7201  02:52:24.110980 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921103, {1341103945, 110970000}, ffffffff <unfinished ...>
7202  02:52:24.111008 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162841, {1341103945, 110993000}, ffffffff <unfinished ...>
7201  02:52:24.111027 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.111043 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.111053 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.111062 <... futex resumed> ) = 0
7202  02:52:24.111087 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.111113 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921105, {1341103945, 111109000}, ffffffff <unfinished ...>
7202  02:52:24.111144 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162843, {1341103945, 111137000}, ffffffff <unfinished ...>
7201  02:52:24.111173 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.111195 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.111212 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.111228 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.111241 <... futex resumed> ) = 0
7202  02:52:24.111253 <... futex resumed> ) = 0
7201  02:52:24.111287 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921107, {1341103945, 111277000}, ffffffff <unfinished ...>
7202  02:52:24.111315 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162845, {1341103945, 111300000}, ffffffff <unfinished ...>
7201  02:52:24.111334 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.111361 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.111378 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.111393 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.111406 <... futex resumed> ) = 0
7202  02:52:24.111418 <... futex resumed> ) = 0
7201  02:52:24.111453 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921109, {1341103945, 111443000}, ffffffff <unfinished ...>
7202  02:52:24.111480 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162847, {1341103945, 111466000}, ffffffff <unfinished ...>
7201  02:52:24.111504 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.111524 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.111540 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.111555 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.111568 <... futex resumed> ) = 0
7202  02:52:24.111580 <... futex resumed> ) = 0
7201  02:52:24.111615 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921111, {1341103945, 111605000}, ffffffff <unfinished ...>
7202  02:52:24.111642 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162849, {1341103945, 111628000}, ffffffff <unfinished ...>
7201  02:52:24.111662 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.111689 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.111706 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.111721 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.111734 <... futex resumed> ) = 0
7202  02:52:24.111747 <... futex resumed> ) = 0
7201  02:52:24.111781 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921113, {1341103945, 111771000}, ffffffff <unfinished ...>
7202  02:52:24.111808 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162851, {1341103945, 111794000}, ffffffff <unfinished ...>
7201  02:52:24.111828 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.111854 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.111871 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.111887 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.111899 <... futex resumed> ) = 0
7202  02:52:24.111912 <... futex resumed> ) = 0
7201  02:52:24.111946 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921115, {1341103945, 111936000}, ffffffff <unfinished ...>
7202  02:52:24.111973 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162853, {1341103945, 111959000}, ffffffff <unfinished ...>
7201  02:52:24.112003 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.112017 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.112033 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.112049 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.112062 <... futex resumed> ) = 0
7202  02:52:24.112074 <... futex resumed> ) = 0
7201  02:52:24.112109 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921117, {1341103945, 112098000}, ffffffff <unfinished ...>
7202  02:52:24.112136 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162855, {1341103945, 112121000}, ffffffff <unfinished ...>
7201  02:52:24.112155 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.112181 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.112198 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.112213 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.112226 <... futex resumed> ) = 0
7202  02:52:24.112238 <... futex resumed> ) = 0
7201  02:52:24.112273 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921119, {1341103945, 112262000}, ffffffff <unfinished ...>
7202  02:52:24.112300 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162857, {1341103945, 112285000}, ffffffff <unfinished ...>
7201  02:52:24.112324 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.112344 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.112360 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.112376 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.112389 <... futex resumed> ) = 0
7202  02:52:24.112402 <... futex resumed> ) = 0
7201  02:52:24.112436 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921121, {1341103945, 112426000}, ffffffff <unfinished ...>
7202  02:52:24.112464 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162859, {1341103945, 112449000}, ffffffff <unfinished ...>
7201  02:52:24.112487 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.112507 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.112523 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.112539 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.112552 <... futex resumed> ) = 0
7202  02:52:24.112564 <... futex resumed> ) = 0
7201  02:52:24.112599 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921123, {1341103945, 112589000}, ffffffff <unfinished ...>
7202  02:52:24.112626 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162861, {1341103945, 112611000}, ffffffff <unfinished ...>
7201  02:52:24.112650 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.112670 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.112687 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.112702 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.112715 <... futex resumed> ) = 0
7202  02:52:24.112727 <... futex resumed> ) = 0
7202  02:52:24.112791 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162863, {1341103945, 112780000}, ffffffff <unfinished ...>
7201  02:52:24.112818 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921125, {1341103945, 112780000}, ffffffff <unfinished ...>
7202  02:52:24.112841 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.112863 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.112905 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.112942 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162865, {1341103945, 112925000}, ffffffff <unfinished ...>
7201  02:52:24.112990 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.113003 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.113018 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.113039 <... futex resumed> ) = 0
7202  02:52:24.113066 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162867, {1341103945, 113060000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.113162 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921127, {1341103945, 113130000}, ffffffff <unfinished ...>
7202  02:52:24.113206 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7202  02:52:24.113281 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162869, {1341103945, 113268000}, ffffffff <unfinished ...>
7201  02:52:24.113311 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.113334 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.113358 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.113377 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.113394 <... futex resumed> ) = 0
7202  02:52:24.113408 <... futex resumed> ) = 0
7201  02:52:24.113458 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921129, {1341103945, 113443000}, ffffffff <unfinished ...>
7202  02:52:24.113486 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162871, {1341103945, 113461000}, ffffffff <unfinished ...>
7201  02:52:24.113511 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.113528 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.113547 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.113566 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.113580 <... futex resumed> ) = 0
7202  02:52:24.113594 <... futex resumed> ) = 0
7201  02:52:24.113642 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921131, {1341103945, 113628000}, ffffffff <unfinished ...>
7202  02:52:24.113669 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162873, {1341103945, 113647000}, ffffffff <unfinished ...>
7201  02:52:24.113692 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.113709 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.113729 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.113747 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.113761 <... futex resumed> ) = 0
7202  02:52:24.113775 <... futex resumed> ) = 0
7201  02:52:24.113822 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921133, {1341103945, 113808000}, ffffffff <unfinished ...>
7202  02:52:24.113857 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162875, {1341103945, 113828000}, ffffffff <unfinished ...>
7201  02:52:24.113887 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.113904 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.113923 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.113942 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.113956 <... futex resumed> ) = 0
7202  02:52:24.113970 <... futex resumed> ) = 0
7201  02:52:24.114017 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921135, {1341103945, 114003000}, ffffffff <unfinished ...>
7202  02:52:24.114045 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162877, {1341103945, 114027000}, ffffffff <unfinished ...>
7201  02:52:24.114069 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.114088 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.114107 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.114125 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.114139 <... futex resumed> ) = 0
7202  02:52:24.114153 <... futex resumed> ) = 0
7201  02:52:24.114200 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921137, {1341103945, 114186000}, ffffffff <unfinished ...>
7202  02:52:24.114234 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162879, {1341103945, 114206000}, ffffffff <unfinished ...>
7201  02:52:24.114259 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.114285 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.114308 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.114323 <... futex resumed> ) = 0
7202  02:52:24.114375 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.114396 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921139, {1341103945, 114364000}, ffffffff <unfinished ...>
7202  02:52:24.114438 <... futex resumed> ) = 0
7201  02:52:24.114454 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.114477 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1) = 0
7202  02:52:24.114521 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162881, {1341103945, 114508000}, ffffffff <unfinished ...>
7201  02:52:24.114541 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921141, {1341103945, 114530000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.114604 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.114624 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.114642 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.114656 <... futex resumed> ) = 0
7202  02:52:24.114672 <... futex resumed> ) = 0
7201  02:52:24.114711 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921143, {1341103945, 114696000}, ffffffff <unfinished ...>
7202  02:52:24.114751 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162883, {1341103945, 114740000}, ffffffff <unfinished ...>
7201  02:52:24.114774 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.114803 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.114825 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.114842 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.114856 <... futex resumed> ) = 0
7202  02:52:24.114871 <... futex resumed> ) = 0
7201  02:52:24.114911 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921145, {1341103945, 114895000}, ffffffff <unfinished ...>
7202  02:52:24.114948 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162885, {1341103945, 114936000}, ffffffff <unfinished ...>
7201  02:52:24.114969 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.115000 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.115015 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.115030 <... futex resumed> ) = 0
7202  02:52:24.115048 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.115085 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921147, {1341103945, 115070000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.115153 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162887, {1341103945, 115137000}, ffffffff <unfinished ...>
7201  02:52:24.115178 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.115199 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.115217 <... futex resumed> ) = 0
7202  02:52:24.115235 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.115272 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921149, {1341103945, 115257000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.115340 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162889, {1341103945, 115323000}, ffffffff <unfinished ...>
7201  02:52:24.115365 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.115392 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.115409 <... futex resumed> ) = 0
7202  02:52:24.115428 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.115472 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921151, {1341103945, 115450000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.115540 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162891, {1341103945, 115525000}, ffffffff <unfinished ...>
7201  02:52:24.115565 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.115591 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.115608 <... futex resumed> ) = 0
7202  02:52:24.115627 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.115663 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921153, {1341103945, 115650000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.115733 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162893, {1341103945, 115713000}, ffffffff <unfinished ...>
7201  02:52:24.115757 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.115777 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.115794 <... futex resumed> ) = 0
7202  02:52:24.115813 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.115850 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921155, {1341103945, 115835000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.115918 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162895, {1341103945, 115901000}, ffffffff <unfinished ...>
7201  02:52:24.115942 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.115967 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.115985 <... futex resumed> ) = 0
7202  02:52:24.116003 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.116040 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921157, {1341103945, 116025000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.116108 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162897, {1341103945, 116091000}, ffffffff <unfinished ...>
7201  02:52:24.116132 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.116159 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.116177 <... futex resumed> ) = 0
7202  02:52:24.116195 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.116232 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921159, {1341103945, 116217000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.116300 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162899, {1341103945, 116284000}, ffffffff <unfinished ...>
7201  02:52:24.116325 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.116350 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.116368 <... futex resumed> ) = 0
7202  02:52:24.116386 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.116422 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921161, {1341103945, 116408000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.116491 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162901, {1341103945, 116474000}, ffffffff <unfinished ...>
7201  02:52:24.116515 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.116537 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.116554 <... futex resumed> ) = 0
7202  02:52:24.116572 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1) = 0
7201  02:52:24.116608 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921163, {1341103945, 116594000}, ffffffff) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.116678 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162903, {1341103945, 116659000}, ffffffff <unfinished ...>
7201  02:52:24.116702 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.116721 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.116738 <... futex resumed> ) = 0
7202  02:52:24.116831 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.116861 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921165, {1341103945, 116850000}, ffffffff <unfinished ...>
7202  02:52:24.116881 <... futex resumed> ) = 0
7201  02:52:24.116907 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.116926 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.116936 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162905, {1341103945, 116924000}, ffffffff <unfinished ...>
7201  02:52:24.116945 <... futex resumed> ) = 0
7201  02:52:24.116980 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921167, {1341103945, 116964000}, ffffffff <unfinished ...>
7202  02:52:24.117002 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.117021 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.117030 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.117039 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.117045 <... futex resumed> ) = 0
7201  02:52:24.117051 <... futex resumed> ) = 0
7202  02:52:24.117078 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162907, {1341103945, 117073000}, ffffffff <unfinished ...>
7201  02:52:24.117091 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921169, {1341103945, 117072000}, ffffffff <unfinished ...>
7202  02:52:24.117135 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.117153 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.117178 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.117187 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.117194 <... futex resumed> ) = 0
7201  02:52:24.117200 <... futex resumed> ) = 0
7202  02:52:24.117227 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162909, {1341103945, 117221000}, ffffffff <unfinished ...>
7201  02:52:24.117239 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921171, {1341103945, 117221000}, ffffffff <unfinished ...>
7202  02:52:24.117283 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.117302 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.117327 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.117336 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.117342 <... futex resumed> ) = 0
7201  02:52:24.117349 <... futex resumed> ) = 0
7202  02:52:24.117376 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162911, {1341103945, 117370000}, ffffffff <unfinished ...>
7201  02:52:24.117388 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921173, {1341103945, 117369000}, ffffffff <unfinished ...>
7202  02:52:24.117431 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.117450 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.117476 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.117484 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.117491 <... futex resumed> ) = 0
7201  02:52:24.117497 <... futex resumed> ) = 0
7202  02:52:24.117524 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162913, {1341103945, 117518000}, ffffffff <unfinished ...>
7201  02:52:24.117536 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921175, {1341103945, 117518000}, ffffffff <unfinished ...>
7202  02:52:24.117580 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.117598 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.117622 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.117631 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.117637 <... futex resumed> ) = 0
7201  02:52:24.117644 <... futex resumed> ) = 0
7202  02:52:24.117671 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162915, {1341103945, 117665000}, ffffffff <unfinished ...>
7201  02:52:24.117686 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921177, {1341103945, 117664000}, ffffffff <unfinished ...>
7202  02:52:24.117730 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.117748 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.117774 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.117783 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.117789 <... futex resumed> ) = 0
7201  02:52:24.117795 <... futex resumed> ) = 0
7202  02:52:24.117822 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162917, {1341103945, 117817000}, ffffffff <unfinished ...>
7201  02:52:24.117834 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921179, {1341103945, 117816000}, ffffffff <unfinished ...>
7202  02:52:24.117878 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.117896 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.117922 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.117930 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.117937 <... futex resumed> ) = 0
7201  02:52:24.117943 <... futex resumed> ) = 0
7202  02:52:24.117970 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162919, {1341103945, 117965000}, ffffffff <unfinished ...>
7201  02:52:24.117983 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921181, {1341103945, 117964000}, ffffffff <unfinished ...>
7202  02:52:24.118027 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.118044 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.118070 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.118079 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.118085 <... futex resumed> ) = 0
7201  02:52:24.118092 <... futex resumed> ) = 0
7202  02:52:24.118118 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162921, {1341103945, 118113000}, ffffffff <unfinished ...>
7201  02:52:24.118131 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921183, {1341103945, 118112000}, ffffffff <unfinished ...>
7202  02:52:24.118175 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.118193 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.118221 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.118229 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.118235 <... futex resumed> ) = 0
7201  02:52:24.118242 <... futex resumed> ) = 0
7202  02:52:24.118268 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162923, {1341103945, 118262000}, ffffffff <unfinished ...>
7201  02:52:24.118280 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921185, {1341103945, 118262000}, ffffffff <unfinished ...>
7202  02:52:24.118324 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.118342 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.118367 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.118375 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.118382 <... futex resumed> ) = 0
7201  02:52:24.118388 <... futex resumed> ) = 0
7202  02:52:24.118414 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162925, {1341103945, 118409000}, ffffffff <unfinished ...>
7201  02:52:24.118426 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921187, {1341103945, 118408000}, ffffffff <unfinished ...>
7202  02:52:24.118470 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.118488 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.118514 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.118522 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.118528 <... futex resumed> ) = 0
7201  02:52:24.118539 <... futex resumed> ) = 0
7202  02:52:24.118565 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162927, {1341103945, 118560000}, ffffffff <unfinished ...>
7201  02:52:24.118577 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921189, {1341103945, 118559000}, ffffffff <unfinished ...>
7202  02:52:24.118621 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.118639 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.118663 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.118672 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.118678 <... futex resumed> ) = 0
7201  02:52:24.118684 <... futex resumed> ) = 0
7202  02:52:24.118710 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162929, {1341103945, 118705000}, ffffffff <unfinished ...>
7201  02:52:24.118723 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921191, {1341103945, 118704000}, ffffffff <unfinished ...>
7202  02:52:24.118766 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.118785 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.118810 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.118819 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.118825 <... futex resumed> ) = 0
7201  02:52:24.118831 <... futex resumed> ) = 0
7202  02:52:24.118857 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162931, {1341103945, 118852000}, ffffffff <unfinished ...>
7201  02:52:24.118869 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921193, {1341103945, 118851000}, ffffffff <unfinished ...>
7202  02:52:24.118913 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.118931 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.118958 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.118965 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.118972 <... futex resumed> ) = 0
7201  02:52:24.118978 <... futex resumed> ) = 0
7202  02:52:24.119004 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162933, {1341103945, 118999000}, ffffffff <unfinished ...>
7201  02:52:24.119016 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921195, {1341103945, 118998000}, ffffffff <unfinished ...>
7202  02:52:24.119060 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.119078 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.119104 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.119112 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.119119 <... futex resumed> ) = 0
7201  02:52:24.119125 <... futex resumed> ) = 0
7202  02:52:24.119151 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162935, {1341103945, 119145000}, ffffffff <unfinished ...>
7201  02:52:24.119163 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921197, {1341103945, 119145000}, ffffffff <unfinished ...>
7202  02:52:24.119207 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.119225 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.119251 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.119259 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.119265 <... futex resumed> ) = 0
7201  02:52:24.119271 <... futex resumed> ) = 0
7202  02:52:24.119298 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162937, {1341103945, 119292000}, ffffffff <unfinished ...>
7201  02:52:24.119310 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921199, {1341103945, 119292000}, ffffffff <unfinished ...>
7202  02:52:24.119354 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.119372 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.119400 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.119408 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.119415 <... futex resumed> ) = 0
7201  02:52:24.119421 <... futex resumed> ) = 0
7202  02:52:24.119447 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162939, {1341103945, 119442000}, ffffffff <unfinished ...>
7201  02:52:24.119459 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921201, {1341103945, 119441000}, ffffffff <unfinished ...>
7202  02:52:24.119504 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.119522 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.119547 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.119555 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.119562 <... futex resumed> ) = 0
7201  02:52:24.119568 <... futex resumed> ) = 0
7202  02:52:24.119594 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162941, {1341103945, 119589000}, ffffffff <unfinished ...>
7201  02:52:24.119606 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921203, {1341103945, 119588000}, ffffffff <unfinished ...>
7202  02:52:24.119651 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.119669 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.119694 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.119702 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.119708 <... futex resumed> ) = 0
7201  02:52:24.119714 <... futex resumed> ) = 0
7202  02:52:24.119741 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162943, {1341103945, 119735000}, ffffffff <unfinished ...>
7201  02:52:24.119753 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921205, {1341103945, 119735000}, ffffffff <unfinished ...>
7202  02:52:24.119797 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.119815 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.119840 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.119848 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.119855 <... futex resumed> ) = 0
7201  02:52:24.119861 <... futex resumed> ) = 0
7202  02:52:24.119887 futex(0x24b062c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9162945, {1341103945, 119882000}, ffffffff <unfinished ...>
7201  02:52:24.119899 futex(0x24b06ac, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 9921207, {1341103945, 119881000}, ffffffff <unfinished ...>
7202  02:52:24.119944 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7201  02:52:24.119962 <... futex resumed> ) = -1 ETIMEDOUT (Connection timed out)
7202  02:52:24.119987 futex(0x24b05f0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7201  02:52:24.119995 futex(0x24b0670, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
7202  02:52:24.120002 <... futex resumed> ) = 0
7201  02:52:24.120008 <... futex resumed> ) = 0
