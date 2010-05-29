Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0E2IDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 04:03:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53998 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab0E2IDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 04:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=svk5mRCWLQ1jk4I4mQdCTYSFtKp2OUXdKgjzU22w6PADqQPuJleyeXZj1GjmHeZMor
         bn8J9Cjx6Eqj6li9vvCT6/PpJ4sc7B4ffxECB/tP814uKBN/3V9w5Yoaz3Zy/6i0nL1D
         txxc4uNkhfM7NMS6mc5u4+Q6dfXmD+TCAJUvc=
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100528132953.7af88c08.akpm@linux-foundation.org>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
	 <20100528132953.7af88c08.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 May 2010 11:03:30 +0300
Message-Id: <1275120210.2668.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 13:29 -0700, Andrew Morton wrote:
> void mark_sb_dirty(struct super_block *sb)
> {
> 	sb->s_dirty = 1;
> 
> 	if (!supers_timer_armed) {
> 		spin_lock(&supers_timer_lock);
> 		if (!supers_timer_armed) {
> 			bdi_arm_supers_timer();
> 			supers_timer_armed = 1;
> 		}
> 	} else if (supers_timer_armed == -1)
> 		spin_lock(&supers_timer_lock);
> 		if (supers_timer_armed == -1)
> 			supers_timer_armed = 1;
> 		spin_unlock(&supers_timer_lock);
> 	}
> }
> 
> I didn't try very hard there, but you get the idea: examine the state
> before taking that expensive global spinlock, so we only end up taking
> the lock once per five seconds, rather than once per possible
> superblock dirtying.  That's like a six-orders-of-magnitude reduction
> in locking frequency, which is worth putting some effort into.

Andrew, thanks for review!

I just did not consider spinlock to be expensive because I thought that
marking superblock as dirty is a relatively rare operation. And my small
experiments kind of confirmed that.

But  Nick suggested a good locking scheme which uses only smp_mb() in
this thread, which I am going to stick with.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

