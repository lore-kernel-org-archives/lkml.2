Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0EEWxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:53:39 -0400
Received: from forward8.mail.yandex.net ([77.88.61.38]:43094 "EHLO
	forward8.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab0EEWxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:53:37 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 May 2010 18:53:36 EDT
X-Yandex-Spam: 1
X-Yandex-Front: web86.yandex.ru 
X-Yandex-TimeMark: 1273099499 
From: Vitaliy Gusev <gblond@yandex.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: xemul@openvz.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100427155416.4d3436fa.akpm@linux-foundation.org>
References: <20100427155416.4d3436fa.akpm@linux-foundation.org>
Subject: Re: Fw: Re: [PATCH] bsdacct: delete timer with sync intension
MIME-Version: 1.0
Message-Id: <71161273099498@web86.yandex.ru>
Date: Thu, 06 May 2010 02:44:58 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,  Andrew!

27.04.10, 15:54, "Andrew Morton" <akpm@linux-foundation.org>:
>  On Thu, 25 Mar 2010 17:35:10 +0300
>  Vitaliy Gusev  wrote:
>  
>  > acct_exit_ns --> acct_file_reopen deletes timer without
>  > check timer execution on other CPUs. So acct_timeout() can
>  > change an unmapped memory.
>  > 
>  
>  That sounds ugly.
>  
>  > 
>  > ---
>  >  kernel/acct.c |   17 +++++++++--------
>  >  1 files changed, 9 insertions(+), 8 deletions(-)
>  > 
>  > diff --git a/kernel/acct.c b/kernel/acct.c
>  > index a6605ca..6ac80ca 100644
>  > --- a/kernel/acct.c
>  > +++ b/kernel/acct.c
>  > @@ -353,17 +353,18 @@ restart:
>  >  
>  >  void acct_exit_ns(struct pid_namespace *ns)
>  >  {
>  > - struct bsd_acct_struct *acct;
>  > + struct bsd_acct_struct *acct = ns->bacct;
>  >  
>  > - spin_lock(&acct_lock);
>  > - acct = ns->bacct;
>  > - if (acct != NULL) {
>  > - if (acct->file != NULL)
>  > - acct_file_reopen(acct, NULL, NULL);
>  > + if (acct == NULL)
>  > + return;
>  >  
>  > - kfree(acct);
>  > - }
>  > + del_timer_sync(&acct->timer);
>  > + spin_lock(&acct_lock);
>  > + if (acct->file != NULL)
>  > + acct_file_reopen(acct, NULL, NULL);
>  >   spin_unlock(&acct_lock);
>  > +
>  > + kfree(acct);
>  >  }
>  >  
>  
>  Is this sufficient?  acct_file_reopen() does a del_timer(), so
>  acct_timeout() could be running concurrently with acct_file_reopen(),
>  but acct_file_reopen() is merrily altering data at *acct.

Yes, It is sufficient. Don't mind about concurency acct_file_reopen() with
acct_timeout(). It is safe. Even if acct_timeout occurs after del_timer, then
only one bad thing can be  - set needcheck at valid *acct.

>  
>  Perhaps acct_file_reopen() should be using del_timer_sync()?

acct_file_reopen() is called within locked &acct_lock, and unlock/lock will
bring another race.


>  
>  check_free_space() is doing a similar thing:
>  
>           del_timer(&acct->timer);
>           acct->needcheck = 0;
>  
>  the currently-running timer handler now goes and sets needcheck again!

check_free_space() is called only for active task in pid_namespace.  But acct_exit_ns()
is called when there is no any  thread in pid_namespace. Thus timer handler will no set again.


>  
>  Methinks the whole thing needs a bit of a rethink, bearing in mind how
>  del_timer() actually works.
> 

--
Vitaliy Gusev
