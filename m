Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab2JaUKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:10:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40527 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760350Ab2JaUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:10:32 -0400
Message-ID: <509185A3.1020105@gmail.com>
Date: Wed, 31 Oct 2012 16:10:11 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 21/21] TTY: move tty buffers to tty_port
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz> <1350592007-9216-22-git-send-email-jslaby@suse.cz> <50897E98.5080502@gmail.com> <50911F67.3040303@suse.cz> <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com> <5091448D.3@suse.cz>
In-Reply-To: <5091448D.3@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 11:32 AM, Jiri Slaby wrote:
> On 10/31/2012 04:30 PM, Sasha Levin wrote:
>> On Wed, Oct 31, 2012 at 8:53 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>> On 10/25/2012 08:02 PM, Sasha Levin wrote:
>>>> Fuzzing with trinity inside a KVM tools (lkvm) guest with -next kernel
>>>> uncovered the following warning:
>>>
>>> I cannot reproduce that :(. Do you still see it?
>>
>> Yes, it reproduces pretty easily while fuzzing.
> 
> What is your exact setup? I tried trinity with 100 000 syscalls inside
> KVM with an LDEP-enabled kernel. How many serial ports do you have in
> the guest? Any USB serials in there?

btw, I'm also seeing the following lockups, don't know if it's related:


[ 2283.070569] INFO: task trinity-child20:9161 blocked for more than 120 seconds.
[ 2283.071775] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2283.074673] trinity-child20 D ffff8800276cb000  5424  9161   6364 0x00000000
[ 2283.076018]  ffff880059d9da58 0000000000000002 0000000000000002 0000000000000000
[ 2283.077393]  ffff880059d7b000 ffff880059d9dfd8 ffff880059d9dfd8 ffff880059d9dfd8
[ 2283.078763]  ffff8800276cb000 ffff880059d7b000 ffff880059d9da78 ffff88001a095180
[ 2283.084144] Call Trace:
[ 2283.085039]  [<ffffffff83a98bd5>] schedule+0x55/0x60
[ 2283.086748]  [<ffffffff83a98bf3>] schedule_preempt_disabled+0x13/0x20
[ 2283.089000]  [<ffffffff83a9735d>] __mutex_lock_common+0x36d/0x5a0
[ 2283.090658]  [<ffffffff83a9afb3>] ? tty_lock_nested+0x73/0x80
[ 2283.091691]  [<ffffffff83a9afb3>] ? tty_lock_nested+0x73/0x80
[ 2283.092779]  [<ffffffff83a975cf>] mutex_lock_nested+0x3f/0x50
[ 2283.093875]  [<ffffffff83a9afb3>] tty_lock_nested+0x73/0x80
[ 2283.094872]  [<ffffffff83a9afcb>] tty_lock+0xb/0x10
[ 2283.095443]  [<ffffffff81bae880>] tty_open+0x270/0x5f0
[ 2283.096181]  [<ffffffff8127cda8>] chrdev_open+0xf8/0x1d0
[ 2283.097054]  [<ffffffff8127693c>] do_dentry_open+0x1fc/0x310
[ 2283.098015]  [<ffffffff8127ccb0>] ? cdev_put+0x20/0x20
[ 2283.098943]  [<ffffffff8127777a>] finish_open+0x4a/0x60
[ 2283.099935]  [<ffffffff81286947>] do_last+0xb87/0xe70
[ 2283.100910]  [<ffffffff812844b0>] ? link_path_walk+0x70/0x900
[ 2283.101553]  [<ffffffff81286cf2>] path_openat+0xc2/0x500
[ 2283.102282]  [<ffffffff83a9a314>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[ 2283.103506]  [<ffffffff8128716c>] do_filp_open+0x3c/0xa0
[ 2283.104282]  [<ffffffff81296c11>] ? __alloc_fd+0x1e1/0x200
[ 2283.105278]  [<ffffffff81277c0c>] do_sys_open+0x11c/0x1c0
[ 2283.106519]  [<ffffffff81277ccc>] sys_open+0x1c/0x20
[ 2283.107241]  [<ffffffff81277d01>] sys_creat+0x11/0x20
[ 2283.107975]  [<ffffffff83a9be18>] tracesys+0xe1/0xe6
