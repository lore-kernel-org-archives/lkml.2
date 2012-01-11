Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab2AKT7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:59:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62961 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680Ab2AKT7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:59:30 -0500
Date: Wed, 11 Jan 2012 23:59:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyle Moffett <kyle@moffetthome.net>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [RFC] on general object IDs again
Message-ID: <20120111195925.GK466@moon>
References: <20120111161939.GI8752@moon>
 <CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com>
 <20120111175952.GI466@moon>
 <CAHGf_=oMk2YDnmsomgCc45Ei5yaSdNzRwapm7Fqm9mN7LY0FNw@mail.gmail.com>
 <4F0DD365.6070200@parallels.com>
 <20120111183115.GA28196@moon>
 <CAHGf_=oXsrbsXPqBw_CvZQjwdXhzhqkoWX3mRSEgMZHy44ZUKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHGf_=oXsrbsXPqBw_CvZQjwdXhzhqkoWX3mRSEgMZHy44ZUKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 02:29:48PM -0500, KOSAKI Motohiro wrote:
> >> > Then, you only need to compare. not any other calculation. i.e. only
> >> > need id uniqueness.
> >> > And any resource are referenced from tasks. so, can you reuse pid for
> >> > this? example,
> >> > two taska share one mm.
> >> >
> >> > task-a(pid: 100)
> >> >               |-----------------mm
> >> > task-b(pid: 200)
> >> >
> >> >
> >> > gen_obj_id(task-b, GEN_OBJ_ID_VM) return 100. (youngest pid of referenced tasks)
> >>
> >> We can, but determining the youngest pid for an mm struct is O(N) algo.
> >> Having N tasks with N mm_structs getting the sharing picture becomes O(N^2).
> >
> > Yeah, exactly. If not the speed problem we would simply stick
> > with Andrew's proposal as two-id-are-the-same(pid1, pid2)
> > syscall.
> 
> Why O(N^2) is matter? Typical HPC system have mere a few hundred pids.
> so, O(N^2) is not slow. How do you mesure Andrew's proposal?
> 

I consider quadratic approach only as a path where nothing
else can go. So to be fair -- I didn't measure such syscall.

> If you have 1000 pids and each syscall need 10usec,
> 
> 1000 * 1000 * 10 = 10,000,000usec = 10sec. But, important thing is, almost all
> processes don't share fs, mm and other structs. then, if we check
> reference count before task traversal, required time may reduce 1/10x - 1/100x.
> 

Sure thing, until some number of pids this will work (since compare two pointers
is very fast), but I fear eventually we will hit situation were such trade off
beat us. Also note that we do ask not only mm IDs, but ->files, ->signals,
->sysv.undo-list and so on (and who knows what else might be needed
in future). Since there is a hardware support for AES encoding on new
CPUs I think this is significant.

But again, Kosaki, if there some other fast way to retrieve such info,
it should be considered of course.

Technically for us plain kernel pointers would be enough unde root-only
approach but I've been strongly adviced to export such IDs via safe way
to a regular users as well (you could find the former patches from Pavel
in LKML archives).

	Cyrill
