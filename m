Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab0IYMXv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 08:23:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42822 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab0IYMXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 08:23:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dW1+Db7jztahgGSocIdemZxrU9lWCLGt6HX3iMC8MA6FHOTC/JY99yIksLKb6R5rwR
         Sdy+V205QUte+fDxPKRTNyRSt3W3zAOXRaSuzqSj7x4p1pgCfTAy/U7np4GbUHFIK+Oj
         AE0j5IqZzPyoyNJyta5o5yEQOyI/zWz8K/Uyg=
Subject: Re: [PATCH] signal: annotate siglock acquisition
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimD2zfLoYrXARs2dNHq7XEjpuVgCxEXEp-qm2Go@mail.gmail.com>
References: <1285406495-20080-1-git-send-email-namhyung@gmail.com>
	 <1285407727.2478.288.camel@edumazet-laptop>
	 <AANLkTimD2zfLoYrXARs2dNHq7XEjpuVgCxEXEp-qm2Go@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Sep 2010 14:23:43 +0200
Message-ID: <1285417423.2478.475.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 25 septembre 2010 à 20:33 +0900, Namhyung Kim a écrit :

> What's the difference? I didn't change the semantics of likely clause
> but simply exchange the order of then-else part because IMHO a
> negative expression make it hard to understand, generally.
> I've checked compiled binaries for both cases on x86 and they
> produced exactly same code.
> 


Anyway, re-reading your patch, I just dont get why you use __cond_lock()
two times, but not on this part ?

if (!likely(__cond_lock(&t->sighand->siglock,
			lock_task_sighand(t, &flags))))
	goto ret;

This way, your patch would not be misleading.


Another way to deal with this sparse mess is to use a macro, like we do
for read_trylock() :

#define read_trylock(lock)    __cond_lock(lock, _raw_read_trylock(lock))

-->

#define lock_task_sighand(t, flags) 			\
	__cond_lock(&(t)->sighand->siglock,		\
		    _raw_lock_task_sighand(t, flags))



