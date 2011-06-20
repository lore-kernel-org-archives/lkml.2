Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab1FTRiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:38:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36269 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab1FTRiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Bfowhp6lG4BqBHg5BPoBSGR6laGPWOHfRTz/gpCG2VMV4qnLfnph6iC0hU6599S9jt
         k9EHhjiZziRhFdQuPh+qbhTtEbEdHMa9oAcSHhCw0YxvWmrrur0gmEr7NT/XZJpxLm3i
         +le6wgOwx8DxFFQ1Hz/cmlCQxBcuE9vrYDCjw=
MIME-Version: 1.0
In-Reply-To: <1308570316.8230.140.camel@bahia.local>
References: <20110615145527.4016.70157.stgit@bahia.local> <BANLkTimSC_OSrbekhM=wd2Gie4np3Q4F5A@mail.gmail.com>
 <1308570316.8230.140.camel@bahia.local>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Mon, 20 Jun 2011 13:37:24 -0400
Message-ID: <BANLkTiknqo0iKry7mjq+mc4iOWj_A_mrrw@mail.gmail.com>
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was Vpid:)
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, serge@hallyn.com, daniel.lezcano@free.fr,
        ebiederm@xmission.com, oleg@redhat.com, xemul@openvz.org,
        Cedric Le Goater <clg@vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 07:45, Greg Kurz <gkurz@fr.ibm.com> wrote:
> On Thu, 2011-06-16 at 13:54 -0400, Bryan Donlan wrote:

>> Although getting the in-namespace PID is a useful thing, wouldn't a
>> truly race-free API be preferable? Any access by PID has the race
>> condition in which the target process could die, and its PID get
>> recycled between retrieving the PID and doing something with it.
>
> Well the PID is a racy construct when used by another task than the
> parent... fortunately, most userland code can cope with it ! :)

That doesn't mean we shouldn't try to fix the race! :)

>> Perhaps a file-descriptor API would be better, such as something like
>> this:
>>
>> int openpid(int id, int flags);
>> int rt_sigqueueinfo_fd(int process_fd, int sig, siginfo_t *info);
>> int sigqueue_fd(int process_fd, int sig, const union sigval value); //
>> glibc wrapper
>>
>
> The race still exists: openpid() is being passed a PID... Only the
> parent can legitimately know that this PID identifies a specific
> unwaited child.

Yes, the idea would be either the parent process, or the target
process itself would open the PID, then pass the resulting file
descriptor to whatever process is actually doing the killing.
Alternately, one could add additional calls to help identify whether
the right process was opened (perhaps a call to get a directory handle
to the corresponding /proc directory?)
