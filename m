Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0C0NTM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 09:19:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53157 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab0C0NTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 09:19:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tYiBzp3OODJwLc81WS12yow4GDPFczL+r+JvnMZ9NfUpgKjJbYle13xmGs6FREK/to
         wKxXxwk2XdbuW0f+qvvvfDjXpoLNC+ujUIuGoqMbYjP1MRI4dfvcsaBEyrIUhJ7qCLf5
         Pi/5Jh0QKMzFgQRsPY4LLa9rvYBb5ul7DrTdU=
MIME-Version: 1.0
In-Reply-To: <84621a61003241255i74282f53v3bb0111808895401@mail.gmail.com>
References: <84621a61003240915p2a4ce6bbjd0c6bfb02ab05ba8@mail.gmail.com>
	 <4BAA4EE4.3090900@nortel.com>
	 <84621a61003241128x3afbcea1w387aeaa68c887320@mail.gmail.com>
	 <4BAA69BF.3080600@nortel.com>
	 <84621a61003241255i74282f53v3bb0111808895401@mail.gmail.com>
Date: Sat, 27 Mar 2010 08:19:09 -0500
Message-ID: <84621a61003270619p6b4fe81bi24bb1961aba77ffb@mail.gmail.com>
Subject: Re: behavior of recvmmsg() on blocking sockets
From: Brandon Black <blblack@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 2:55 PM, Brandon Black <blblack@gmail.com> wrote:
> On Wed, Mar 24, 2010 at 2:36 PM, Chris Friesen <cfriesen@nortel.com> wrote:
>> Consider the case where you want to do some other useful work in
>> addition to running your network server.  Every cpu cycle spent on the
>> network server is robbed from the other work.  In this scenario you want
>> to handle packets as efficiently as possible, so the timeout-based
>> behaviour is better since it is more likely to give you multiple packets
>> per syscall.
>
> That's a good point, I tend to tunnelvision on the dedicated server
> scenario.  I should probably have a user-level option for
> timeout-based operation as well, since the decision here gets to the
> systems admin/engineering level and will be situational.

I've been playing with the timeout argument to recvmmsg as well now,
and I'm struggling to see how one would ever use it correctly with the
current implementation.  It seems to rely on the assumption of a
never-ending stream of tightly-spaced input packets?  It seems like it
was meant for usage on blocking sockets.  Given a blocking socket with
timeout 0 (infinite), and a recvmmsg timeout of 100us, if you had a
very steady stream of input packets, it recvmmsg would pull in all of
them that it could within a max timeframe of (100us +
time_to_execute_one_recvmsg).  However, any disruption to the input
stream for a time-window of N would result in delaying some
already-received packets by N.  For example, consider the case that 2
packets are already queued when you invoke recvmmsg(), but then the
next packet doesn't arrive for another 300ms.  In this scenario, you'd
end up with recvmmsg() blocking for 300ms and then returning all 3
packets, two of which have been delayed way beyond the specified
timeout.

-- Brandon
