Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0FUGCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 02:02:43 -0400
Received: from n2-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.154]:47246 "HELO
	n2-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751016Ab0FUGCl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 02:02:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 464553.30783.bm@omp129.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0KXoV/7xnwJDhFxhwh2UpkYislH9uJW8K9qKqTTiPgsOpiu3Dj2rMLzFx91oJ5GpjHAxztSKUXYfe/5Mg8ESCLx3NXswNGFb+QOAHvK6scUcnAFrQpVvcl1kT8mc6lOsKnra3RPPe6VorCgBD9La1/A0UpVyaMi7cuhHNiKFVoQ=;
Message-ID: <357982.4867.qm@web180304.mail.gq1.yahoo.com>
X-YMail-OSG: Ij4lCiEVM1nm5rz6fdq_cVg2s5TVm18WvX1UzRbIdR14Erh
 9rkiBd0iwzI8UwH6Ve2SAsvgq.uU_ZPrL0x1pU4x7M4rGpA8x9Nrq5sgcoHC
 3nalIa13uQPOcN7Mj06OT5vGx786Z3F09cGObzuKRg8eh5q7xDDtX6ENhpOx
 T5RnH1v8FuMJI2jupUXA0GshW1OW3oTjGEJsbT5qGacEbeB1zdWQ8Jt2Cawz
 DKWlAqP3z5Fc2Mwqs8dv7_zZBv1MJULYMsl0NCmioroneV_u_MRvXf7Ldbo6
 YLFCJXlUPrn78VJUiLKx.BY8Ks0xhtfnY7W0o3uWtfKlLR.as94TkAXy33Hk
 n2HBlfEqU_4oO7AJZFiYR09WArCg-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.103.269680
Date: Sun, 20 Jun 2010 23:02:40 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Avoid losing wakeup events during suspend
To: markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>
Cc: Neil Brown <neilb@suse.de>, linux-pm@lists.linux-foundation.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mark gross <640e9920@gmail.com>
In-Reply-To: <799617.66764.qm@web180304.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sun, 6/20/10, David Brownell <david-b@pacbell.net> wrote:

... in a sort of "aren't we asking the
wrong questions??" manner ... 


I suspect that
looking at the problem in terms of how to
coordinate subsystems (an abstraction which
is at best very ad-hoc today!) we would
end up with a cleaner model, which doesn't
bother so many folk the ay wakelocks or
even suspend blockers seem to bother them...


> From: David Brownell <david-b@pacbell.net>
> Subject: Re: [linux-pm] [RFC][PATCH] PM: Avoid losing wakeup events during suspend
> To: markgross@thegnar.org, "Alan Stern" <stern@rowland.harvard.edu>
> Cc: "Neil Brown" <neilb@suse.de>, linux-pm@lists.linux-foundation.org, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, "mark gross" <640e9920@gmail.com>
> Date: Sunday, June 20, 2010, 9:04 PM
> 
> > > > Indeed, the same problem arises if the
> event
> > isn't delivered to
> > > > userspace until after userspace is frozen.
> 
> Can we put this more directly:  the problem is
> that the *SYSTEM ISN'T FULLY SUSPENDED* when the
> hardware wake event triggers?  (Where "*SYSTEM*
> includes userspace not just kernel.  In fact the
> overall system is built from many subsystems,
> some in the kernel and some in userspace.
> 
> At the risk of being prematurely general:  I'd
> point out that these subsystems probably have
> sequencing requirements.  kernel-then-user is
> a degenerate case, and surely oversimplified.
> There are other examples, e.g. between kernel
> subsystems...  Like needing to suspend a PMIC
> before the bus it uses, where that bus uses
> a task to manage request/response protocols.
> (Think I2C or SPI.)
> 
> This is like the __init/__exit sequencing mess...
> 
> In terms of userspace event delivery, I'd say
> it's a bug in the event mechanism if taking the
> next step in suspension drops any event.  It
> should be queued, not lost...  As a rule the
> hardware queuing works (transparently)...
> 
> > Of course, the underlying
> > > > issue here is that the kernel has no direct
> way
> > to know when userspace
> > > > has finished processing an event.
> 
> 
> Again said more directly:  there's no current
> mechanism to coordinate subsystems.  Userspace
> can't communicate "I'm ready" to kernel, and
> vice versa.  (a few decades ago, APM could do
> that ... we dropped such mechanisms though, and
> I'm fairly sure APM's implementation was holey.)
> 
> 
> 
> 
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
> 

