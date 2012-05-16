Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792Ab2EPTb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:31:59 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37252 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab2EPTb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <1337188023.3796.130.camel@schen9-DESK>
References: <1337188023.3796.130.camel@schen9-DESK>
Date: Wed, 16 May 2012 15:31:55 -0400
Message-ID: <CAAsGZS6KJ6jN+0B2Q06gXivaWfMVKX9t-yCYNwZDZ_jzUopviw@mail.gmail.com>
Subject: Re: SCSI RAM driver ported to 3.3 kernel for file system and I/O testing
From: chetan loke <loke.chetan@gmail.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 1:07 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:

> +       while (!kthread_should_stop()) {
> +               struct scsi_cmnd *cmnd;
> +               struct scsi_ram_cmnd *ram_cmnd;
> +
> +               spin_lock_irqsave(host->host_lock, flags);
> +               if (list_empty(&ram_device->commands)) {
> +                       set_current_state(TASK_INTERRUPTIBLE);

> +                       spin_unlock_irq(host->host_lock);

The spin_[un]lock/ variants don't match.


> +static int scsi_ram_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
....

> +       if (use_thread) {
> +               spin_lock_irqsave(shost->host_lock, flags);

> +               if (list_empty(&ram_device->commands))
> +                       wake_up_process(ram_device->thread);

Didn't look in detail but if the queue is empty then why would you
want to wake up the kthread? What if you just wake_up after
list_add_tail below?


> +               list_add_tail(&ram_cmnd->queue, &ram_device->commands);
> +               spin_unlock_irqrestore(shost->host_lock, flags);
> +       } else {
> +               scsi_ram_execute_command(cmnd);
> +       }


Chetan Loke
