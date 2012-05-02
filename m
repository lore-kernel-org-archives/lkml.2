Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2EBRc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:32:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43036 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2EBRc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:32:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com> <m11un5zzzb.fsf@fess.ebiederm.org>
	<20120502124015.GA3657@redhat.com>
Date: Wed, 02 May 2012 10:37:06 -0700
In-Reply-To: <20120502124015.GA3657@redhat.com> (Oleg Nesterov's message of
	"Wed, 2 May 2012 14:40:15 +0200")
Message-ID: <m1vckemqm5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18c+HH9b+XsUEZ6Q/DiW0ex4syXhFlsRvc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: [RFC PATCH] namespaces: fix leak on fork() failure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 04/29, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > On 04/29, Eric W. Biederman wrote:
>> >>
>> >> There are crazy code paths like daemonize()
>> >
>> > Forget. It has no callers anymore, should be killed. A user-space process
>> > should never use kernel_thread() and thus daemonize() is not needed.
>>
>> Good point.  Oleg do you think you can send in the patches to kill
>> daemonize.
>
> Yes, will do. I am waiting until the last user in arch/powerpc goes
> away, the patch is already in mm.

Well I don't quite know what the path was but it looks like that change
has already hit Linus's tree:


commit 37ef9bd48af6ab9a3d1fd28df4f929abc19f2cc3
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Wed Mar 28 12:20:57 2012 +0000

    powerpc/eeh: Remove eeh_event_handler()->daemonize()
    
    daemonize() is only needed when a user-space task does kernel_thread().
    
    eeh_event_handler() thread is created by the worker kthread, and thus it
    doesn't need the soon-to-be-deprecated daemonize().
    
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>
    Acked-by: Linas Vepstas <linasvepstas@gmail.com>
    Acked-by: Tejun Heo <tj@kernel.org>
    Acked-by: Matt Fleming <matt.fleming@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

diff --git a/arch/powerpc/platforms/pseries/eeh_event.c b/arch/powerpc/platforms/pseries/eeh_event.c
index 4a47525..92dd84c 100644
--- a/arch/powerpc/platforms/pseries/eeh_event.c
+++ b/arch/powerpc/platforms/pseries/eeh_event.c
@@ -59,7 +59,7 @@ static int eeh_event_handler(void * dummy)
        struct eeh_event *event;
        struct eeh_dev *edev;
 
-       daemonize("eehd");
+       set_task_comm(current, "eehd");
        set_current_state(TASK_INTERRUPTIBLE);
 
        spin_lock_irqsave(&eeh_eventlist_lock, flags);


Eric
