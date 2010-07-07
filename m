Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0GGOHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 10:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab0GGOHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 10:07:09 -0400
Date: Wed, 7 Jul 2010 10:00:35 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: MEDIA: lirc, improper locking
Message-ID: <20100707140035.GB29996@redhat.com>
References: <4C3478AA.7070805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3478AA.7070805@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 02:52:58PM +0200, Jiri Slaby wrote:
> Hi,
> 
> stanse found a locking error in lirc_dev_fop_read:
> if (mutex_lock_interruptible(&ir->irctl_lock))
>   return -ERESTARTSYS;
> ...
> while (written < length && ret == 0) {
>   if (mutex_lock_interruptible(&ir->irctl_lock)) {    #1
>     ret = -ERESTARTSYS;
>     break;
>   }
>   ...
> }
> 
> remove_wait_queue(&ir->buf->wait_poll, &wait);
> set_current_state(TASK_RUNNING);
> mutex_unlock(&ir->irctl_lock);                        #2
> 
> If lock at #1 fails, it beaks out of the loop, with the lock unlocked,
> but there is another "unlock" at #2.

Yeah, ok, I see the problem there, should be able to get a patch to fix it
in flight later today.

Thanks much,

-- 
Jarod Wilson
jarod@redhat.com

