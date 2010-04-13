Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab0DMG43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 02:56:29 -0400
Received: from mail.deheime.ch ([62.12.167.34]:54737 "EHLO limpopo.deheime.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab0DMG41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 02:56:27 -0400
Message-ID: <20100413085625.18523z9qoyil6zcw@limpopo.deheime.ch>
Date: Tue, 13 Apr 2010 08:56:25 +0200
From: Stefan Agner <stefan@agner.ch>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: I attached a test module to reproduce this bug. Does I miss
	something in my code or is there a bug?
References: <20100412182325.161358ntday18s1o@limpopo.deheime.ch>
	<alpine.LFD.2.00.1004122207300.18009@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004122207300.18009@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_3yqw8j1z7ji8"
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format.

--=_3yqw8j1z7ji8
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

Quoting Thomas Gleixner <tglx@linutronix.de>:
> please use short and descriptive subject lines. "I attached a test
> module to reproduce this bug ..." does not tell anything.
>
> On Mon, 12 Apr 2010, Stefan Agner wrote:
>
>> Unable to handle kernel paging request at kthread_should_stop
>
> That would have been the real subject line :)
In fact this was my intended Subject line... The current subject line was a
copy and paste accident! Due to the fact that my online mailer eats mails
sometimes before I can send them, I wrote it in an editor.

>> I attached a test module to reproduce this bug.  Does I miss something in=
 my
>> code or is there a bug?
>
> There are several bugs in your code :)
>
>> static int runloop(void *unused)
>> {
>>
>> =09int ret;
>>
>> =09/* Daemonize */
>> =09daemonize(MODULE_NAME);
>
>  Do not call daemonize() for a kthread created with kthread_create().
>  That was necessary for kthreads created with kernel_thread.
Removing this already solved the bug message.

I fixed all other bugs as well and attached the updated file.

Thanks a lot

--=20
Stefan Agner



----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

--=_3yqw8j1z7ji8
Content-Type: text/x-csrc;
	charset=ISO-8859-1;
	name="kthread-test.c"
Content-Disposition: inline;
	filename="kthread-test.c"
Content-Transfer-Encoding: quoted-printable

#include <linux/module.h>
#include <linux/kthread.h>
#include <linux/hrtimer.h>

#define THREAD_PRIORITY (80)
#define THREAD_SCHEDULER SCHED_FIFO
#define MODULE_NAME "test-module"
#define KLOG_PREFIX MODULE_NAME ": "

struct task_struct *thread;
static ktime_t thread_next;
static ktime_t now;

/*
 * Threaded Runloop
 */
static int runloop(void *unused)
{

=09struct sched_param param =3D { .sched_priority =3D THREAD_PRIORITY };

=09/* Set realtime priorty */
=09sched_setscheduler(thread, THREAD_SCHEDULER, &param);

=09/* Allow SIGTERM signal */
=09allow_signal(SIGTERM);

=09/* Calculate first shot */
=09now =3D ktime_get();
=09thread_next =3D ktime_add_us(now, 500);

=09do {
=09=09set_current_state(TASK_UNINTERRUPTIBLE);
=09=09schedule_hrtimeout(&thread_next, HRTIMER_MODE_ABS);

=09=09thread_next =3D ktime_add_us(thread_next, 500);
=09} while (!kthread_should_stop());

=09printk(KERN_INFO KLOG_PREFIX "Thread exited\n");
=09return 0;
}

int __init init_test_module(void)
{
=09/* Create kernel thread */
=09thread =3D kthread_run((void *)&runloop, NULL, MODULE_NAME);
        if (IS_ERR(thread))=20
        {
=09=09printk(KERN_INFO KLOG_PREFIX ": unable to start kernel thread\n");
                return -ENOMEM;
        }

=09return 0;
}

void __exit cleanup_test_module(void)
{
        if(thread !=3D NULL)
                kthread_stop(thread);
        thread =3D NULL;
}

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Stefan Agner <stefan@anger.ch");
MODULE_DESCRIPTION("kthread test module");

module_init(init_test_module);
module_exit(cleanup_test_module);

--=_3yqw8j1z7ji8--

