Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab2AEOj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:39:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35237 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab2AEOj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:39:58 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=sfBY0qdRI6cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=FXrnKF72FBUWNUD0mxQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325774396.12696.49.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] jump label: close race in jump_label_inc() vs.
 jump_label_dec()
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: gleb@redhat.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 09:39:56 -0500
In-Reply-To: <201201041532.q04FWbBl022103@int-mx10.intmail.prod.int.phx2.redhat.com>
References: <201201041532.q04FWbBl022103@int-mx10.intmail.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 10:32 -0500, Jason Baron wrote:
> The previous fix to ensure that jump_label_inc() does not return until the jump
> is completely patched, opened up a race in the inc/dec path. The scenario is:

You forgot something:


> 
> key->enabled = 0;
> 
> 	CPU 0					CPU 1
>         ----- 					-----

  jump_label_lock();

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

  jump_label_unlock();



> 
> So now, key->enabled = 0, but the jump has been enabled, which is an invalid
> state.

How does key->enabled end up == 0?

As Gleb said, it's a higher level bug if we do a jump_label_dec() when
key->enabled already is zero.

Thus, in this scenario, we enter jump_label_inc() with key->enabled=1,
and 1) will not be true. When we hit 2), it will have to grab the
jump_label_mutex, which will be held, thus it will block until CPU 0 is
finished, in which case, key->enabled=1 and the
atomic_dec_and_mutex_lock() will fail and return.

The end result is key->enabled=1 and we have jump labels enabled.

What's the invalid state?

-- Steve


