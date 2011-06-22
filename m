Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab1FVPBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:01:00 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:45840 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab1FVPA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:00:59 -0400
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
 Vpid:)
From: Greg Kurz <gkurz@fr.ibm.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, serge@hallyn.com, daniel.lezcano@free.fr,
        ebiederm@xmission.com, oleg@redhat.com, xemul@openvz.org,
        Cedric Le Goater <clg@vnet.ibm.com>
In-Reply-To: <BANLkTiknqo0iKry7mjq+mc4iOWj_A_mrrw@mail.gmail.com>
References: <20110615145527.4016.70157.stgit@bahia.local>
	 <BANLkTimSC_OSrbekhM=wd2Gie4np3Q4F5A@mail.gmail.com>
	 <1308570316.8230.140.camel@bahia.local>
	 <BANLkTiknqo0iKry7mjq+mc4iOWj_A_mrrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 17:00:37 +0200
Message-ID: <1308754837.2959.58.camel@bahia.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-20 at 13:37 -0400, Bryan Donlan wrote:
> On Mon, Jun 20, 2011 at 07:45, Greg Kurz <gkurz@fr.ibm.com> wrote:
> > On Thu, 2011-06-16 at 13:54 -0400, Bryan Donlan wrote:
> 
> >> Although getting the in-namespace PID is a useful thing, wouldn't a
> >> truly race-free API be preferable? Any access by PID has the race
> >> condition in which the target process could die, and its PID get
> >> recycled between retrieving the PID and doing something with it.
> >
> > Well the PID is a racy construct when used by another task than the
> > parent... fortunately, most userland code can cope with it ! :)
> 
> That doesn't mean we shouldn't try to fix the race! :)
> 
> >> Perhaps a file-descriptor API would be better, such as something like
> >> this:
> >>
> >> int openpid(int id, int flags);
> >> int rt_sigqueueinfo_fd(int process_fd, int sig, siginfo_t *info);
> >> int sigqueue_fd(int process_fd, int sig, const union sigval value); //
> >> glibc wrapper
> >>
> >
> > The race still exists: openpid() is being passed a PID... Only the
> > parent can legitimately know that this PID identifies a specific
> > unwaited child.
> 
> Yes, the idea would be either the parent process, or the target
> process itself would open the PID, then pass the resulting file
> descriptor to whatever process is actually doing the killing.

Agreed. Such an API would be useful in a scenario where the task to be
killed and the killing task can share a file descriptor: same thread
group or inherited with clone() or connected with an AF_UNIX socket.
My point was just that the racy pid based API will still be needed to
handle all the other scenarios. But maybe it's fine to have two sets of
process handling calls.

> Alternately, one could add additional calls to help identify whether
> the right process was opened (perhaps a call to get a directory handle
> to the corresponding /proc directory?)

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

