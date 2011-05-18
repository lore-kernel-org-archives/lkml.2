Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab1ERONJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:13:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57359 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab1ERONH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MSFz+nN2m+Oq38utNDDv9TwlxRsn5TiXZd7WU4J9M3tN0yiKOxkn3KKvh4il6f8qoH
         4eYMZD7XYgIgoi4FQ3s/3lVsjDRww+B0yJ/pSmUMxF1IxQpoPBulD4p3MeTAVVRsCLd7
         pVJV0hIcwdLc+dw7GF9G1fsFZ5BjMGMPm6QnI=
MIME-Version: 1.0
In-Reply-To: <20110518133352.GE3762520@jupiter.n2.diac24.net>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
	<20110518124307.GD3762520@jupiter.n2.diac24.net>
	<BANLkTikmrC86hk=W84UBwhJLe_uGAN4w9w@mail.gmail.com>
	<20110518133352.GE3762520@jupiter.n2.diac24.net>
Date: Wed, 18 May 2011 17:13:05 +0300
Message-ID: <BANLkTinx1i3UJ86xw8KdvF+dQ1-qNZfFtA@mail.gmail.com>
Subject: Re: Identifying network namespaces (was: Network namespace
 manipulation with file descriptors)
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Lamparter <equinox@diac24.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jamal <hadi@cyberus.ca>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 4:33 PM, David Lamparter <equinox@diac24.net> wrote:
> On Wed, May 18, 2011 at 04:03:03PM +0300, Alexey Dobriyan wrote:
>> On Wed, May 18, 2011 at 3:43 PM, David Lamparter <equinox@diac24.net> wrote:
>> > -   processes cannot easily be cross referenced with each other
>> >
>> >  in the case of user space stuff running astray - like management
>> >  software crashing, routing daemons screwing up, etc. - it becomes
>> >  fairly difficult to shut down a network namespace (or even reaquire
>> >  physical devices that have been reassigned)
>>
>> It shutdowns itself when last process using netns disappeares,
>> so if you kill your routing daemons you should be fine.
>> Physical netdevices are moved to init_net.
>
> Now assume I'm running pptpd, which forks a new pppd for each
> connection. Even if I kill pptpd, the pppd keeps running... now how do I
> find the pppds that belong to that one namespace that I'm trying to
> get rid of?

That's a valid question.

>> > So, considering this set of premises (feedback welcome) I looked for
>> > some suitable means of identification. I discarded going for any process
>> > identifiers since Eric's patches allow for network namespaces without
>> > any process holding a reference, using bind mounts instead.
>>
>> If anything it should be netns->id, /proc/*/netns outputting id
>> where id is not derived from kernel pointer.

Actually it should be symlink
/proc/net/netns -> 0         # for init_net
/proc/net/netns -> u32 (> 0)   # for the rest
to extract information by 1 syscall, not 3
where netns id is totally random, so userspace won't make assumptions.
