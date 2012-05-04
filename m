Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab2EDQ5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:57:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60877 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752525Ab2EDQ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:57:29 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19MbcwUTTVMiaEQs0UFKCChBCgIa2bWoOcwLGcIp5
	xlmcdmAn3TwOGH
Message-ID: <1336150643.7502.4.camel@marge.simpson.net>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Fri, 04 May 2012 18:57:23 +0200
In-Reply-To: <m1zk9oc61j.fsf@fess.ebiederm.org>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	 <20120429165846.GA19054@redhat.com>
	 <1335754867.17899.4.camel@marge.simpson.net>
	 <m1zk9rmyh4.fsf@fess.ebiederm.org>
	 <20120501134214.f6b44f4a.akpm@linux-foundation.org>
	 <1336014721.7370.32.camel@marge.simpson.net>
	 <1336057018.8119.46.camel@marge.simpson.net>
	 <1336105676.7356.42.camel@marge.simpson.net>
	 <m1aa1oidmn.fsf@fess.ebiederm.org>
	 <1336124716.25479.36.camel@marge.simpson.net>
	 <m1vckcdoey.fsf@fess.ebiederm.org>
	 <1336142995.25479.49.camel@marge.simpson.net>
	 <m1zk9oc61j.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 08:36 -0700, Eric W. Biederman wrote: 
> Mike Galbraith <efault@gmx.de> writes:
> 
> > On Fri, 2012-05-04 at 07:13 -0700, Eric W. Biederman wrote: 
> >> Mike Galbraith <efault@gmx.de> writes:
> 
> >> Did you have HZ=100 in that kernel?  400 tasks at 100Hz all serialized
> >> somehow and then doing synchronize_rcu at a jiffy each would account
> >> for 4 seconds.  And the nsproxy certainly has a synchronize_rcu call.
> >
> > HZ=250
> 
> Rats.  Then non of my theories even approaches holding water.
> 
> >> The network namespace is comparatively heavy weight, at least in the
> >> amount of code and other things it has to go through, so that would be
> >> my prime suspect for those 29 seconds.  There are 2-4 synchronize_rcu
> >> calls needed to put the loopback device.  Still we use
> >> synchronize_rcu_expedited and that work should be out of line and all of
> >> those calls should batch.
> >> 
> >> Mike is this something you are looking at a pursuing farther?
> >
> > Not really, but I can put it on my good intentions list.
> 
> About what I expected.  I just wanted to make certain I understood the
> situation.
> 
> I will remember this as something weird and when I have time perhaps
> I will investigate and track it.
> 
> >> I want to guess the serialization comes from waiting on children to be
> >> reaped but the namespaces are all cleaned up in exit_notify() called
> >> from do_exit() so that theory doesn't hold water.  The worst case
> >> I can see is detach_pid from exit_signal running under the task list lock.
> >> but nothing sleeps under that lock.  :(
> >
> > I'm up to my ears in zombies with several instances of the testcase
> > running in parallel, so I imagine it's the same with hackbench.
> 
> Oh interesting.
> 
> > marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench -namespace& for i in 1 2 3 4 5 6 7 ; do ps ax|grep defunct|wc -l;sleep 1; done
> > [1] 29985
> > Running with 10*40 (== 400) tasks.
> > 1
> > 397
> > 327
> > 261
> > 199
> > 135
> > 72
> > marge:/usr/local/tmp/starvation # Time: 7.675
> 
> So if I read your output right the first second is spent running the
> code and the rest of the time is spent reaping zombies.

The distance between these is mighty fishy.

marge:~ # grep 'signalfd_cleanup ' /trace2
          vsftpd-9628  [003] ....   712.571961: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.575717: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.579698: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.587734: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.591671: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.595695: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.599685: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.603680: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.607682: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.611692: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.615740: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.619705: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.623730: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.627748: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.631712: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.635741: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.643683: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.647685: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.651691: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.655742: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.659738: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.663738: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.667756: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.671693: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.679682: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.683694: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.687750: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.691738: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.695751: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.699740: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.703736: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.707757: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.711685: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.715689: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.719694: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.723742: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.727752: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.731695: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.739687: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.743688: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.747697: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.751689: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.755688: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.759699: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.763705: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.767754: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.771702: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.775749: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.775884: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.783754: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.787754: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.791763: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.795764: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.799755: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.807768: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.835723: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.843695: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.847752: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.851694: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.855711: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.859704: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.863751: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.867754: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.871753: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.875765: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.879706: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.883696: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.887697: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.891711: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.898493: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.911740: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.927755: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.955754: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.975771: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   712.995826: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.003739: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.003920: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.011710: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.015831: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.023827: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.031694: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.035715: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.039714: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.043816: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.047726: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.051818: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.055724: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.059814: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.063725: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.067824: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.071825: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.075726: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.079709: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.083814: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.087850: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.095859: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.099826: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.103830: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.107726: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.111723: signalfd_cleanup <-__cleanup_sighand
          vsftpd-9628  [003] d...   713.115874: signalfd_cleanup <-__cleanup_sighand



