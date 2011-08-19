Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1HSQLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:11:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57110 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab1HSQLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:11:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110819155222.GA17879@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
	<1313763382-12341-2-git-send-email-tj@kernel.org>
	<20110819155222.GA17879@redhat.com>
Date: Fri, 19 Aug 2011 18:11:42 +0200
X-Google-Sender-Auth: go9-P4R3CM7CfhaxFENtq3XpoOY
Message-ID: <CAOS58YNRVBJarXdu_HSKj7yX2cSfDr=pLL3OXwPL=ce+iaU8UQ@mail.gmail.com>
Subject: Re: [PATCH 01/16] freezer: fix current->state restoration race in refrigerator()
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Fri, Aug 19, 2011 at 5:52 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Indeed, we can miss kthread->should_stop, and the patch fixes this
> case.
>
> But please look at, say, kauditd_thread(), it does
>
>                DECLARE_WAITQUEUE(wait, current);
>                set_current_state(TASK_INTERRUPTIBLE);
>                add_wait_queue(&kauditd_wait, &wait);
>
>                if (!skb_queue_len(&audit_skb_queue)) {
>                        try_to_freeze();
>                        schedule();
>                }
>
> Now suppose that wake_up_interruptible(&kauditd_wait) happens, and
> after that refrigerator() restores TASK_INTERRUPTIBLE.
>
> Any reason refrigerator() should try to restore? Shouldn't we simply
> change the rules? Yes, probably we will have to fix some users.
>
> But it seems to me it is simply not possible to make this ->state
> restoration correct.

Yes, it's broken, but it's not the only thing broken. There are race
conditions everywhere. Even without freezer, a lot of kthread users
use kthread_should_stop() incorrectly - they test them without setting
sleep state and freezable kthreads are worse as the two conditions can
race each other. I think kthread is just too difficult to use. We can
try to salvage the situation and make kthread more friendly but I
think the better solution would be just converting everyone to use
workqueue or the kthread_wq wrapper. So, yeah, the whole thing is
vastly broken. Let's fix things in baby steps.

Thanks.

-- 
tejun
