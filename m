Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1AOXPD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 18:15:03 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55847 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab1AOXPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 18:15:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=RLLT0pDblC7kWbV1EpFbbdOslWi4PMIYKzkcqzenJXx9l3rN7Lcy46atn3wBWW7u3A
         RpWfzOgUg1yhnUbKB/l77cxXgGSlhxQ9G+4pQJvkMg1rUX+Umd+il1XnyIwsaIKJgq3J
         Ojm1CLYIJGHKkMsiHt+BXqfWCf3bhBQmhb0MU=
Date: Sun, 16 Jan 2011 00:13:15 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, oprofile-list@lists.sf.net
Cc: Robert Richter <robert.richter@amd.com>
Subject: oprofile: possible circular locking dependency detected
Message-ID: <20110115231315.GA2980@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Lockdep finds possible circular locking dependency during 
opcontrol --start on 2.6.37 kernel:

[   22.457859] =======================================================
[   22.458289] [ INFO: possible circular locking dependency detected ]
[   22.458508] 2.6.37+ #539
[   22.458720] -------------------------------------------------------
[   22.458939] oprofiled/2365 is trying to acquire lock:
[   22.459156]  (buffer_mutex){+.+...}, at: [<ffffffff813a7177>] sync_buffer+0x2f/0x3e5
[   22.459658] 
[   22.459659] but task is already holding lock:
[   22.460083]  ((task_exit_notifier).rwsem){++++..}, at: [<ffffffff81095721>] __blocking_notifier_call_chain+0x5c/0x8e
[   22.460590] 
[   22.460590] which lock already depends on the new lock.
[   22.460591] 
[   22.461224] 
[   22.461225] the existing dependency chain (in reverse order) is:
[   22.461652] 
[   22.461652] -> #1 ((task_exit_notifier).rwsem){++++..}:
[   22.462183]        [<ffffffff810a32a1>] lock_acquire+0x144/0x189
[   22.462438]        [<ffffffff8144646a>] down_write+0x3f/0x62
[   22.462695]        [<ffffffff810958a5>] blocking_notifier_chain_register+0x4d/0x85
[   22.463124]        [<ffffffff81097e9e>] profile_event_register+0x28/0x2a
[   22.463380]        [<ffffffff813a76c2>] sync_start+0x42/0xb8
[   22.463633]        [<ffffffff813a660e>] oprofile_setup+0x5b/0xa1
[   22.463888]        [<ffffffff813a77d1>] event_buffer_open+0x54/0x87
[   22.464142]        [<ffffffff81116182>] __dentry_open+0x21e/0x354
[   22.464398]        [<ffffffff81116395>] nameidata_to_filp+0x50/0x57
[   22.464652]        [<ffffffff81122c03>] do_last+0x480/0x5c7
[   22.464907]        [<ffffffff811247f6>] do_filp_open+0x1d3/0x5ee
[   22.465161]        [<ffffffff81115e8a>] do_sys_open+0x5b/0xf8
[   22.465415]        [<ffffffff81115f50>] sys_open+0x1b/0x1d
[   22.465668]        [<ffffffff81034cfb>] system_call_fastpath+0x16/0x1b
[   22.465924] 
[   22.465925] -> #0 (buffer_mutex){+.+...}:
[   22.466453]        [<ffffffff810a2ae0>] __lock_acquire+0xf85/0x1602
[   22.466708]        [<ffffffff810a32a1>] lock_acquire+0x144/0x189
[   22.466961]        [<ffffffff81445f4d>] mutex_lock_nested+0x5e/0x304
[   22.467216]        [<ffffffff813a7177>] sync_buffer+0x2f/0x3e5
[   22.467470]        [<ffffffff813a753e>] task_exit_notify+0x11/0x15
[   22.467725]        [<ffffffff81095482>] notifier_call_chain+0x74/0xa1
[   22.467980]        [<ffffffff81095736>] __blocking_notifier_call_chain+0x71/0x8e
[   22.468409]        [<ffffffff81095762>] blocking_notifier_call_chain+0xf/0x11
[   22.468665]        [<ffffffff81097ef6>] profile_task_exit+0x15/0x17
[   22.468920]        [<ffffffff81075580>] do_exit+0x25/0x7a7
[   22.469175]        [<ffffffff81075d80>] do_group_exit+0x7e/0xa9
[   22.469429]        [<ffffffff81075dbd>] sys_exit_group+0x12/0x16
[   22.469683]        [<ffffffff81034cfb>] system_call_fastpath+0x16/0x1b
[   22.469938] 
[   22.469939] other info that might help us debug this:
[   22.469939] 
[   22.470573] 1 lock held by oprofiled/2365:
[   22.470788]  #0:  ((task_exit_notifier).rwsem){++++..}, at: [<ffffffff81095721>] __blocking_notifier_call_chain+0x5c/0x8e
[   22.471329] 
[   22.471329] stack backtrace:
[   22.471752] Pid: 2365, comm: oprofiled Not tainted 2.6.37+ #539
[   22.471970] Call Trace:
[   22.472183]  [<ffffffff810a0fc3>] print_circular_bug+0xae/0xbd
[   22.472403]  [<ffffffff810a2ae0>] __lock_acquire+0xf85/0x1602
[   22.472624]  [<ffffffff810688f4>] ? sub_preempt_count+0x9e/0xb1
[   22.472845]  [<ffffffff813a7177>] ? sync_buffer+0x2f/0x3e5
[   22.473063]  [<ffffffff810a32a1>] lock_acquire+0x144/0x189
[   22.473282]  [<ffffffff813a7177>] ? sync_buffer+0x2f/0x3e5
[   22.473500]  [<ffffffff810a0d2c>] ? check_usage_backwards+0x0/0xc9
[   22.473721]  [<ffffffff813a7177>] ? sync_buffer+0x2f/0x3e5
[   22.473940]  [<ffffffff813a7177>] ? sync_buffer+0x2f/0x3e5
[   22.474158]  [<ffffffff81445f4d>] mutex_lock_nested+0x5e/0x304
[   22.474378]  [<ffffffff813a7177>] ? sync_buffer+0x2f/0x3e5
[   22.474597]  [<ffffffff813a7177>] sync_buffer+0x2f/0x3e5
[   22.474815]  [<ffffffff81095721>] ? __blocking_notifier_call_chain+0x5c/0x8e
[   22.475037]  [<ffffffff81095721>] ? __blocking_notifier_call_chain+0x5c/0x8e
[   22.475259]  [<ffffffff813a753e>] task_exit_notify+0x11/0x15
[   22.475478]  [<ffffffff81095482>] notifier_call_chain+0x74/0xa1
[   22.475698]  [<ffffffff81095736>] __blocking_notifier_call_chain+0x71/0x8e
[   22.475920]  [<ffffffff81071095>] ? do_fork+0x2e9/0x3cf
[   22.476138]  [<ffffffff81095762>] blocking_notifier_call_chain+0xf/0x11
[   22.476359]  [<ffffffff81097ef6>] profile_task_exit+0x15/0x17
[   22.476578]  [<ffffffff81075580>] do_exit+0x25/0x7a7
[   22.476797]  [<ffffffff81447ead>] ? retint_swapgs+0xe/0x13
[   22.477017]  [<ffffffff81075d80>] do_group_exit+0x7e/0xa9
[   22.477236]  [<ffffffff81075dbd>] sys_exit_group+0x12/0x16
[   22.477454]  [<ffffffff81034cfb>] system_call_fastpath+0x16/0x1b

