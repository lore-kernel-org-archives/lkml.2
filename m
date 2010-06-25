Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab0FYAI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 20:08:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44755 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0FYAIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 20:08:24 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Friesen <chris.friesen@genband.com>, paulmck@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
References: <20100618190251.GA17297@redhat.com>
	<20100618193403.GA17314@redhat.com>
	<20100618223354.GL2365@linux.vnet.ibm.com>
	<20100621170919.GA13826@redhat.com>
	<20100621205128.GI2354@linux.vnet.ibm.com>
	<20100622212357.GA19670@redhat.com>
	<20100622221226.GP2290@linux.vnet.ibm.com>
	<20100623152421.GA8445@redhat.com>
	<20100624180726.GK2373@linux.vnet.ibm.com>
	<4C23A90A.9040303@genband.com> <20100624220007.GB21360@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 24 Jun 2010 17:08:10 -0700
In-Reply-To: <20100624220007.GB21360@redhat.com> (Oleg Nesterov's message of "Fri\, 25 Jun 2010 00\:00\:07 +0200")
Message-ID: <m1sk4c7z4l.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 06/24, Chris Friesen wrote:
>>
>> On 06/24/2010 12:07 PM, Paul E. McKenney wrote:
>>
>> > 3.	The thread-group leader might do pthread_exit(), removing itself
>> > 	from the thread group -- and might do so while the hapless reader
>> > 	is referencing that thread.
>> >
>> > 	But isn't this prohibited?  Or is it really legal to do a
>> > 	pthread_create() to create a new thread and then have the
>> > 	parent thread call pthread_exit()?  Not something I would
>> > 	consider trying in my own code!  Well, I might, just to
>> > 	be perverse, but...  ;-)
>>
>> I believe SUS allows the main thread to explicitly call pthread_exit(),
>> leaving the other threads to run.  If the main() routine just returns
>> then it implicitly calls exit().
>
> Correct.
>
> But, to clarify, if the main thread does pthread_exit() (sys_exit,
> actually), it won't be removed from the group. It will be zombie
> until all other threads exit.

That we don't cleanup that zombie leaders is unfortunate really, it
means we have the entire de_thread special case.  But short fixing
libpthread to not make bad assumptions there is little we can do about
it really.

I'm only half following this conversation.

If what we are looking for is a stable list_head that won't disappear
on us we should be able to put one in sighand_struct or signal_struct
(I forget which is which at the moment) and have a list_head that
lives for the life of the longest living thread, and that won't get
messed up by things like de_thread, and then next_thread could simply
return NULL when we hit the end of the list.

Eric
