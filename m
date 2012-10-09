Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2JIPSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:18:54 -0400
Received: from relay.parallels.com ([195.214.232.42]:47567 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2JIPSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:18:51 -0400
Message-ID: <5074403F.9020707@parallels.com>
Date: Tue, 9 Oct 2012 19:18:23 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@openvz.org" <devel@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>
Subject: [RFC] Posix timers improvements, requied for CRIU project
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
We would like to make CRIU able to migrate posix timers.
Currently we require additional info, which have to be provided by kernel.
In particular, it's:
1) Timers id's.
2) Timer clock (gained by id).
3) Timer sigevent structure.
4) Timer current overrun status (not the last one).

We are not sure, how to implement such support properly.

Right now we are considering two approaches of posix timers interface update 
(for dump):

1) First one it to use /proc filesystem to provide posix timers data by task 
(something like /proc/<pid>/posix_timers)

2) Second one is to add new system calls like:

int timer_getnext(int start_id);	// return next timer id after start-id
int timer_getclock(timer_t id, cclock_t *clock); // return clock
int timer_getsigevent(timer_t id, struct sigevent *evp); // return sigevent
int timer_getoverrun_cur(timer_t id, int *overrun); // current overrun

Of course, both approaches can be combined.

Also, we require a syscall to set desired overrun (on restore):

int timer_setoverrun(timer_t id, int *overrun);

Moreover, we need to make posix timer id to be allocated per task (not globally) 
to make sure, that we can restore timer with desired id (desired id can be 
passed to timer_create() in timerid variable).
Our current idea is to replace idr by hash table, where 
"per_process_struct_signal + per_process_id" will be the key.

We would greatly appreciate any comments or suggestions.
Thanks.

-- 
Best regards,
Stanislav Kinsbursky
