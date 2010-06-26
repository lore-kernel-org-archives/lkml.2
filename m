Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab0FZQyF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 12:54:05 -0400
Received: from n4-vm0.bullet.mail.gq1.yahoo.com ([67.195.9.7]:40090 "HELO
	n4-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753294Ab0FZQyD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 12:54:03 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 132882.57780.bm@omp121.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=h8A8ZEBIf0v0ESZm7SEZFLfHm8OLk97QJrbp5eGK93T0IgP77werIpO4S586d4EmdMsmQzFoYj4//9KMwRbgov2MimGAaY+iFvwcEF6Yt4eFai48XnBK0o4e8hDOQPfaCH9sX+hFpK9USqElB0VYeeB2UfUZkQSgbrn1WEqUr1Q=;
Message-ID: <18366.69939.qm@web180315.mail.gq1.yahoo.com>
X-YMail-OSG: tlIaPQQVM1nnDewp_lCnpVCBhnGjDd7gVsn2T3FW3E0l9Yc
 qhT5LsHh_MycaIwv.JCqcD3a39ywuILFc7IO.Kd1I8LZovL7_DsgOrdMfVgz
 jekdjHh9sK4YEBXDygB_DFh2r1GYA0gHAoBl5mCNswWvUvSlb4tJ_0jnPqcP
 M46G0ygTcriMIMbSpxk2Lx9pw.OEscAYOXb5dXEQbNZTj3sEPTQUzzGtj_Id
 ErZzUj_7x.RbunUWtfrWP.AUr0aaUyPwzVTy9v0h3myyewmjK5Fy0akzX5O9
 emgSEHquE5ly0HTLKDZIaEytDUHSPW66OiZU84QSiEQEp5jHif12BOYQ-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Sat, 26 Jun 2010 09:54:00 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [PATCH] PM: Make it possible to avoid wakeup events from being lost
To: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mark gross <640e9920@gmail.com>, Neil Brown <neilb@suse.de>,
       linux-pci@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arve@smtp1.linux-foundation.org, Florian Mickler <florian@mickler.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a repeat of an issue I posted before, but
which for some reason I never saw email back ...

basically, I think the notion of counting wakeup
events seems dubious on common hardware, so the
focus might perhaps better be placed on ensuring
userspace just receives events rather than
trying to track events which in one context ended
up being wakeup events.  (That's simpler, and the
system is by definition awake if it can handle any
events at all.)

Thing is, "wakeup" is, for e.g. most ARMs, just a hardware attribute of what's otherwise a routine
event, which happens in other contexts and needs
to be handled consistently .... nothing special
about having woken the system too, the result ought to
be the same regardless (from the user P.O.V.) ...  (Common Examples include SoC peripheral IRQs that can wake the system (including GPIO and other types
of external IRQ signal.)

BRIEFLY:  if that event doesn't arrive reliably,
it's an issue regardless of wakeup:  either TX from
kernel, or RX in userspace. Such bugs would need to
be fixed.  Having them fixed will help the wakeup scenarios too of course.

(The raciness issues might boil down to something as simple as not letting userspace know about transition events to/from suspend states, but that issue
ought to be cleanly separable; ISTR other messages on the suspend blocker threads have shown how to work with such clean factoring.)



So trying to track whether a given event is what
woke the system will often be implausible, since
several such events might each have fired (one
or more concurrent wakeup sources, even ... it
could be indeterminate which one[s] happened.)
And the event could fire without being a wakeup.

Yes, there are a few cases (like USB remote wakeup
signaling and some PCI mechanisms, plus a few BIOS
assisted situations) where certain events may be
identifiable as wakeup sources, perhaps runtime not
system-wide).  But the common case just includes
an event, not the ability to know that event had
the "woke whole system from low power state"
side effect too.




> +        The
> /sys/power/wakeup_count file allows user space to avoid
> +        losing wakeup events
> when transitioning the system into a sleep
> +        state.  Reading
> from it returns the current number of registered
> +        wakeup events and it
> blocks if some wakeup events are being
> +        processed at the
> time the file is read from. 


