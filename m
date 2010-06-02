Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab0FBIc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:32:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62037 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0FBIcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=tdUaIkAFrAsimBnuLhiC9v0/o7Y0Gwwlno5uuLx5WlTffaXmV8Y21mEbf142qaCR7C
         /MooQXoeaxDMNiF769K4jThvao9Rsk3RedCciMlvJN2yxXo5NQOaT2jxiUpICniu+roU
         Y0m+wSA6ux8UYboUxLeeFCmPheGG+AqTmsSvw=
Message-ID: <4C061715.5060700@gmail.com>
Date: Wed, 02 Jun 2010 10:32:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100522 SUSE/3.1rc1-2.1 Thunderbird/3.1
MIME-Version: 1.0
To: rpurdie@rpsys.net
CC: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: INPUT: leds trigger LOCKDEP (GFP_KERNEL alloc inside spinlock)
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get the following warning when booting with lockdep turned on:
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2469 lockdep_trace_alloc+0xbc/0xd0()
Hardware name: Bochs
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.34-mm1_64+ #5
Call Trace:
 [<ffffffff8106408a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81324826>] ? device_create_vargs+0x56/0x110
 [<ffffffff810640d5>] warn_slowpath_null+0x15/0x20
 [<ffffffff8109359c>] lockdep_trace_alloc+0xbc/0xd0
 [<ffffffff810f65b2>] kmem_cache_alloc+0x32/0xf0
 [<ffffffff81324826>] device_create_vargs+0x56/0x110
 [<ffffffff8132490c>] device_create+0x2c/0x30
 [<ffffffff810828ce>] ? up_read+0x1e/0x40
 [<ffffffff8142068c>] led_classdev_register+0x2c/0xe0
 [<ffffffff814213de>] input_led_connect+0x21e/0x2c0
 [<ffffffff813d2395>] ? input_register_handler+0x25/0x110
 [<ffffffff813cfd87>] input_attach_handler+0x1c7/0x210
 [<ffffffff81abc666>] ? input_led_init+0x0/0x12
 [<ffffffff813d2433>] input_register_handler+0xc3/0x110
 [<ffffffff81abc666>] ? input_led_init+0x0/0x12
 [<ffffffff81abc676>] input_led_init+0x10/0x12
 [<ffffffff810002f9>] do_one_initcall+0x39/0x1a0
 [<ffffffff81a95d83>] kernel_init+0x16e/0x1f8
 [<ffffffff8102ab14>] kernel_thread_helper+0x4/0x10
 [<ffffffff8159917c>] ? restore_args+0x0/0x30
 [<ffffffff81a95c15>] ? kernel_init+0x0/0x1f8
 [<ffffffff8102ab10>] ? kernel_thread_helper+0x0/0x10
---[ end trace e7273345439c18af ]---
Registered led device: input::numl


It is because input_led_connect makes an atomic context and calls from
that led_classdev_register. In this function there are several functions
which might sleep, so this is incorrect.

Is it necessary that input_led_registered_lock is a spinlock? Can't it
be simply a mutex?

regards,
-- 
js
