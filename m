Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1JNAJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 20:09:25 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:35038 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1JNAJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 20:09:24 -0400
Date: Thu, 13 Oct 2011 20:09:13 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Paul Menage <paul@paulmenage.org>,
        linux-kernel@vger.kernel.org, bblum@andrew.cmu.edu
Subject: BUG: cgroup_task_counter subsys may crash with whole-threadgroup
 move
Message-ID: <20111014000913.GA22527@ghc17.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_900_999 0, __ANY_URI 0, __CD 0, __CP_URI_IN_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was testing some patches for cgroup_attach_proc and managed to cause a
crash with the following usage pattern:

    mount -t cgroup none -o tasks /dev/cgroup
    cd /dev/cgroup
    mkdir foo
    echo $PID > foo/cgroup.procs
    echo $PID > tasks
    echo $PID > foo/cgroup.procs

Where $PID is the thread ID of a member of a multithreaded process (my
test program just does CLONE_THREAD 8 times and then all threads sleep).
(It doesn't matter if the thread is the group leader or not, but a
single-threaded process doesn't crash.)

And get the following kernel panic:
http://maximegalon.andrew.cmu.edu/cgroup-taskstats/panic.txt

It's deterministic, and happens only when the "tasks" subsystem is
mounted.

I'm using user-mode linux to test, with the following config:
http://maximegalon.andrew.cmu.edu/cgroup-taskstats/config.txt

and I ran it in GDB to get the following backtrace:
http://maximegalon.andrew.cmu.edu/cgroup-taskstats/bt.txt

Thanks,
Ben
