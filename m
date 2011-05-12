Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab1EMAAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 20:00:07 -0400
Received: from smtp-out.google.com ([74.125.121.67]:12635 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917Ab1EMAAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 20:00:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dE2NlUqhWNRE4FiGuTa1UtidXe5zWUJvLet49wnAYfj6lwWFbUt06nj4PbBMnfubKx
         ThEgvjYkYQJ5HTKDF5lg==
MIME-Version: 1.0
In-Reply-To: <4DCBFFF2.3030804@redhat.com>
References: <1305207413.18715.3.camel@gondor.retis>
	<4DCBF904.6040104@redhat.com>
	<BANLkTi=BnRCJ4S32S=+zNNOSTxmZsR6Jrg@mail.gmail.com>
	<4DCBFFF2.3030804@redhat.com>
Date: Thu, 12 May 2011 16:59:58 -0700
Message-ID: <BANLkTi=sbHRqgFfX3cV6XHPUKig3n-tkDA@mail.gmail.com>
Subject: Re: [PATCH] kvm: log directly from the guest to the host kvm buffer
From: Eric Northup <digitaleric@google.com>
To: Avi Kivity <avi@redhat.com>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, kvm@vger.kernel.org,
        joro@8bytes.org, agraf@suse.de, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 8:42 AM, Avi Kivity <avi@redhat.com> wrote:
>
> On 05/12/2011 06:39 PM, Dhaval Giani wrote:
>>
>> >
>> >  I think that one hypercall per trace is too expensive.  Tracing is meant to
>> >  be lightweight!  I think the guest can log to a buffer, which is flushed on
>> >  overflow or when a vmexit occurs.  That gives us automatic serialization
>> >  between a vcpu and the cpu it runs on, but not between a vcpu and a
>> >  different host cpu.
>> >
>>
>> hmm. So, basically, log all of these events, and then send them to the
>> host either on an exit, or when your buffer fills up. There is one
>> problem with approach though. One of the reasons I wanted this
>> approach was beacuse i wanted to co-relate the guest and the host
>> times. (which is why I kept is synchronous). I lose out that
>> information with what you say. However I see your point about the
>> overhead. I will think about this a bit more.
>
> You might use kvmclock to get a zero-exit (but not zero-cost) time which can be correlated.
>
> Another option is to use xadd on a shared memory area to have a global counter incremented.  However that can be slow on large machines, and is hard to do securely with multiple guests.

If the guest puts guest TSC into the buffer with each event, KVM can
convert guest->host time when it drains the buffers on the next
vmexit.  That's enough information to do an offline correlation of
guest and host events.
