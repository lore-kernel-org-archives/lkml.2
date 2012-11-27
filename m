Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2K0WxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:53:10 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57927 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2K0WxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:53:08 -0500
MIME-Version: 1.0
In-Reply-To: <20121127192748.GB7695@redhat.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
	<CAFTL4hzzumANj7hF5hJPZ5pKPhz4YWC-Ukb3yUKdy_DO+vb3wg@mail.gmail.com>
	<20121127154455.GK12969@redhat.com>
	<CAFTL4hyfCt2imzBYW+Sn5QUAwham=ZQ2nNER5Np7Hq4yg1LzxA@mail.gmail.com>
	<20121127163910.GL12969@redhat.com>
	<CAFTL4hyzVLismy0ckx0Tu47EAgNn9WjAFEx=ptF5587-zp65hQ@mail.gmail.com>
	<20121127170026.GM12969@redhat.com>
	<CAFTL4hyb0qYYhy1OE9HDHymFkmHDb5jNyuLNSR2aQ3dKPpuZkw@mail.gmail.com>
	<20121127174737.GN12969@redhat.com>
	<CAFTL4hxh96wDMpBEid0EN8ir-9C=Z+pdy6viVVK5fyKkRbUOOw@mail.gmail.com>
	<20121127192748.GB7695@redhat.com>
Date: Tue, 27 Nov 2012 23:53:07 +0100
Message-ID: <CAFTL4hy1PB3u+i3xEXvz0Zt4kNQx9ioAHaM2BPMfXiNm7Koxmg@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/27 Gleb Natapov <gleb@redhat.com>:
> What is the semantics of enter_idle()/exit_idle(), what are they used for?

It's used by drivers/idle/i7300_idle.c for some tracking. I don't know much
the details.

enter_idle() is called right before the CPU is set to lower power mode: hlt()

exit_idle() is called anytime we exit this low power mode: irq,
polling on need_resched(), etc...

> Not present fault happening in idle task does not mean we exit idle
> task. If this happens exception handler will execute sti; hlt waiting
> for missing page to be ready. Any interrupt happening during this hlt
> will do exit_idle() by itself.

Well, the code executed by this fault should be considered as an exit
from idle mode. Now it's a small piece of code and we hlt() quickly so
I guess getting of idle_exit() there wouldn't hurt much.

It's buggy for now anyway due to that race where we may not have an
opportunity to call back idle_enter() if the fault happens between the
idle_enter() in the idle loop and the hlt() in the idle loop.
