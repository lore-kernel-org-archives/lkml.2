Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2ITSkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:40:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58758 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab2ITSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:40:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120920182651.GH28934@google.com>
References: <20120913205827.GO7677@google.com> <505A725B.2080901@amacapital.net>
 <20120920182651.GH28934@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Sep 2012 11:39:46 -0700
Message-ID: <CALCETrX78_twPUkNTZbtXQv9yBnW+-c9RhetassdrQKicOiDFg@mail.gmail.com>
Subject: Re: [RFC] cgroup TODOs
To: Tejun Heo <tj@kernel.org>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.org>, Michal Hocko <mhocko@suse.cz>,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        serge.hallyn@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 11:26 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Wed, Sep 19, 2012 at 06:33:15PM -0700, Andy Lutomirski wrote:
>> [grr.  why does gmane scramble addresses?]
>
> You can append /raw to the message url and see the raw mssage.
>
>   http://article.gmane.org/gmane.linux.kernel.containers/23802/raw

Thanks!

>
>> >   I think this level of flexibility should be enough for most use
>> >   cases.  If someone disagrees, please voice your objections now.
>>
>> OK, I'll bite.
>>
>> I have a server that has a whole bunch of cores.  A small fraction of
>> those cores are general purpose and run whatever they like.  The rest
>> are tightly controlled.
>>
>> For simplicity, we have two cpusets that we use.  The root allows all
>> cpus.  The other one only allows the general purpose cpus.  We shove
>> everything into the general-purpose-only cpuset, and then we move
>> special stuff back to root.  (We also shove some kernel threads into a
>> non-root cpuset using the 'cset' tool.)
>
> Using root for special stuff probably isn't a good idea and moving
> bound kthreads into !root cgroups is already disallowed.

Agreed.  I do it this way because it's easy and it works.  I can
change it in the future if needed.

>
>> Enter systemd, which wants a hierarchy corresponding to services.  If we
>> were to use it, we might end up violating its hierarchy.
>>
>> Alternatively, if we started using memcg, then we might have some tasks
>> to have more restrictive memory usage but less restrictive cpu usage.
>>
>> As long as we can still pull this off, I'm happy.
>
> IIUC, you basically want just two groups w/ cpuset and use it for
> loose cpu ioslation for high priority jobs.  Structure-wise, I don't
> think it's gonna be a problem although using root for special stuff
> would need to change.

Right.

But what happens when multiple hierarchies go away and I lose control
of the structure?  If systemd or whatever sticks my whole session or
my service (or however I organize it) into cgroup /whatever, then
either I can put my use-all-cpus tasks into /whatever/everything or I
can step outside the hierarchy and put them into /everything.  The
former doesn't work, because

<quote>
The following rules apply to each cpuset:

 - Its CPUs and Memory Nodes must be a subset of its parents.
</quote>

The latter might confuse systemd.

My real objection might be to that requirement a cpuset can't be less
restrictive than its parents.  Currently I can arrange for a task to
simultaneously have a less restrictive cpuset and a more restrictive
memory limit (or to stick it into a container or whatever).  If the
hierarchies have to correspond, this stops working.

--Andy
