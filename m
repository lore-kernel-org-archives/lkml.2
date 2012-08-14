Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2HNWP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:15:29 -0400
Received: from exprod6og109.obsmtp.com ([64.18.1.23]:56330 "EHLO
	exprod6og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HNWP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:15:27 -0400
Message-ID: <6.2.5.6.2.20120814150529.04aace70@adobe.com>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Tue, 14 Aug 2012 15:13:55 -0700
To: Christof Meerwald <cmeerw@cmeerw.org>
From: "Paton J. Lewis" <palewis@adobe.com>
Subject: Re: [PATCH] epoll: Improved support for multi-threaded clients
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>
In-Reply-To: <20120814202125.GH1407@edge.cmeerw.net>
References: <F044A95E1307394EBA6055B1B7144CD2010CFB1B748F@NAMBX02.corp.adobe.com>
 <20120616184707.GA22656@edge.cmeerw.net>
 <6.2.5.6.2.20120618161807.031eb6c8@adobe.com>
 <20120619181711.GE1281@edge.cmeerw.net>
 <6.2.5.6.2.20120629140909.04bb0a40@adobe.com>
 <6.2.5.6.2.20120802174226.04afdcd0@adobe.com>
 <20120814202125.GH1407@edge.cmeerw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 8/14/2012 01:21 PM, Christof Meerwald wrote:
>Hi Paton,
>
>On Thu, Aug 02, 2012 at 06:37:06PM -0700, Paton J. Lewis wrote:
>[...]
> > My first concern is about code clarity. Using a custom event to
> > delete an event type (either EPOLLIN or EPOLLOUT) from an epoll item
> > requires that functionality to be split across two areas of code:
> > the code that requests the deletion (via the call to epoll_ctl), and
> > the code that responds to it (via epoll_wait).
>
>But don't you have a similar problem in your proposal as well as you
>might get an EBUSY when trying to disabling the item - in which case
>you would have to do the deletion in the epoll_wait loop.

Good point.

> > However, my main concern is about performance. Handling a custom
> > event means that each return from epoll_wait requires the responding
> > thread to check for possible custom events, which in the case of
> > deletion is going to be relatively rare. Thus code which was once
> > purely concerned with responding to I/O events must now spend a
> > fraction of its time testing for exceptional conditions. In
> > addition, handling deletion in this manner now requires a thread or
> > context switch.
>
>But in your initial proposal you also had the code checking for
>deletion in the epoll_wait loop.

Also true. However, I believe the context switch is always required 
by the custom message passing technique, but will not always happen 
when using the event disabling technique.


> > Given the drawbacks listed above, and the kernel design philosophy
> > of only implementing what is actually needed, I would argue for
> > sticking with the original EPOLL_CTL_DISABLE proposal for now.
>
>I have finally had some chance to play around with your patch a bit
>and I really think that you don't want to check for
>ep_is_linked(&epi->rdllink) in ep_disable as I don't see that this
>would provide any useful semantics with respect to race-conditions.
>I.e. consider the point in the epoll_wait loop just after you have
>re-enabled to item - in this case ep_disable would (almost certainly)
>return EBUSY, but there is no guarantee that epoll_wait will be woken
>up on the next iteration.
>
>As I mentioned, I think it would be much more useful to check for
>"epi->event.events & ~EP_PRIVATE_BITS" instead which I believe would
>provide more useful semantics.

You are correct. Thanks for being patient and persistent here. I 
discovered this problem myself last week during testing, and I am 
planning to post a v2 patch proposal that includes this fix.

I am also working on an epoll self-test as Andrew Morton suggested. 
I'm going to finish that before re-submitting the EPOLL_CTL_DISABLE 
patch to help reduce the possibility that the v2 patch still contains bugs.

Pat


>Christof
>
>--
>
>http://cmeerw.org                              sip:cmeerw at cmeerw.org
>mailto:cmeerw at cmeerw.org                   xmpp:cmeerw at cmeerw.org

