Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab0C2RYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:24:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37929 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab0C2RYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BXmjdT5FxCy8/eEJS6LQQGWwcx1lhPwJjOXoXiGsdeHEb5WnjrDWepLTn+DaJa/w32
         Vp8TiMjubbdNRD0BZ6A5wKjCc7eNjgUUYfx2RjwqntpXDEvRbky8snF5MLkutW5gKQQ0
         DT5qrvWfUk0LZRdu1+J2ErC9hcAZKAOMc/ClI=
MIME-Version: 1.0
In-Reply-To: <4BB0D2CF.9040903@nortel.com>
References: <84621a61003240915p2a4ce6bbjd0c6bfb02ab05ba8@mail.gmail.com>
	 <4BAA4EE4.3090900@nortel.com>
	 <84621a61003241128x3afbcea1w387aeaa68c887320@mail.gmail.com>
	 <4BAA69BF.3080600@nortel.com>
	 <84621a61003241255i74282f53v3bb0111808895401@mail.gmail.com>
	 <84621a61003270619p6b4fe81bi24bb1961aba77ffb@mail.gmail.com>
	 <4BB0D2CF.9040903@nortel.com>
Date: Mon, 29 Mar 2010 12:24:51 -0500
Message-ID: <84621a61003291024r38121763o546e0f09e2d63bc3@mail.gmail.com>
Subject: Re: behavior of recvmmsg() on blocking sockets
From: Brandon Black <blblack@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 11:18 AM, Chris Friesen <cfriesen@nortel.com> wrote:
>
> prev = current time
> loop forever
>        cur = current time
>        timeout = max_latency - (cur - prev)
>        recvmmsg(timeout)
>        process all received messages
>        prev = cur
>
>
> Basically you determine the max latency you're willing to wait for a
> packet to be handled, then subtract the amount of time you spent
> processing messages from that and pass it into the recvmmsg() call as
> the timeout.  That way no messages will be delayed for longer than the
> max latency. (Not considering scheduling delays.)

With a blocking socket, you'd also need to set SO_RCVTIMEO on the
underlying socket to some value that makes sense and is below your max
latency, because recvmmsg()'s timeout argument only applies in-between
underlying recvmsg() calls, not during them.  You're going to spend a
lot of time spinning if max_latency is low and there are any gaps in
the input stream though.  I guess for some uses this must makes sense.

The other potential usage is with non-blocking sockets, in which case
the timeout argument is putting on upper boundary on how long
recvmmsg() can spend fetching packets from the queue before it must
return, even if more packets are available.  Seems like for a given
kernel and hardware you could accomplish the same by tuning the vlen
argument.  In either case though, it seems like if you're running into
your hard latency limit on a non-blocking packet fetch and there are
already more packets waiting, you're probably (at least) verging on
being unable to meet the latency requirement for (at least) some of
your packets due to a hard lack of CPU horsepower for the workload.

-- Brandon
