Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab1EEDyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 23:54:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752528Ab1EEDyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 23:54:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110504212635.GE1804@nowhere>
References: <1304467520-31530-1-git-send-email-vnagarnaik@google.com>
 <BANLkTimorXOLcvB2dwXMAH8n2UU-C2ntcA@mail.gmail.com> <20110504212635.GE1804@nowhere>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2011 20:53:39 -0700
Message-ID: <BANLkTimMvEyzG-S=S6R4fVsui-9ok63jwg@mail.gmail.com>
Subject: Re: [PATCH] trace: Check for waiting readers before calling wakeup()
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 2:26 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, May 04, 2011 at 02:21:28PM -0700, Vaibhav Nagarnaik wrote:
>> Steven, Frederic
>>
>> Does this patch look ok?
>>
>> Vaibhav Nagarnaik
>>
>
> No problem for me. I'll let Steve give the last word.

Almost every time somebody does this optimization, there's a race.

The thing is, because waitqueue_active() implies no barriers, if there
is somebody adding itself to the waitqueue just at the same time as
somebody is waking things up, the waiter may lose wakeup events -
there is no memory barriers to guarantee that the waker will see
either the waiter, or the waiter will see the event that it waited
for.

I dunno. It's sometimes safe, but it's equally often not safe unless
there is some other locking around the thing. So I'd be a bit nervous.
The tracer people would need to do some serious thinking about it.

                   Linus
