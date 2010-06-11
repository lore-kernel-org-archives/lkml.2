Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745Ab0FKLRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 07:17:42 -0400
Received: from lirone.symas.net ([64.71.152.235]:37462 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab0FKLRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 07:17:40 -0400
Message-ID: <4C121B4C.2000702@symas.com>
Date: Fri, 11 Jun 2010 04:17:32 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: EXTPROC, telnetd LINEMODE, revisited
References: <4C120D8A.8050207@symas.com> <87631pq2aj.fsf@basil.nowhere.org>
In-Reply-To: <87631pq2aj.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Howard Chu<hyc@symas.com>  writes:
>
>> It's been over 10 years since I looked at this last
>>
>> http://lkml.indiana.edu/hypermail/linux/kernel/9911.3/0650.html
>
> I would suggest you repost the patch.

Looks like my email got posted twice already (oops). The updated patch was 
attached each time, you didn't get it?

>> From a quick look it looks straight forward enough.

The patch I posted still isn't quite right; it lets all of the input fall thru 
the regular tty input code. If ICANON is set then the tty driver will parse 
and act on any control characters in the input, but since the input was 
already fully processed on the client, any control characters remaining in the 
input should just be passed through literally. That should be an easy thing to 
fix though.

>> Despite the fact that most people today have ready access to high
>> speed broadband networking today, I think the motivation for local
>> character processing is as great now as it was 10 years ago. I
>> regularly use an ssh client on an Android phone to keep tabs on my
>> servers when I'm away from my home base, and sometimes cellphone
>> connectivity can be extremely lossy, networks can be heavily
>> congested, etc... Waiting for character-at-a-time packet turnarounds
>> in these conditions can be pretty aggravating. Also, if you're
>
> I agree that it would be sometimes useful, I also had these
> problems.
>
>> unfortunate enough to need to get access to a machine while you're
>> roaming away from your home network, the per-byte roaming fees can be
>> murder. Both of these pain points can be minimized by using local
>> character processing and only sending complete lines to the remote
>> server.
>
> I have some doubts this really needs to be implemented in the kernel.
> Back in the old days it was important to save round trips
> to user space because CPUs were so slow, but these days I don't think
> that's an issue anymore for mere typing.
>
> Couldn't you implement it in screen or a similar pty based tool?

 From how I see it at the moment, everything still depends on the tty driver. 
Even if you devise some other mechanism, you still have to be able to 
intercept any ioctl's issued on the pty slave and Do The Right Thing with them 
in the daemon on the pty master. I guess, alternatively, you could set an 
environment variable in the child process that inherits the pty slave, that 
tells applications how to send commands out of band to the master, but that 
will require a lot more app-level coordination.

>> Another feature with readline is a command history buffer that can be
>> reviewed using Cursor Up/Down. Can/should we define this in the tty
>> driver too? Or perhaps rely on the client to implement its own command
>> buffer, and never mention this aspect on the wire protocol. Again,
>> given the purpose, it makes most sense to me to keep this feature on
>> the client side. But some coordination with the server would still be
>> useful. E.g., different programs can maintain their own persistent
>> command history files. It might be nice to have a way for the app to
>> signal to the client which command context to use for the current
>> history buffer, and keep them all separate. (Or not, I can see other
>> times where you'd just rather have it all as one stack.)
>
> e.g. history management is definitely something that should not
> be done in the kernel.

I definitely wasn't trying to suggest that the management occur in the kernel. 
Only that some mechanism for telling the client to toggle the feature on or 
off would be useful.

>> PS: if anyone knows where to send the patches for telnetd, please
>> email me. Looks like the upstream source hasn't been touched since
>> 2000.
>
> I think they're defacto maintained by the distributions.
>
> I would submit them to one of the big distributions and let
> that maintainer figure it out.

OK. Since it looks like the source code I'm working with came from Debian I'll 
start there, thanks.

> -Andi

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
