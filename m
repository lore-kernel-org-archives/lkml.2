Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2KEWwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:52:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2KEWwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:52:09 -0500
Date: Mon, 5 Nov 2012 14:52:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH] tasklet: ignore disabled tasklet in tasklet_action
Message-Id: <20121105145207.6d2fae92.akpm@linux-foundation.org>
In-Reply-To: <1351824534-2861-1-git-send-email-xtfeng@gmail.com>
References: <1351824534-2861-1-git-send-email-xtfeng@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Nov 2012 10:48:54 +0800
Xiaotian Feng <xtfeng@gmail.com> wrote:

> We met a ksoftirqd 100% issue, the perf top shows kernel is busy
> with tasklet_action(), but no actual action is shown. From dumped
> kernel, there's only one disabled tasklet on the tasklet_vec.
> 
> tasklet_action might be handled after tasklet is disabled, this will
> make disabled tasklet stayed on tasklet_vec. tasklet_action will not
> handle disabled tasklet, but place it on the tail of tasklet_vec,
> still raise softirq for this tasklet. Things will become worse if
> device driver uses tasklet_disable on its device remove/close code.
> The disabled tasklet will stay on the vec, frequently __raise_softirq_off()
> and make ksoftirqd wakeup even if no tasklets need to be handled.
> 
> This patch introduced a new TASKLET_STATE_HI bit to indicate HI_SOFTIRQ,
> in tasklet_action(), simply ignore the disabled tasklet and don't raise
> the softirq nr. In my previous patch, I remove tasklet_hi_enable() since
> it is the same as tasklet_enable(). So only tasklet_enable() needs to be
> modified, if tasklet state is changed from disable to enable, use
> __tasklet_schedule() to put it on the right vec.

gee, I haven't looked at the tasklet code in 100 years.  I think I'll
send this in Thomas's direction ;)

The race description seems real and the patch looks sane to me.  Are
you sure we can get away with never clearing TASKLET_STATE_HI?  For
example, what would happen if code does a tasklet_hi_schedule(t) and
later does a tasklet_schedule(t)?


