Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab1KKQRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:17:09 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36902 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599Ab1KKQRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:17:07 -0500
Message-ID: <4EBD4A7E.7060102@parallels.com>
Date: Fri, 11 Nov 2011 20:17:02 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
References: <4EBC0696.9030103@parallels.com>	<4EBC06DB.3090202@parallels.com>	<20111110184654.GA1006@redhat.com>	<20111110185603.GA1757@redhat.com>	<4EBCF4E7.4090002@parallels.com>	<20111111152532.GA22640@redhat.com>	<4EBD461E.1000106@parallels.com> <CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com>
In-Reply-To: <CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 08:06 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Nov 11, 2011 at 7:58 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
>>> Hmm. It seems, we can make a simpler patch to achieve the (roughly)
>>> same effect. Without touching copy_process/alloc_pid paths. What if
>>> we simply add PR_SET_LAST_PID? (or something else).
>>>
>>> In this case the new init (created normally) read the pids from image
>>> file and does prcrl(PR_SET_LAST_PID, pid-1) before the next fork.
>>>
>>> What do you think?
>>
>> This will make it impossible to fork() children on restore in parallel. And
>> I don't want to lose this ability :(
> 
> It's highly unlikely that the ability to fork in parallel would
> contribute to any meaningful speedup. That is not the critical path by
> *far* and I don't think it's worth optimizing for. Forking in serial
> and restoring the rest of states in parallel should be enough.

Well, I wouldn't say that for sure, but anyway. I'm not talking here about the
performance issues only. If we accept that we fork tasks one-by-one, then this
creates great synchronization problems.

First of all - let's imagine that we just want to clone a set of tasks. Then
each of them will have to fork its kids, then report first of them that he's
OK to fork and wait for it to report back, that forking is done. Then do the
same for the rest of them. This is not impossible, but painful.

Next - let's consider we have some tasks sharing various resources, e.g. mm-s
or fd-tables. This means, that these tasks should be cloned in the carefully
calculated sequence with CLONE_XXX flags set. In this case the described above
scheme with fork() serialization simply won't work and we'll have to invent
some fancy messaging with "now X fork with Y pid" and "X done with forking,
please go on" messages.

> Thanks.
> 

