Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2BBJUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:20:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39536 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2BBJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:20:19 -0500
Message-ID: <4F2A5552.70302@linaro.org>
Date: Thu, 02 Feb 2012 13:20:18 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Module/kthread/printk question/problem
References: <4F2963AA.3010306@linaro.org>   <1328113899.1882.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>   <4F2969B7.4040202@linaro.org>  <1328116594.1882.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <4F2A296E.5080007@linaro.org> <1328168701.2902.14.camel@edumazet-laptop>
In-Reply-To: <1328168701.2902.14.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 11:45 AM, Eric Dumazet wrote:

> Remove the wait_for_completion(), this brings nothing at all, as you
> already discovered.

I want to get the module 'locked' until all threads are completed.

> Then you need cooperation from worker threads : they must wait for
> kthread_should_stop(), or else your kthread_stop(arg) pass an already
> freed "arg" memory block.

I designed the cooperation in another way: after each successful call
of X = kthread_run(...), I do get_task_struct(X), and the module exit
code is something like:

...
wait_for_completion(&done);
for (i = 0; i < nrthreads; i++) {
	kthread_stop(threads[i]);
	put_task_struct(threads[i]);
}
kfree(threads);
...

The crash is go away, so I believe this is reasonable. Anyway, it would
be nice to have a debug option to detect such a suspicious errors.

Thanks,
Dmitry
