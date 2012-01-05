Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab2AEHUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 02:20:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159Ab2AEHUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 02:20:40 -0500
Date: Thu, 5 Jan 2012 09:20:05 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jump label: close race in jump_label_inc() vs.
 jump_label_dec()
Message-ID: <20120105072005.GP2072@redhat.com>
References: <201201041532.q04FWbBl022103@int-mx10.intmail.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201041532.q04FWbBl022103@int-mx10.intmail.prod.int.phx2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 10:32:37AM -0500, Jason Baron wrote:
> The previous fix to ensure that jump_label_inc() does not return until the jump
> is completely patched, opened up a race in the inc/dec path. The scenario is:
> 
> key->enabled = 0;
> 
> 	CPU 0					CPU 1
>         ----- 					-----
> 
> jump_label_inc():			jump_label_dec():
> 
> 1) if (atomic_read(&key->enabled) == 0)
> 	jump_label_update(key, JUMP_LABEL_ENABLE);
> 
> 					 2) if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex))
> 					 	return;
> 
> 3) atomic_inc(&key->enabled);
> 
> So now, key->enabled = 0, but the jump has been enabled, which is an invalid
> state.
> 
Isn't it an indication of a higher level bug if jump_label_dec() is
called on a disabled jump label? In other words isn't key->enabled == -1
invalid sate by itself? I do not see how the call sequence above can
happen with perf events for instance. jump_label_dec() is called on
event destruction and if key->enabled = 0 then there is no events to
destroy.

--
			Gleb.
