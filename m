Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2GJWRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:17:18 -0400
Received: from nm20-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.165]:43886 "HELO
	nm20-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752990Ab2GJWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:17:17 -0400
X-Yahoo-Newman-Id: 212452.52646.bm@smtp205.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Cb2XL2UVM1kHhrsGKUCr7K.bkf._qtpG3f1jzorp74FWoRL
 xpMBUl038mNSNZPS7S5wyLrW6b0IaO07zhEFS9_bWip75GlIpeDzaWFyntrM
 O.cMRbVQrhRKcnmwT6AlSaPm0fXlb5Yv.ODNdAYSFW_O.SidonigX6q9Xqja
 cpKtJi_x_z6958ZuvcLRFjX3LYE0XYbwXp4VdycqvtIFYsLU_iIkmAKwt9sM
 aJ6LhTAeP9S.oUkxlPmhdGVHX9sC153Irk_S0NLYUXPO76plvYpN7whecoP7
 z0KWrPURIegtCqIrSyNwCDovLAz1xsDvZFEd8NTXwcjW3Lm4rO4OL2bLXtlz
 h0VMxuBNdHABpuzz2SpxzcUzIP4GuarC08WVrnilHH5fq9_poVMgAvynKNQk
 4eMdqYChAFEFGtkwWiprsryKAZGZEa3rFFaQN9HFu7aRDQ2Df87NMUCAe7ei
 XQCu6kxTSietJvqAqYXzEVe9LlEbbIZipMfQk80UUxvEFBZdVjacytB_yt0g
 tt9O_joI5cd5fEcunAkOIzNo8s3JzCoqG1e_hZK5eunyx5GtxW13ilio.Egd
 lWRjeP8SUoSkYOeIaSk3TGQJ67R9W5Q--
X-Yahoo-SMTP: o1R3GOSswBCR5HtEryCkTqkT7hY-
From: "Alec Matusis" <alecm@chatango.com>
To: <linux-kernel@vger.kernel.org>
Subject: bogus utime and stime in /proc/<PID/stat - possibly related to fs/proc/array.c change
Date: Tue, 10 Jul 2012 15:17:12 -0700
Message-ID: <14e201cd5ee9$c1b57ce0$452076a0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1e4t0jRI9+3Uq3SOSSP3XOMzlqwg==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I run a number of Linux servers and I noticed an interesting bug, possibly
related to a recent change in fs/proc/array.c

After upgrading from Ubuntu 2.6.24-26 to 2.6.32-40 (and higher) in Ubuntu, I
noticed that about once per month, suddenly, a user process causing the main
load on a given machine disappears from "top", but it still continues to run
normally (perhaps with a slight performance decrease). After this, the load
average of the system remains the same, but the top shows no running
processes causing the load. This happened on a variety of new IBM System X
machines, all running different tasks (httpd 2.2, mysqld 5.1, Twisted Python
TCP servers).

I looked at a problematic process, and discovered that ps -o pcpu showed
crazily large numbers:

#ps -o pcpu,pid,cmd -p1587
%CPU   PID CMD
317713124 1587 /nail/encap/mysql-5.1.60/libexec/mysqld

Then I looked at: 

# cat /proc/1587/stat
 1587 (mysqld) S 1212 1088 1088 0 -1 4202752 14307313 0 162 0 85773299069
4611685932654088833 0 0 20 0 52 0 3549 27255418880 5483524
18446744073709551615 4194304 11111617 140733749236976 140733749235984
8858659 0 552967 4102 26345 18446744073709551615 0 0 17 5 0 0 0 0

I noticed that the 14th and 15th entry 85773299069     4611685932654088833
(utime and stime) become abnormally large and they were stuck. When the
server is in the normal state (i.e. the system load-causing process shows up
on top, and ps -o pcpu shows reasonable %CPU) , these numbers are 13 orders
of magnitude smaller, e.g.  416786 602262, and they are advancing by about
10 per second. 

I do not understand what causes this problem, expect that I know that
machines with 2.6.24-26 or earlier do not have this behavior, and since then
there was a change in fs/proc/array.c.

I wrote this up in detail in
http://serverfault.com/questions/406489/load-causing-processes-disappearing-
from-top-ps-o-pcpu-shows-bogus-numbers

If you have any comment on this, it'd be highly appreciated.

Thank you.


Alec Matusis



