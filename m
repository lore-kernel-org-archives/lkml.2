Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478Ab2EQJYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:24:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761400Ab2EQJYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:24:36 -0400
Message-ID: <4FB4C3CE.9010907@redhat.com>
Date: Thu, 17 May 2012 12:24:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/5] kvm: host side for eoi optimization
References: <20120516172058.GA22861@amt.cnet> <20120516175856.GD10769@redhat.com> <20120516181500.GA23791@amt.cnet> <20120516182520.GH28798@redhat.com> <20120516182948.GF10769@redhat.com> <20120516183822.GI28798@redhat.com> <20120516190757.GA12113@redhat.com> <20120517072841.GW32036@redhat.com> <20120517074946.GA27995@redhat.com> <4FB4AF6D.9080305@redhat.com> <20120517080731.GZ32036@redhat.com>
In-Reply-To: <20120517080731.GZ32036@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 11:07 AM, Gleb Natapov wrote:
> > 
> > No, let's refactor this so it makes sense.  The {has|get}_interrupt
> > split is the cause of the problem, I think.  We need a single function,
> > with callbacks that are called when an event happens.  The callbacks can
> > request an irq window exit, inject an interrupt, play with pveoi, or
> > cause a #vmexit.
> > 
> Not sure what do you mean here. I kind of like the code we have now, but
> this may be because I understand it :)

Right now we have

   if (has_interrupt)
       do something
   if (get_interrupt)
       do_something_else

this duplicates some of the logic and causes non-atomicty (which isn't a
problem per se, but requires us to think of what happens if conditions
change between the two steps).

What I'm thinking of is

   void process_interrupt(bool (*handle)());

Where the return value tells us whether the interrupt was accepted by
the handler.  The callback could decide to enable the irq window, to
queue the interrupt, or to #vmexit (note that the latter can return
either true or false, depending on whether vmx is configured to ack the
interrupt or not; svm would return true here if interrupts are intercepted).

-- 
error compiling committee.c: too many arguments to function

