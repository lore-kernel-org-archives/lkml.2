Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab0DJH0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 03:26:34 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:60770 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab0DJH0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 03:26:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=post.cz;
	h=Received:From:To:Date:MIME-Version:Subject:CC:Message-ID:Priority:In-reply-to:References:X-mailer:Content-type:Content-transfer-encoding:Content-description:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=DNxpgKhU/oY1aVX3m6chEjmQ4ILAglwQnJnZNLfU/Jb2M8EBQmWGRj8YPwHt4hJdM
	MBBQ1lSEKIvRFcWKYJJ+Y9U9+HyIrlLeWLkcVZauTLfKJPD81hquycuVyywCCkfnzOt
	Ku3gAI0wsjq0LyCC7HZBFK/VYXWTBy87ETHs2rg=
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Sat, 10 Apr 2010 09:26:24 +0200
MIME-Version: 1.0
Subject: Re: setitimer vs. threads: SIGALRM returned to which thread? (process master or individual child)
CC: bill o gallmeister <bog.kernel@gmail.com>
Message-ID: <4BC04440.17716.2AAF4DA@Frantisek.Rysanek.post.cz>
In-reply-to: <4BBF9B8F.3030106@gmail.com>
References: <4BBFA0C6.2610.2C4FFE@Frantisek.Rysanek.post.cz>, <4BBF9B8F.3030106@gmail.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.1.7@13984
X-Seznam-User: frantisek.rysanek@post.cz
X-QM-Mark: email-qm2<540511907>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 Apr 2010 at 23:26, bill o gallmeister wrote:
>
> Check out timer_create() rather than setitimer().
> 
Oh I *see* :-)  There seems to be a way to deliver an event to a 
specific thread. Just a quick guess, haven't validated this by a 
compiler:

============ PSEUDOCODE SNIPPET ==========
struct my_thr_data
{
   pthread_t ID; /* to be set upon pthread_create() */
   /* ...further members... */
};

void* my_fn(void* my_user_data)
{
    pthread_kill( ((my_thr_data*)my_user_data)->ID, SIGALRM);
}

struct my_thr_data this_thread;
timer_t my_timer;
struct sigevent my_event =
{
   sigev_notify: SIGEV_THREAD,
   sigev_notify_function: my_fn,
   sigev_value.sival_ptr: &this_thread,
   sigev_notify_attributes: NULL   
}

timer_create(CLOCK_REALTIME, &my_event, &my_timer);

/* by now we're set up, but the timer doesn't tick yet. */

/* someplace later in the code: */
timer_settime(my_timer, ...  );


=========== /PSEUDOCODE SNIPPET ==============
thank you :-)

Frank Rysanek
