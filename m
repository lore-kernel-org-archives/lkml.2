Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab1D1Kao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:30:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59506 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab1D1Kam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dkjpwKdCjmEn3QLsb6KSP1BnL37iuVyZvZzY1aad+L6sFWBvsCAsfCPxKA3m6ny63N
         lV43GwWE78gbIt0DLmHK/jIj1U0ieyFoH3zQ2O+uxc7wvOr4Q0+LY+EAGI39KnETXvEO
         pv8l7TH2NvSBRvZfPQ/aPOVa7dh5I7OFO9URw=
Date: Thu, 28 Apr 2011 12:30:36 +0200
From: Tejun Heo <tj@kernel.org>
To: Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
Message-ID: <20110428103036.GB10721@htj.dyndns.org>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com>
 <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
 <201104172135.40189.arnd@arndb.de>
 <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
 <20110426131132.GG878@htj.dyndns.org>
 <BANLkTin71zQH2qDNiwPp6vQppy3YWhbj2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin71zQH2qDNiwPp6vQppy3YWhbj2A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 28, 2011 at 01:51:34AM +0200, Thilo-Alexander Ginkel wrote:
> Well, I get your point. ;-) Maybe this fact can help as a motivator: I
> ran some further tests and while -rc3 seems to be ok (and survived 100
> suspend/resume cycles), the issue strangely seems to be back with -rc4
> (the softlockup call stack that I can see is identical to the photos
> below; the lockup happened after only two cycles).
> 
> > Before I go ahead and try that, do you happen to have softlockup dump?
> > ie. stack traces of the stuck tasks?  I can't find the original
> > posting.
> 
> Sure:
> 
> From <BANLkTi=n4jLsjOYCd0L3hYb30sgPmdv_WA@mail.gmail.com>:
> > Unfortunately, the output via a serial console becomes garbled after
> > "Entering mem sleep", so I went for patching dumpstack_64.c and a
> > couple of other source files to reduce the verbosity. I hope not to
> > have stripped any essential information. The result is available in
> > these pictures:
> >   https://secure.tgbyte.de/dropbox/IeZalo4t-1.jpg
> >   https://secure.tgbyte.de/dropbox/IeZalo4t-2.jpg
> >
> > For both traces, the printed error message reads: "BUG: soft lockup -
> > CPU#3 stuck for 67s! [kblockd:28]"

Does your kernel have preemption enabled?  If not, does the following
patch fix the problem?

Thanks.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 04ef830..08c7334 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1293,6 +1293,7 @@ __acquires(&gcwq->lock)
 
 		/* CPU has come up inbetween, retry migration */
 		cpu_relax();
+		cond_resched();
 	}
 }
